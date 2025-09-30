param(
    [Parameter(Position=0, Mandatory=$true)]
    [string]$FilePath
)

if (-not (Test-Path $FilePath)) {
    Write-Host "File '$FilePath' not found." -ForegroundColor Red
    exit 1
}

$file = Get-Item $FilePath
$extension = $file.Extension.ToLower()

Write-Host "Extracting $($file.Name)..." -ForegroundColor Cyan

try {
    switch ($extension) {
        ".zip" {
            Expand-Archive -Path $FilePath -DestinationPath "." -Force
            Write-Host "ZIP file extracted successfully." -ForegroundColor Green
        }

        ".7z" {
            if (Get-Command 7z -ErrorAction SilentlyContinue) {
                & 7z x $FilePath
                Write-Host "7Z file extracted successfully." -ForegroundColor Green
            } else {
                Write-Host "7-Zip not found. Please install 7-Zip to extract .7z files." -ForegroundColor Red
            }
        }

        ".rar" {
            if (Get-Command unrar -ErrorAction SilentlyContinue) {
                & unrar x $FilePath
                Write-Host "RAR file extracted successfully." -ForegroundColor Green
            } elseif (Get-Command 7z -ErrorAction SilentlyContinue) {
                & 7z x $FilePath
                Write-Host "RAR file extracted successfully using 7-Zip." -ForegroundColor Green
            } else {
                Write-Host "Neither unrar nor 7-Zip found. Please install one to extract .rar files." -ForegroundColor Red
            }
        }

        ".tar" {
            if (Get-Command tar -ErrorAction SilentlyContinue) {
                & tar -xf $FilePath
                Write-Host "TAR file extracted successfully." -ForegroundColor Green
            } else {
                Write-Host "tar command not found. Please install tar or use Windows Subsystem for Linux." -ForegroundColor Red
            }
        }

        default {
            if ($file.Name -match '\.(tar\.gz|tgz)$') {
                if (Get-Command tar -ErrorAction SilentlyContinue) {
                    & tar -xzf $FilePath
                    Write-Host "TAR.GZ file extracted successfully." -ForegroundColor Green
                } else {
                    Write-Host "tar command not found. Please install tar or use Windows Subsystem for Linux." -ForegroundColor Red
                }
            } else {
                Write-Host "'$($file.Name)' is not a recognized archive type." -ForegroundColor Yellow
                Write-Host "Supported formats: .zip, .7z, .rar, .tar, .tar.gz, .tgz" -ForegroundColor Yellow
            }
        }
    }
} catch {
    Write-Host "Error extracting file: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "Extraction complete." -ForegroundColor Cyan