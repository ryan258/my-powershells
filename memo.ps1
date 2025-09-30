param(
    [Parameter(Position=0)]
    [string]$Action = "add",

    [Parameter(Position=1, ValueFromRemainingArguments=$true)]
    [string[]]$MemoText
)

$MEMO_FILE = if ($env:MEMO_FILE) { $env:MEMO_FILE } else { "$env:USERPROFILE\Documents\memos.txt" }
$memoDir = Split-Path $MEMO_FILE -Parent

if (!(Test-Path $memoDir)) {
    New-Item -Path $memoDir -ItemType Directory -Force | Out-Null
}

switch ($Action.ToLower()) {
    "add" {
        if (-not $MemoText -or ($MemoText.Count -eq 0)) {
            Write-Host "Usage: memo add <text>" -ForegroundColor Red
            exit 1
        }
        $text = $MemoText -join " "
        $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        Add-Content -Path $MEMO_FILE -Value "$timestamp $text"
        Write-Host "Saved to $MEMO_FILE" -ForegroundColor Green
    }

    "list" {
        if (Test-Path $MEMO_FILE) {
            Get-Content $MEMO_FILE
        } else {
            Write-Host "No memos yet." -ForegroundColor Yellow
        }
    }

    "today" {
        if (Test-Path $MEMO_FILE) {
            $today = Get-Date -Format "yyyy-MM-dd"
            $todayMemos = Get-Content $MEMO_FILE | Where-Object { $_ -match "^$today" }
            if ($todayMemos) {
                $todayMemos
            } else {
                Write-Host "No memos today." -ForegroundColor Yellow
            }
        } else {
            Write-Host "No memos today." -ForegroundColor Yellow
        }
    }

    "clear" {
        Clear-Content $MEMO_FILE -ErrorAction SilentlyContinue
        Write-Host "Cleared $MEMO_FILE" -ForegroundColor Yellow
    }

    default {
        $text = @($Action) + $MemoText -join " "
        $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        Add-Content -Path $MEMO_FILE -Value "$timestamp $text"
        Write-Host "Saved to $MEMO_FILE" -ForegroundColor Green
    }
}