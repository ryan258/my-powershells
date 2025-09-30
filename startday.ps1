Write-Host "Good morning! It is currently $(Get-Date)" -ForegroundColor Green
Write-Host "----------------------------------------" -ForegroundColor Cyan

$possibleDirs = @(
    "$env:USERPROFILE\projects",
    "$env:USERPROFILE\Documents\projects",
    "$env:USERPROFILE\Documents",
    "$env:USERPROFILE\Desktop"
)

$targetDir = $null
foreach ($dir in $possibleDirs) {
    if (Test-Path $dir) {
        $targetDir = $dir
        break
    }
}

if ($targetDir) {
    Write-Host "Suggested workspace: $targetDir" -ForegroundColor Yellow
    Write-Host "Tip: Use 'Set-Location `"$targetDir`"' to navigate there." -ForegroundColor Gray
}

$TODO_FILE = "$env:USERPROFILE\.todo_list.txt"
if (Test-Path $TODO_FILE) {
    $tasks = Get-Content $TODO_FILE
    if ($tasks -and $tasks.Count -gt 0) {
        Write-Host ""
        Write-Host "Your TODOs for today:" -ForegroundColor Cyan
        for ($i = 0; $i -lt $tasks.Count; $i++) {
            Write-Host "$($i + 1). $($tasks[$i])"
        }
    }
}

Write-Host ""
Write-Host "Have a productive day!" -ForegroundColor Green