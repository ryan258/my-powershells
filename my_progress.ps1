try {
    $gitCheck = git rev-parse --is-inside-work-tree 2>$null
    if ($gitCheck -ne "true") {
        Write-Host "This is not a Git repository. No progress to show." -ForegroundColor Red
        exit 1
    }
} catch {
    Write-Host "Git not available or not in a Git repository." -ForegroundColor Red
    exit 1
}

try {
    $userName = git config user.name

    Write-Host "--- Your Git Commits Since Yesterday ---" -ForegroundColor Green
    $yesterdayCommits = git log --oneline --author="$userName" --since="yesterday" 2>$null

    if ($yesterdayCommits) {
        $yesterdayCommits | ForEach-Object { Write-Host $_ -ForegroundColor White }
    } else {
        Write-Host "No commits found since yesterday." -ForegroundColor Yellow
    }

    Write-Host ""
    Write-Host "--- All Recent Commits (Last 7) ---" -ForegroundColor Cyan
    $recentCommits = git log --oneline -n 7 2>$null

    if ($recentCommits) {
        $recentCommits | ForEach-Object { Write-Host $_ -ForegroundColor White }
    } else {
        Write-Host "No recent commits found." -ForegroundColor Yellow
    }

    # Additional stats
    Write-Host ""
    Write-Host "--- This Week's Stats ---" -ForegroundColor Cyan

    $weekCommits = git log --author="$userName" --since="1 week ago" --oneline 2>$null
    $weekCommitCount = if ($weekCommits) { $weekCommits.Count } else { 0 }

    $weekAdditions = git log --author="$userName" --since="1 week ago" --pretty=tformat: --numstat 2>$null |
                    ForEach-Object { if ($_ -match '^(\d+)\s+(\d+)') { [int]$Matches[1] } } |
                    Measure-Object -Sum | Select-Object -ExpandProperty Sum

    $weekDeletions = git log --author="$userName" --since="1 week ago" --pretty=tformat: --numstat 2>$null |
                    ForEach-Object { if ($_ -match '^(\d+)\s+(\d+)') { [int]$Matches[2] } } |
                    Measure-Object -Sum | Select-Object -ExpandProperty Sum

    Write-Host "Commits this week: $weekCommitCount" -ForegroundColor Green
    Write-Host "Lines added: $($weekAdditions -or 0)" -ForegroundColor Green
    Write-Host "Lines deleted: $($weekDeletions -or 0)" -ForegroundColor Red

    # Show current branch
    Write-Host ""
    Write-Host "--- Current Branch ---" -ForegroundColor Cyan
    $currentBranch = git branch --show-current 2>$null
    if ($currentBranch) {
        Write-Host "Branch: $currentBranch" -ForegroundColor White

        # Check if there are uncommitted changes
        $status = git status --porcelain 2>$null
        if ($status) {
            Write-Host "Status: Uncommitted changes present" -ForegroundColor Yellow
        } else {
            Write-Host "Status: Working directory clean" -ForegroundColor Green
        }
    }

} catch {
    Write-Host "Error retrieving git information: $($_.Exception.Message)" -ForegroundColor Red
}