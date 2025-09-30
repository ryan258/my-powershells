param(
    [Parameter(Position=0, Mandatory=$true)]
    [string]$Mode
)

$ErrorActionPreference = 'Stop'

switch ($Mode.ToLower()) {
    "bytype" {
        Write-Host "Organizing files by type..." -ForegroundColor Cyan

        $folders = @("Documents", "Images", "Audio", "Video", "Archives", "Code")
        foreach ($folder in $folders) {
            if (!(Test-Path $folder)) {
                New-Item -Path $folder -ItemType Directory | Out-Null
            }
        }

        Get-ChildItem -File | ForEach-Object {
            $file = $_
            $extension = $file.Extension.ToLower().TrimStart('.')

            switch ($extension) {
                {$_ -in @("txt", "doc", "docx", "pdf", "rtf", "pages")} {
                    Move-Item $file.FullName "Documents\"
                    Write-Host "Moved $($file.Name) to Documents/" -ForegroundColor Green
                }
                {$_ -in @("jpg", "jpeg", "png", "gif", "bmp", "tiff", "heic", "webp")} {
                    Move-Item $file.FullName "Images\"
                    Write-Host "Moved $($file.Name) to Images/" -ForegroundColor Green
                }
                {$_ -in @("mp3", "wav", "aiff", "m4a", "flac", "aac")} {
                    Move-Item $file.FullName "Audio\"
                    Write-Host "Moved $($file.Name) to Audio/" -ForegroundColor Green
                }
                {$_ -in @("mp4", "mov", "avi", "mkv", "wmv", "m4v")} {
                    Move-Item $file.FullName "Video\"
                    Write-Host "Moved $($file.Name) to Video/" -ForegroundColor Green
                }
                {$_ -in @("zip", "tar", "gz", "rar", "7z", "bz2")} {
                    Move-Item $file.FullName "Archives\"
                    Write-Host "Moved $($file.Name) to Archives/" -ForegroundColor Green
                }
                {$_ -in @("js", "py", "ps1", "php", "html", "css", "swift", "c", "cpp", "cs", "java")} {
                    Move-Item $file.FullName "Code\"
                    Write-Host "Moved $($file.Name) to Code/" -ForegroundColor Green
                }
                default {
                    Write-Host "Skipped $($file.Name) (unknown type)" -ForegroundColor Yellow
                }
            }
        }
    }

    "bydate" {
        Write-Host "Organizing files by date..." -ForegroundColor Cyan

        Get-ChildItem -File | ForEach-Object {
            $file = $_
            $year = $file.CreationTime.Year
            $month = $file.CreationTime.Month.ToString("00")

            $targetPath = "$year\$month"
            if (!(Test-Path $targetPath)) {
                New-Item -Path $targetPath -ItemType Directory -Force | Out-Null
            }

            Move-Item $file.FullName $targetPath
            Write-Host "Moved $($file.Name) to $targetPath/" -ForegroundColor Green
        }
    }

    "bysize" {
        Write-Host "Organizing files by size..." -ForegroundColor Cyan

        $sizeFolders = @(
            "Small (< 1MB)",
            "Medium (1-10MB)",
            "Large (10-100MB)",
            "XLarge (> 100MB)"
        )

        foreach ($folder in $sizeFolders) {
            if (!(Test-Path $folder)) {
                New-Item -Path $folder -ItemType Directory | Out-Null
            }
        }

        Get-ChildItem -File | ForEach-Object {
            $file = $_
            $sizeBytes = $file.Length

            if ($sizeBytes -lt 1MB) {
                $targetFolder = "Small (< 1MB)"
            } elseif ($sizeBytes -lt 10MB) {
                $targetFolder = "Medium (1-10MB)"
            } elseif ($sizeBytes -lt 100MB) {
                $targetFolder = "Large (10-100MB)"
            } else {
                $targetFolder = "XLarge (> 100MB)"
            }

            Move-Item $file.FullName $targetFolder
            Write-Host "Moved $($file.Name) to $targetFolder/" -ForegroundColor Green
        }
    }

    default {
        Write-Host "Usage: file_organizer {bytype|bydate|bysize}" -ForegroundColor Yellow
        Write-Host "  bytype  : Organize files by file type" -ForegroundColor White
        Write-Host "  bydate  : Organize files by creation date" -ForegroundColor White
        Write-Host "  bysize  : Organize files by size" -ForegroundColor White
    }
}