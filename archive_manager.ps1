param(
    [Parameter(Position=0, Mandatory=$true)]
    [string]$Action,

    [Parameter(Position=1)]
    [string]$ArchiveName,

    [Parameter(Position=2, ValueFromRemainingArguments=$true)]
    [string[]]$Files
)

$ErrorActionPreference = 'Stop'

switch ($Action.ToLower()) {
    "create" {
        if (-not $ArchiveName -or -not $Files) {
            Write-Host "Usage: archive_manager create <archive_name> <files/folders...>" -ForegroundColor Red
            Write-Host "Supported formats: .zip, .7z" -ForegroundColor Yellow
            exit 1
        }

        $extension = [System.IO.Path]::GetExtension($ArchiveName).ToLower()

        switch ($extension) {
            ".zip" {
                Write-Host "Creating ZIP archive: $ArchiveName" -ForegroundColor Cyan

                try {
                    # Check if all files/folders exist
                    foreach ($file in $Files) {
                        if (!(Test-Path $file)) {
                            Write-Host "File/folder not found: $file" -ForegroundColor Red
                            exit 1
                        }
                    }

                    # Create archive
                    Compress-Archive -Path $Files -DestinationPath $ArchiveName -Force
                    Write-Host "ZIP archive created: $ArchiveName" -ForegroundColor Green
                } catch {
                    Write-Host "Failed to create ZIP archive: $($_.Exception.Message)" -ForegroundColor Red
                }
            }

            ".7z" {
                Write-Host "Creating 7Z archive: $ArchiveName" -ForegroundColor Cyan

                if (Get-Command 7z -ErrorAction SilentlyContinue) {
                    try {
                        & 7z a $ArchiveName @Files
                        Write-Host "7Z archive created: $ArchiveName" -ForegroundColor Green
                    } catch {
                        Write-Host "Failed to create 7Z archive: $($_.Exception.Message)" -ForegroundColor Red
                    }
                } else {
                    Write-Host "7-Zip not found. Please install 7-Zip to create .7z archives." -ForegroundColor Red
                    Write-Host "Alternatively, use .zip format which is natively supported." -ForegroundColor Yellow
                }
            }

            default {
                Write-Host "Unsupported format. Use .zip or .7z extension" -ForegroundColor Red
                exit 1
            }
        }
    }

    "extract" {
        if (-not $ArchiveName) {
            Write-Host "Usage: archive_manager extract <archive_file>" -ForegroundColor Red
            exit 1
        }

        if (!(Test-Path $ArchiveName)) {
            Write-Host "Archive file not found: $ArchiveName" -ForegroundColor Red
            exit 1
        }

        Write-Host "Extracting: $ArchiveName" -ForegroundColor Cyan
        $extension = [System.IO.Path]::GetExtension($ArchiveName).ToLower()

        try {
            switch ($extension) {
                ".zip" {
                    Expand-Archive -Path $ArchiveName -DestinationPath "." -Force
                    Write-Host "ZIP archive extracted successfully." -ForegroundColor Green
                }

                { $_ -in @(".7z", ".rar") } {
                    if (Get-Command 7z -ErrorAction SilentlyContinue) {
                        & 7z x $ArchiveName
                        Write-Host "$extension archive extracted successfully." -ForegroundColor Green
                    } else {
                        Write-Host "7-Zip not found. Please install 7-Zip to extract $extension files." -ForegroundColor Red
                    }
                }

                { $_ -in @(".tar", ".gz", ".tgz") } {
                    if (Get-Command tar -ErrorAction SilentlyContinue) {
                        if ($extension -eq ".tar") {
                            & tar -xf $ArchiveName
                        } else {
                            & tar -xzf $ArchiveName
                        }
                        Write-Host "TAR archive extracted successfully." -ForegroundColor Green
                    } else {
                        Write-Host "tar command not found. Use Windows Subsystem for Linux or install tar." -ForegroundColor Red
                    }
                }

                default {
                    Write-Host "Unsupported archive format: $extension" -ForegroundColor Red
                    Write-Host "Supported formats: .zip, .7z, .rar, .tar, .gz, .tgz" -ForegroundColor Yellow
                }
            }
        } catch {
            Write-Host "Failed to extract archive: $($_.Exception.Message)" -ForegroundColor Red
        }
    }

    "list" {
        if (-not $ArchiveName) {
            Write-Host "Usage: archive_manager list <archive_file>" -ForegroundColor Red
            exit 1
        }

        if (!(Test-Path $ArchiveName)) {
            Write-Host "Archive file not found: $ArchiveName" -ForegroundColor Red
            exit 1
        }

        Write-Host "Contents of: $ArchiveName" -ForegroundColor Cyan
        $extension = [System.IO.Path]::GetExtension($ArchiveName).ToLower()

        try {
            switch ($extension) {
                ".zip" {
                    Add-Type -AssemblyName System.IO.Compression.FileSystem
                    $archive = [System.IO.Compression.ZipFile]::OpenRead($ArchiveName)

                    Write-Host "Files in archive:" -ForegroundColor Yellow
                    $archive.Entries | ForEach-Object {
                        $size = if ($_.Length -gt 1MB) {
                            "{0:N2} MB" -f ($_.Length / 1MB)
                        } elseif ($_.Length -gt 1KB) {
                            "{0:N2} KB" -f ($_.Length / 1KB)
                        } else {
                            "$($_.Length) bytes"
                        }
                        Write-Host "  $($_.FullName) ($size)" -ForegroundColor White
                    }
                    $archive.Dispose()
                }

                { $_ -in @(".7z", ".rar") } {
                    if (Get-Command 7z -ErrorAction SilentlyContinue) {
                        & 7z l $ArchiveName
                    } else {
                        Write-Host "7-Zip not found. Cannot list $extension archive contents." -ForegroundColor Red
                    }
                }

                { $_ -in @(".tar", ".gz", ".tgz") } {
                    if (Get-Command tar -ErrorAction SilentlyContinue) {
                        if ($extension -eq ".tar") {
                            & tar -tf $ArchiveName
                        } else {
                            & tar -tzf $ArchiveName
                        }
                    } else {
                        Write-Host "tar command not found. Cannot list TAR archive contents." -ForegroundColor Red
                    }
                }

                default {
                    Write-Host "Listing not supported for this format: $extension" -ForegroundColor Red
                }
            }
        } catch {
            Write-Host "Failed to list archive contents: $($_.Exception.Message)" -ForegroundColor Red
        }
    }

    "info" {
        if (-not $ArchiveName) {
            Write-Host "Usage: archive_manager info <archive_file>" -ForegroundColor Red
            exit 1
        }

        if (!(Test-Path $ArchiveName)) {
            Write-Host "Archive file not found: $ArchiveName" -ForegroundColor Red
            exit 1
        }

        $file = Get-Item $ArchiveName
        $size = if ($file.Length -gt 1GB) {
            "{0:N2} GB" -f ($file.Length / 1GB)
        } elseif ($file.Length -gt 1MB) {
            "{0:N2} MB" -f ($file.Length / 1MB)
        } else {
            "{0:N2} KB" -f ($file.Length / 1KB)
        }

        Write-Host "=== Archive Information ===" -ForegroundColor Cyan
        Write-Host "File: $($file.Name)" -ForegroundColor White
        Write-Host "Size: $size" -ForegroundColor White
        Write-Host "Created: $($file.CreationTime)" -ForegroundColor White
        Write-Host "Modified: $($file.LastWriteTime)" -ForegroundColor White
        Write-Host "Type: $($file.Extension.ToUpper())" -ForegroundColor White
    }

    default {
        Write-Host "Usage: archive_manager {create|extract|list|info}" -ForegroundColor Yellow
        Write-Host "  create <archive> <files>  : Create new archive (.zip, .7z)" -ForegroundColor White
        Write-Host "  extract <archive>         : Extract archive" -ForegroundColor White
        Write-Host "  list <archive>           : List archive contents" -ForegroundColor White
        Write-Host "  info <archive>           : Show archive information" -ForegroundColor White
    }
}