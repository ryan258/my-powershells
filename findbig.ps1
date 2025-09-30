param(
    [Parameter(Position=0)]
    [string]$Path = "."
)

Write-Host "Searching for the top 10 largest files and folders in $Path..." -ForegroundColor Cyan

try {
    Get-ChildItem -Path $Path -Recurse -Force -ErrorAction SilentlyContinue |
    Where-Object { $_.PSIsContainer -eq $false } |
    Sort-Object Length -Descending |
    Select-Object -First 10 |
    ForEach-Object {
        $size = if ($_.Length -gt 1GB) {
            "{0:N2} GB" -f ($_.Length / 1GB)
        } elseif ($_.Length -gt 1MB) {
            "{0:N2} MB" -f ($_.Length / 1MB)
        } elseif ($_.Length -gt 1KB) {
            "{0:N2} KB" -f ($_.Length / 1KB)
        } else {
            "$($_.Length) bytes"
        }

        Write-Host "$size`t$($_.FullName)" -ForegroundColor White
    }

    Write-Host "`nTop 10 largest directories:" -ForegroundColor Yellow
    Get-ChildItem -Path $Path -Directory -Force -ErrorAction SilentlyContinue |
    ForEach-Object {
        $dirSize = (Get-ChildItem -Path $_.FullName -Recurse -Force -ErrorAction SilentlyContinue |
                   Measure-Object -Property Length -Sum).Sum
        [PSCustomObject]@{
            Directory = $_.FullName
            Size = $dirSize
        }
    } |
    Sort-Object Size -Descending |
    Select-Object -First 10 |
    ForEach-Object {
        $size = if ($_.Size -gt 1GB) {
            "{0:N2} GB" -f ($_.Size / 1GB)
        } elseif ($_.Size -gt 1MB) {
            "{0:N2} MB" -f ($_.Size / 1MB)
        } elseif ($_.Size -gt 1KB) {
            "{0:N2} KB" -f ($_.Size / 1KB)
        } else {
            "$($_.Size) bytes"
        }

        Write-Host "$size`t$($_.Directory)" -ForegroundColor Cyan
    }
} catch {
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
}