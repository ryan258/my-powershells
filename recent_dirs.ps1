param(
    [Parameter(Position=0)]
    [string]$Action
)

$HISTORY_FILE = "$env:USERPROFILE\.dir_history.txt"
$MAX_HISTORY = 20

function Add-ToHistory {
    $currentDir = Get-Location
    Add-Content -Path $HISTORY_FILE -Value $currentDir

    if (Test-Path $HISTORY_FILE) {
        $lines = Get-Content $HISTORY_FILE
        if ($lines.Count -gt $MAX_HISTORY) {
            $lines | Select-Object -Last $MAX_HISTORY | Set-Content $HISTORY_FILE
        }
    }
}

if ($Action -eq "add") {
    Add-ToHistory
    exit 0
}

if (!(Test-Path $HISTORY_FILE)) {
    Write-Host "No directory history found." -ForegroundColor Yellow
    Write-Host "Start building history by running this command after each directory change:" -ForegroundColor Gray
    Write-Host "recent_dirs add" -ForegroundColor Gray
    exit 1
}

$recentDirs = Get-Content $HISTORY_FILE | Select-Object -Last 10
[array]::Reverse($recentDirs)

if ($recentDirs.Count -eq 0) {
    Write-Host "No recent directories found." -ForegroundColor Yellow
    exit 1
}

Write-Host "=== Recent Directories ===" -ForegroundColor Cyan
for ($i = 0; $i -lt $recentDirs.Count; $i++) {
    $dir = $recentDirs[$i]
    $displayPath = $dir -replace [regex]::Escape($env:USERPROFILE), "~"
    Write-Host "$($i + 1). $displayPath" -ForegroundColor White
}

Write-Host ""
$choice = Read-Host "Enter number to jump to (or Enter to cancel)"

if ($choice -match '^\d+$' -and [int]$choice -le $recentDirs.Count -and [int]$choice -gt 0) {
    $targetDir = $recentDirs[[int]$choice - 1]

    if (Test-Path $targetDir) {
        try {
            Set-Location $targetDir
            Write-Host "Jumped to: $targetDir" -ForegroundColor Green
        } catch {
            Write-Host "Failed to change directory to: $targetDir" -ForegroundColor Red
            Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
        }
    } else {
        Write-Host "Directory no longer exists: $targetDir" -ForegroundColor Red

        # Remove the invalid directory from history
        $validDirs = Get-Content $HISTORY_FILE | Where-Object { Test-Path $_ }
        $validDirs | Set-Content $HISTORY_FILE
        Write-Host "Removed invalid directory from history." -ForegroundColor Yellow
    }
} else {
    Write-Host "Cancelled or invalid choice." -ForegroundColor Yellow
}