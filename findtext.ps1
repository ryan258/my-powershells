param(
    [Parameter(Position=0)]
    [string]$SearchTerm,

    [Parameter(Position=1)]
    [string]$Path = "."
)

if (-not $SearchTerm) {
    $SearchTerm = Read-Host "What text are you searching for?"
}

if ([string]::IsNullOrWhiteSpace($SearchTerm)) {
    Write-Host "No search term provided. Exiting." -ForegroundColor Red
    exit 1
}

Write-Host "Searching for '$SearchTerm' in all files in '$Path'..." -ForegroundColor Cyan

try {
    $results = Select-String -Path "$Path\*" -Pattern $SearchTerm -Recurse -SimpleMatch -ErrorAction SilentlyContinue |
               Select-Object -ExpandProperty Filename -Unique

    if ($results) {
        Write-Host "Found '$SearchTerm' in the following files:" -ForegroundColor Green
        $results | ForEach-Object { Write-Host "  $_" -ForegroundColor White }
    } else {
        Write-Host "No files found containing '$SearchTerm'" -ForegroundColor Yellow
    }
} catch {
    Write-Host "Error searching files: $($_.Exception.Message)" -ForegroundColor Red
}