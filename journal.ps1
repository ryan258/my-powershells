param(
    [Parameter(Position=0, ValueFromRemainingArguments=$true)]
    [string[]]$EntryText
)

$JOURNAL_FILE = "$env:USERPROFILE\journal.txt"

if (-not $EntryText -or ($EntryText.Count -eq 0) -or ([string]::IsNullOrWhiteSpace($EntryText -join " "))) {
    if (Test-Path $JOURNAL_FILE) {
        Write-Host "--- Last 5 Journal Entries ---" -ForegroundColor Cyan
        Get-Content $JOURNAL_FILE | Select-Object -Last 5
    } else {
        Write-Host "Journal is empty. Start by writing an entry!" -ForegroundColor Yellow
    }
    exit 0
}

$entry = $EntryText -join " "
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
$journalEntry = "[$timestamp] $entry"

Add-Content -Path $JOURNAL_FILE -Value $journalEntry

Write-Host "Entry added to journal." -ForegroundColor Green