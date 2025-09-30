param(
    [Parameter(Position=0)]
    [string]$City = "Bentonville"
)

Write-Host "Fetching the weather for $City..." -ForegroundColor Cyan

try {
    $response = Invoke-RestMethod -Uri "https://wttr.in/$City" -UserAgent "curl"
    Write-Output $response
} catch {
    Write-Host "Error fetching weather: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "Make sure you have an internet connection and try again." -ForegroundColor Yellow
}