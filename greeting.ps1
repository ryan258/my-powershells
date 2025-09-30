$hour = (Get-Date).Hour

if ($hour -lt 12) {
    $part = "morning"
} elseif ($hour -lt 18) {
    $part = "afternoon"
} else {
    $part = "evening"
}

Write-Host "Good $part, $env:USERNAME." -ForegroundColor Green

$weatherScript = Join-Path $PSScriptRoot "weather.ps1"
if (Test-Path $weatherScript) {
    try {
        & $weatherScript
    } catch {
        # Silent fail if weather script has issues
    }
}

$TODO_FILE = if ($env:TODO_FILE) { $env:TODO_FILE } else { "$env:USERPROFILE\.todo_list.txt" }
if (Test-Path $TODO_FILE) {
    $tasks = Get-Content $TODO_FILE -ErrorAction SilentlyContinue
    if ($tasks -and $tasks.Count -gt 0) {
        Write-Host ""
        Write-Host "Top tasks:" -ForegroundColor Cyan
        for ($i = 0; $i -lt [Math]::Min(5, $tasks.Count); $i++) {
            Write-Host " $($i + 1). $($tasks[$i])"
        }
    }
}

Write-Host ""
Write-Host 'Tip: add a note → journal "Started: <thing>"' -ForegroundColor Yellow