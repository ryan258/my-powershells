$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm"
Write-Host "=== Evening Wrap — $timestamp ===" -ForegroundColor Cyan

$TODO_FILE = "$env:USERPROFILE\.todo_list.txt"
if (Test-Path $TODO_FILE) {
    $tasks = Get-Content $TODO_FILE -ErrorAction SilentlyContinue
    if ($tasks -and $tasks.Count -gt 0) {
        Write-Host ""
        Write-Host "Open tasks:" -ForegroundColor Yellow
        for ($i = 0; $i -lt $tasks.Count; $i++) {
            Write-Host "$($i + 1). $($tasks[$i])"
        }
    }
}

try {
    $gitStatus = git rev-parse --is-inside-work-tree 2>$null
    if ($gitStatus -eq "true") {
        Write-Host ""
        Write-Host "Git status:" -ForegroundColor Green
        git status --short
    }
} catch {
    # Not in a git repo or git not available
}

Write-Host ""
Write-Host 'Tip: journal EOD → journal "EOD: progress, blockers, tomorrow"' -ForegroundColor Gray