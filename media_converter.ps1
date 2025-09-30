param(
    [Parameter(Position=0, Mandatory=$true)]
    [string]$Action,

    [Parameter(Position=1)]
    [string]$InputFile,

    [Parameter(Position=2)]
    [string]$Parameter
)

$ErrorActionPreference = 'Stop'

function Format-FileSize {
    param([long]$Bytes)

    $units = @("B", "KB", "MB", "GB", "TB")
    $index = 0
    $size = [double]$Bytes

    while ($size -ge 1024 -and $index -lt ($units.Length - 1)) {
        $size /= 1024
        $index++
    }

    return "{0:N1} {1}" -f $size, $units[$index]
}

switch ($Action.ToLower()) {
    "video2audio" {
        if (-not $InputFile) {
            Write-Host "Usage: media_converter video2audio <video_file>" -ForegroundColor Red
            Write-Host "Requires: ffmpeg (install with: winget install ffmpeg or choco install ffmpeg)" -ForegroundColor Yellow
            exit 1
        }

        if (!(Test-Path $InputFile)) {
            Write-Host "Video file not found: $InputFile" -ForegroundColor Red
            exit 1
        }

        if (!(Get-Command ffmpeg -ErrorAction SilentlyContinue)) {
            Write-Host "ffmpeg not found. Install with:" -ForegroundColor Red
            Write-Host "  winget install ffmpeg" -ForegroundColor Yellow
            Write-Host "  or: choco install ffmpeg" -ForegroundColor Yellow
            exit 1
        }

        $audioFile = [System.IO.Path]::ChangeExtension($InputFile, ".mp3")

        Write-Host "Converting $InputFile to $audioFile..." -ForegroundColor Cyan

        try {
            & ffmpeg -i $InputFile -q:a 0 -map a $audioFile
            Write-Host "Conversion complete: $audioFile" -ForegroundColor Green
        } catch {
            Write-Host "Conversion failed: $($_.Exception.Message)" -ForegroundColor Red
        }
    }

    "resize_image" {
        if (-not $InputFile -or -not $Parameter) {
            Write-Host "Usage: media_converter resize_image <image_file> <width>" -ForegroundColor Red
            Write-Host "Example: media_converter resize_image photo.jpg 800" -ForegroundColor Yellow
            Write-Host "Requires: ImageMagick (install with: winget install ImageMagick)" -ForegroundColor Yellow
            exit 1
        }

        if (!(Test-Path $InputFile)) {
            Write-Host "Image file not found: $InputFile" -ForegroundColor Red
            exit 1
        }

        $width = $Parameter
        if (-not ($width -as [int])) {
            Write-Host "Width must be a number" -ForegroundColor Red
            exit 1
        }

        $fileInfo = Get-Item $InputFile
        $nameWithoutExt = [System.IO.Path]::GetFileNameWithoutExtension($InputFile)
        $extension = $fileInfo.Extension
        $outputFile = "${nameWithoutExt}_${width}px${extension}"

        # Try different ImageMagick commands
        $magickCommands = @("magick", "convert")
        $commandFound = $false

        foreach ($cmd in $magickCommands) {
            if (Get-Command $cmd -ErrorAction SilentlyContinue) {
                Write-Host "Resizing $InputFile to ${width}px width..." -ForegroundColor Cyan

                try {
                    & $cmd $InputFile -resize "${width}x" $outputFile
                    Write-Host "Resized image saved as: $outputFile" -ForegroundColor Green
                    $commandFound = $true
                    break
                } catch {
                    Write-Host "Resize failed with $cmd: $($_.Exception.Message)" -ForegroundColor Red
                }
            }
        }

        if (-not $commandFound) {
            Write-Host "ImageMagick not found. Install with:" -ForegroundColor Red
            Write-Host "  winget install ImageMagick.ImageMagick" -ForegroundColor Yellow
            Write-Host "  or: choco install imagemagick" -ForegroundColor Yellow
        }
    }

    "pdf_compress" {
        if (-not $InputFile) {
            Write-Host "Usage: media_converter pdf_compress <pdf_file>" -ForegroundColor Red
            Write-Host "Requires: Ghostscript (install with: winget install ArtifexSoftware.GhostScript)" -ForegroundColor Yellow
            exit 1
        }

        if (!(Test-Path $InputFile)) {
            Write-Host "PDF file not found: $InputFile" -ForegroundColor Red
            exit 1
        }

        $compressedFile = [System.IO.Path]::ChangeExtension($InputFile, "_compressed.pdf")

        # Try different Ghostscript commands
        $gsCommands = @("gs", "gswin64c", "gswin32c")
        $commandFound = $false

        foreach ($cmd in $gsCommands) {
            if (Get-Command $cmd -ErrorAction SilentlyContinue) {
                Write-Host "Compressing $InputFile..." -ForegroundColor Cyan

                try {
                    & $cmd -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=/screen -dNOPAUSE -dQUIET -dBATCH -sOutputFile=$compressedFile $InputFile
                    Write-Host "Compressed PDF saved as: $compressedFile" -ForegroundColor Green

                    # Show size comparison
                    $originalSize = (Get-Item $InputFile).Length
                    $compressedSize = (Get-Item $compressedFile).Length

                    Write-Host "Original size: $(Format-FileSize $originalSize)" -ForegroundColor White
                    Write-Host "Compressed size: $(Format-FileSize $compressedSize)" -ForegroundColor White

                    $savings = [math]::Round((($originalSize - $compressedSize) / $originalSize) * 100, 1)
                    Write-Host "Space saved: $savings%" -ForegroundColor Green

                    $commandFound = $true
                    break
                } catch {
                    Write-Host "Compression failed with $cmd: $($_.Exception.Message)" -ForegroundColor Red
                }
            }
        }

        if (-not $commandFound) {
            Write-Host "Ghostscript not found. Install with:" -ForegroundColor Red
            Write-Host "  winget install ArtifexSoftware.GhostScript" -ForegroundColor Yellow
            Write-Host "  or: choco install ghostscript" -ForegroundColor Yellow
        }
    }

    "video_compress" {
        if (-not $InputFile) {
            Write-Host "Usage: media_converter video_compress <video_file>" -ForegroundColor Red
            Write-Host "Requires: ffmpeg" -ForegroundColor Yellow
            exit 1
        }

        if (!(Test-Path $InputFile)) {
            Write-Host "Video file not found: $InputFile" -ForegroundColor Red
            exit 1
        }

        if (!(Get-Command ffmpeg -ErrorAction SilentlyContinue)) {
            Write-Host "ffmpeg not found. Install with winget install ffmpeg" -ForegroundColor Red
            exit 1
        }

        $fileInfo = Get-Item $InputFile
        $nameWithoutExt = [System.IO.Path]::GetFileNameWithoutExtension($InputFile)
        $compressedFile = "${nameWithoutExt}_compressed.mp4"

        Write-Host "Compressing $InputFile..." -ForegroundColor Cyan

        try {
            & ffmpeg -i $InputFile -vcodec h264 -acodec mp2 $compressedFile
            Write-Host "Compressed video saved as: $compressedFile" -ForegroundColor Green

            # Show size comparison
            $originalSize = $fileInfo.Length
            $compressedSize = (Get-Item $compressedFile).Length

            Write-Host "Original size: $(Format-FileSize $originalSize)" -ForegroundColor White
            Write-Host "Compressed size: $(Format-FileSize $compressedSize)" -ForegroundColor White
        } catch {
            Write-Host "Compression failed: $($_.Exception.Message)" -ForegroundColor Red
        }
    }

    default {
        Write-Host "Usage: media_converter {video2audio|resize_image|pdf_compress|video_compress}" -ForegroundColor Yellow
        Write-Host "  video2audio <file>        : Extract audio from video (requires ffmpeg)" -ForegroundColor White
        Write-Host "  resize_image <file> <w>   : Resize image to specified width (requires ImageMagick)" -ForegroundColor White
        Write-Host "  pdf_compress <file>       : Compress PDF file (requires Ghostscript)" -ForegroundColor White
        Write-Host "  video_compress <file>     : Compress video file (requires ffmpeg)" -ForegroundColor White
        Write-Host ""
        Write-Host "Installation commands:" -ForegroundColor Cyan
        Write-Host "  winget install ffmpeg" -ForegroundColor Gray
        Write-Host "  winget install ImageMagick.ImageMagick" -ForegroundColor Gray
        Write-Host "  winget install ArtifexSoftware.GhostScript" -ForegroundColor Gray
    }
}