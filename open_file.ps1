param(
    [Parameter(Position=0, Mandatory=$true)]
    [string]$SearchTerm
)

Write-Host "Searching for files containing '$SearchTerm'..." -ForegroundColor Cyan

$searchPaths = @(
    $env:USERPROFILE,
    "$env:USERPROFILE\Documents",
    "$env:USERPROFILE\Desktop",
    "$env:USERPROFILE\Downloads"
)

$excludePatterns = @(
    "AppData",
    ".git",
    "node_modules",
    "bin",
    "obj",
    ".vs",
    ".vscode"
)

$matches = @()

foreach ($path in $searchPaths) {
    if (Test-Path $path) {
        try {
            $files = Get-ChildItem -Path $path -File -Recurse -Depth 3 -ErrorAction SilentlyContinue |
                Where-Object {
                    $_.Name -like "*$SearchTerm*" -and
                    -not ($excludePatterns | Where-Object { $_.FullName -like "*$_*" })
                } |
                Select-Object -First 20

            $matches += $files
        } catch {
            # Silent continue on access denied
        }
    }
}

if ($matches.Count -eq 0) {
    Write-Host "No files found containing '$SearchTerm'" -ForegroundColor Yellow
    exit 1
}

$matches = $matches | Sort-Object LastWriteTime -Descending | Select-Object -First 10

Write-Host "Found files:" -ForegroundColor Green
for ($i = 0; $i -lt $matches.Count; $i++) {
    $file = $matches[$i]
    $relativePath = $file.FullName -replace [regex]::Escape($env:USERPROFILE), "~"
    Write-Host "$($i + 1). $relativePath" -ForegroundColor White
}

Write-Host ""
$choice = Read-Host "Enter number to open (or Enter to cancel)"

if ($choice -match '^\d+$' -and [int]$choice -le $matches.Count -and [int]$choice -gt 0) {
    $selectedFile = $matches[[int]$choice - 1]

    try {
        Start-Process -FilePath $selectedFile.FullName
        Write-Host "Opening: $($selectedFile.FullName)" -ForegroundColor Green
    } catch {
        Write-Host "Failed to open file: $($_.Exception.Message)" -ForegroundColor Red
        Write-Host "Tip: Try opening manually or check file associations" -ForegroundColor Yellow
    }
} else {
    Write-Host "Cancelled or invalid choice." -ForegroundColor Yellow
}