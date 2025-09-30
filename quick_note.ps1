param(
    [Parameter(Position=0)]
    [string]$Action = "help",

    [Parameter(Position=1, ValueFromRemainingArguments=$true)]
    [string[]]$Text
)

$NOTES_FILE = "$env:USERPROFILE\quick_notes.txt"

switch ($Action.ToLower()) {
    "add" {
        if (-not $Text -or ($Text.Count -eq 0)) {
            Write-Host "Usage: quick_note add <your note>" -ForegroundColor Red
            exit 1
        }
        $note = $Text -join " "
        $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm"
        $noteEntry = "[$timestamp] $note"
        Add-Content -Path $NOTES_FILE -Value $noteEntry
        Write-Host "Note added: $note" -ForegroundColor Green
    }

    "search" {
        if (-not $Text -or ($Text.Count -eq 0)) {
            Write-Host "Usage: quick_note search <search_term>" -ForegroundColor Red
            exit 1
        }
        $query = $Text -join " "
        Write-Host "=== Notes containing '$query' ===" -ForegroundColor Cyan
        if (Test-Path $NOTES_FILE) {
            $matches = Select-String -Path $NOTES_FILE -Pattern $query -SimpleMatch
            if ($matches) {
                $matches | ForEach-Object { Write-Host $_.Line }
            } else {
                Write-Host "No matching notes found." -ForegroundColor Yellow
            }
        } else {
            Write-Host "No notes found." -ForegroundColor Yellow
        }
    }

    "recent" {
        $count = if ($Text -and ($Text[0] -as [int])) { [int]$Text[0] } else { 10 }
        Write-Host "=== Last $count Notes ===" -ForegroundColor Cyan
        if (Test-Path $NOTES_FILE) {
            Get-Content $NOTES_FILE | Select-Object -Last $count
        } else {
            Write-Host "No notes found." -ForegroundColor Yellow
        }
    }

    "today" {
        $today = Get-Date -Format "yyyy-MM-dd"
        Write-Host "=== Notes from today ($today) ===" -ForegroundColor Cyan
        if (Test-Path $NOTES_FILE) {
            $todayNotes = Select-String -Path $NOTES_FILE -Pattern "^\[$today"
            if ($todayNotes) {
                $todayNotes | ForEach-Object { Write-Host $_.Line }
            } else {
                Write-Host "No notes from today." -ForegroundColor Yellow
            }
        } else {
            Write-Host "No notes from today." -ForegroundColor Yellow
        }
    }

    default {
        Write-Host "Usage: quick_note {add|search|recent|today}" -ForegroundColor Yellow
        Write-Host "  add <note>      : Add a quick note" -ForegroundColor White
        Write-Host "  search <term>   : Search through notes" -ForegroundColor White
        Write-Host "  recent [count]  : Show recent notes (default: 10)" -ForegroundColor White
        Write-Host "  today           : Show today's notes" -ForegroundColor White
    }
}