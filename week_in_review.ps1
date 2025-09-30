Write-Host "========================================" -ForegroundColor Green
Write-Host "    Your Week in Review: $(Get-Date -Format 'yyyy-MM-dd')" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green

$weekAgo = (Get-Date).AddDays(-7).ToString("yyyy-MM-dd")

# --- Completed Tasks ---
$todoFile = "$env:USERPROFILE\.todo_done.txt"
if (Test-Path $todoFile) {
    Write-Host ""
    Write-Host "## Recently Completed Tasks ##" -ForegroundColor Cyan

    $recentTasks = Get-Content $todoFile | Where-Object {
        if ($_ -match '\[(\d{4}-\d{2}-\d{2})') {
            $taskDate = $Matches[1]
            $taskDate -ge $weekAgo
        }
    }

    if ($recentTasks) {
        $recentTasks | ForEach-Object { Write-Host $_ -ForegroundColor White }
    } else {
        Write-Host "No completed tasks found in the last week." -ForegroundColor Yellow
    }
}

# --- Journal Entries ---
$journalFile = "$env:USERPROFILE\journal.txt"
if (Test-Path $journalFile) {
    Write-Host ""
    Write-Host "## Recent Journal Entries ##" -ForegroundColor Cyan

    $recentEntries = Get-Content $journalFile | Where-Object {
        if ($_ -match '\[(\d{4}-\d{2}-\d{2})') {
            $entryDate = $Matches[1]
            $entryDate -ge $weekAgo
        }
    }

    if ($recentEntries) {
        $recentEntries | ForEach-Object { Write-Host $_ -ForegroundColor White }
    } else {
        Write-Host "No journal entries found in the last week." -ForegroundColor Yellow
    }
}

# --- Git Contributions (in current project) ---
try {
    $gitCheck = git rev-parse --is-inside-work-tree 2>$null
    if ($gitCheck -eq "true") {
        Write-Host ""
        Write-Host "## Git Contributions This Week ##" -ForegroundColor Cyan

        try {
            $userName = git config user.name
            $commits = git log --oneline --author="$userName" --since="1 week ago" 2>$null

            if ($commits) {
                $commits | ForEach-Object { Write-Host $_ -ForegroundColor White }
            } else {
                Write-Host "No commits found in the last week." -ForegroundColor Yellow
            }
        } catch {
            Write-Host "Unable to retrieve git commits." -ForegroundColor Yellow
        }
    }
} catch {
    # Not in a git repo or git not available
}

# --- Recent File Activity ---
Write-Host ""
Write-Host "## Recently Modified Files ##" -ForegroundColor Cyan

$recentFiles = Get-ChildItem -Path @(
    "$env:USERPROFILE\Documents",
    "$env:USERPROFILE\Desktop"
) -File -Recurse -ErrorAction SilentlyContinue |
Where-Object { $_.LastWriteTime -gt (Get-Date).AddDays(-7) } |
Sort-Object LastWriteTime -Descending |
Select-Object -First 10

if ($recentFiles) {
    $recentFiles | ForEach-Object {
        $age = [math]::Round(((Get-Date) - $_.LastWriteTime).TotalDays, 1)
        $relativePath = $_.FullName -replace [regex]::Escape($env:USERPROFILE), "~"
        Write-Host "$relativePath ($age days ago)" -ForegroundColor White
    }
} else {
    Write-Host "No recently modified files found." -ForegroundColor Yellow
}

# --- Health Break Summary ---
$healthLog = "$env:USERPROFILE\health_breaks.log"
if (Test-Path $healthLog) {
    Write-Host ""
    Write-Host "## Health Breaks This Week ##" -ForegroundColor Cyan

    $recentBreaks = Get-Content $healthLog | Where-Object {
        if ($_ -match '\[(\d{4}-\d{2}-\d{2})') {
            $breakDate = $Matches[1]
            $breakDate -ge $weekAgo
        }
    }

    if ($recentBreaks) {
        $breakCount = $recentBreaks.Count
        $totalMinutes = ($recentBreaks | ForEach-Object {
            if ($_ -match '(\d+) minute') { [int]$Matches[1] }
        } | Measure-Object -Sum).Sum

        Write-Host "Total breaks taken: $breakCount" -ForegroundColor Green
        Write-Host "Total break time: $totalMinutes minutes" -ForegroundColor Green
    } else {
        Write-Host "No health breaks recorded this week." -ForegroundColor Yellow
    }
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Green