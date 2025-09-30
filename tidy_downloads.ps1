param(
    [Parameter()]
    [switch]$DryRun,

    [Parameter()]
    [string]$DownloadsPath = "$env:USERPROFILE\Downloads"
)

if (!(Test-Path $DownloadsPath)) {
    Write-Host "Downloads folder not found: $DownloadsPath" -ForegroundColor Red
    exit 1
}

Set-Location $DownloadsPath
Write-Host "Tidying the Downloads folder: $DownloadsPath" -ForegroundColor Cyan

if ($DryRun) {
    Write-Host "[DRY RUN MODE] - No files will be moved" -ForegroundColor Yellow
    Write-Host ""
}

$movedCount = 0

$fileTypes = @{
    "Pictures" = @("jpg", "jpeg", "png", "gif", "heic", "bmp", "tiff", "webp")
    "Documents" = @("pdf", "doc", "docx", "txt", "rtf", "md", "pages", "odt")
    "Music" = @("mp3", "wav", "m4a", "aiff", "flac", "aac")
    "Videos" = @("mp4", "mov", "avi", "mkv", "wmv", "m4v")
    "Archives" = @("zip", "tar", "gz", "rar", "7z", "bz2")
}

foreach ($category in $fileTypes.Keys) {
    $extensions = $fileTypes[$category]
    $targetPath = if ($category -eq "Archives") {
        "$env:USERPROFILE\Documents\Archives"
    } else {
        "$env:USERPROFILE\$category"
    }

    if (!(Test-Path $targetPath)) {
        if ($DryRun) {
            Write-Host "[DRY RUN] Would create directory: $targetPath" -ForegroundColor Gray
        } else {
            New-Item -Path $targetPath -ItemType Directory -Force | Out-Null
            Write-Host "Created directory: $targetPath" -ForegroundColor Yellow
        }
    }

    Write-Host "Moving $($category.ToLower()) files..." -ForegroundColor Green

    foreach ($ext in $extensions) {
        $files = Get-ChildItem -Path "." -Filter "*.$ext" -File -ErrorAction SilentlyContinue

        foreach ($file in $files) {
            $destinationFile = Join-Path $targetPath $file.Name

            if (Test-Path $destinationFile) {
                $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
                $nameWithoutExt = [System.IO.Path]::GetFileNameWithoutExtension($file.Name)
                $extension = [System.IO.Path]::GetExtension($file.Name)
                $newName = "${nameWithoutExt}_${timestamp}${extension}"
                $destinationFile = Join-Path $targetPath $newName

                if ($DryRun) {
                    Write-Host "[DRY RUN] Would rename and move: $($file.Name) → $newName" -ForegroundColor Gray
                } else {
                    Write-Host "Renamed and moved: $($file.Name) → $newName" -ForegroundColor Cyan
                }
            }

            if ($DryRun) {
                Write-Host "[DRY RUN] Would move: $($file.Name) → $category" -ForegroundColor Gray
            } else {
                try {
                    Move-Item $file.FullName $destinationFile -Force
                    Write-Host "Moved: $($file.Name) → $category" -ForegroundColor White
                    $movedCount++
                } catch {
                    Write-Host "Failed to move $($file.Name): $($_.Exception.Message)" -ForegroundColor Red
                }
            }
        }
    }
}

Write-Host ""
Write-Host "Checking for old files (>30 days)..." -ForegroundColor Cyan
$oldFiles = Get-ChildItem -Path "." -File | Where-Object {
    $_.LastWriteTime -lt (Get-Date).AddDays(-30)
}

if ($oldFiles.Count -gt 0) {
    $oldFilesPath = "$env:USERPROFILE\Documents\Old Downloads"

    if (!(Test-Path $oldFilesPath)) {
        if ($DryRun) {
            Write-Host "[DRY RUN] Would create directory: $oldFilesPath" -ForegroundColor Gray
        } else {
            New-Item -Path $oldFilesPath -ItemType Directory -Force | Out-Null
            Write-Host "Created directory: $oldFilesPath" -ForegroundColor Yellow
        }
    }

    foreach ($file in $oldFiles) {
        $age = ((Get-Date) - $file.LastWriteTime).Days
        if ($DryRun) {
            Write-Host "[DRY RUN] Would move old file ($age days): $($file.Name)" -ForegroundColor Gray
        } else {
            try {
                $destination = Join-Path $oldFilesPath $file.Name
                if (Test-Path $destination) {
                    $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
                    $nameWithoutExt = [System.IO.Path]::GetFileNameWithoutExtension($file.Name)
                    $extension = [System.IO.Path]::GetExtension($file.Name)
                    $destination = Join-Path $oldFilesPath "${nameWithoutExt}_${timestamp}${extension}"
                }

                Move-Item $file.FullName $destination -Force
                Write-Host "Moved old file ($age days): $($file.Name)" -ForegroundColor Yellow
                $movedCount++
            } catch {
                Write-Host "Failed to move old file $($file.Name): $($_.Exception.Message)" -ForegroundColor Red
            }
        }
    }
}

Write-Host ""
if ($DryRun) {
    Write-Host "[DRY RUN] Downloads folder analysis complete!" -ForegroundColor Green
    Write-Host "Run without -DryRun to actually move files." -ForegroundColor Yellow
} else {
    Write-Host "Downloads folder tidied!" -ForegroundColor Green
    Write-Host "Total files moved: $movedCount" -ForegroundColor Cyan
}

$remainingFiles = (Get-ChildItem -Path "." -File).Count
if ($remainingFiles -gt 0) {
    Write-Host "Files remaining in Downloads: $remainingFiles" -ForegroundColor Yellow
}