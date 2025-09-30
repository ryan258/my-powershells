param(
    [Parameter(Position=0)]
    [string]$SourcePath = ".",

    [Parameter(Position=1)]
    [string]$BackupLocation = "$env:USERPROFILE\Backups"
)

Write-Host "Starting backup of current project..." -ForegroundColor Cyan

$sourcePath = Resolve-Path $SourcePath
$projectName = Split-Path $sourcePath -Leaf

if (!(Test-Path $BackupLocation)) {
    New-Item -Path $BackupLocation -ItemType Directory -Force | Out-Null
    Write-Host "Created backup directory: $BackupLocation" -ForegroundColor Yellow
}

$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$backupName = "backup_${projectName}_${timestamp}"
$destinationPath = Join-Path $BackupLocation $backupName

Write-Host "Backing up $sourcePath to $destinationPath" -ForegroundColor Green

try {
    $excludePatterns = @(
        "node_modules",
        ".git",
        "bin",
        "obj",
        "*.tmp",
        "*.log",
        ".vscode",
        ".vs",
        "*.cache"
    )

    $robocopyArgs = @(
        "`"$sourcePath`"",
        "`"$destinationPath`"",
        "/MIR",  # Mirror directory tree
        "/R:3",  # Retry 3 times on failed copies
        "/W:1",  # Wait 1 second between retries
        "/MT:8", # Multi-threaded copying (8 threads)
        "/XD"    # Exclude directories
    )

    $robocopyArgs += $excludePatterns

    Write-Host "Using robocopy for efficient backup..." -ForegroundColor Yellow
    $result = & robocopy @robocopyArgs

    # Robocopy exit codes: 0-3 are success, >3 are errors
    if ($LASTEXITCODE -le 3) {
        Write-Host ""
        Write-Host "Backup complete! Files are safe at:" -ForegroundColor Green
        Write-Host "$destinationPath" -ForegroundColor White

        $backupSize = (Get-ChildItem -Path $destinationPath -Recurse | Measure-Object -Property Length -Sum).Sum
        $sizeFormatted = if ($backupSize -gt 1GB) {
            "{0:N2} GB" -f ($backupSize / 1GB)
        } elseif ($backupSize -gt 1MB) {
            "{0:N2} MB" -f ($backupSize / 1MB)
        } else {
            "{0:N2} KB" -f ($backupSize / 1KB)
        }

        Write-Host "Backup size: $sizeFormatted" -ForegroundColor Cyan
    } else {
        Write-Host "Backup completed with some errors (exit code: $LASTEXITCODE)" -ForegroundColor Yellow
        Write-Host "Location: $destinationPath" -ForegroundColor White
    }

} catch {
    Write-Host "Backup failed: $($_.Exception.Message)" -ForegroundColor Red

    # Fallback to PowerShell Copy-Item
    Write-Host "Attempting fallback backup method..." -ForegroundColor Yellow
    try {
        Copy-Item -Path $sourcePath -Destination $destinationPath -Recurse -Force
        Write-Host "Fallback backup complete!" -ForegroundColor Green
        Write-Host "Location: $destinationPath" -ForegroundColor White
    } catch {
        Write-Host "Fallback backup also failed: $($_.Exception.Message)" -ForegroundColor Red
        exit 1
    }
}