param(
    [Parameter(Position=0)]
    [string]$SearchPath = ".",

    [Parameter()]
    [switch]$DeleteDuplicates,

    [Parameter()]
    [string]$MinSize = "1KB"
)

$ErrorActionPreference = 'Stop'

Write-Host "Searching for duplicate files in: $SearchPath" -ForegroundColor Cyan
Write-Host "This may take a while for large directories..." -ForegroundColor Yellow
Write-Host ""

$minSizeBytes = switch ($MinSize) {
    {$_ -match '(\d+)KB'} { [int]$Matches[1] * 1KB }
    {$_ -match '(\d+)MB'} { [int]$Matches[1] * 1MB }
    {$_ -match '(\d+)GB'} { [int]$Matches[1] * 1GB }
    {$_ -match '^\d+$'} { [int]$_ }
    default { 1KB }
}

Write-Host "Minimum file size: $([math]::Round($minSizeBytes / 1KB, 2)) KB" -ForegroundColor Gray

$duplicateGroups = @{}
$processedFiles = 0
$duplicateCount = 0

try {
    $files = Get-ChildItem -Path $SearchPath -File -Recurse -ErrorAction SilentlyContinue |
             Where-Object { $_.Length -ge $minSizeBytes }

    $totalFiles = $files.Count
    Write-Host "Found $totalFiles files to analyze..." -ForegroundColor Gray
    Write-Host ""

    foreach ($file in $files) {
        $processedFiles++

        if ($processedFiles % 100 -eq 0) {
            $progress = [math]::Round(($processedFiles / $totalFiles) * 100, 1)
            Write-Host "Progress: $progress% ($processedFiles/$totalFiles)" -ForegroundColor Gray
        }

        try {
            $hash = Get-FileHash -Path $file.FullName -Algorithm MD5 -ErrorAction SilentlyContinue
            if ($hash) {
                $size = $file.Length
                $key = "$($hash.Hash)_$size"

                if ($duplicateGroups.ContainsKey($key)) {
                    $duplicateGroups[$key] += $file
                } else {
                    $duplicateGroups[$key] = @($file)
                }
            }
        } catch {
            Write-Host "Warning: Could not hash file $($file.FullName)" -ForegroundColor Yellow
        }
    }

    Write-Host ""
    Write-Host "Analysis complete. Finding duplicates..." -ForegroundColor Green
    Write-Host ""

    $duplicateGroupsFound = $duplicateGroups.Values | Where-Object { $_.Count -gt 1 }

    if ($duplicateGroupsFound.Count -eq 0) {
        Write-Host "No duplicate files found!" -ForegroundColor Green
        return
    }

    foreach ($group in $duplicateGroupsFound) {
        $duplicateCount++
        $fileSize = if ($group[0].Length -gt 1MB) {
            "{0:N2} MB" -f ($group[0].Length / 1MB)
        } elseif ($group[0].Length -gt 1KB) {
            "{0:N2} KB" -f ($group[0].Length / 1KB)
        } else {
            "$($group[0].Length) bytes"
        }

        Write-Host "Duplicate Group $duplicateCount (Size: $fileSize):" -ForegroundColor Red

        $sortedFiles = $group | Sort-Object LastWriteTime
        for ($i = 0; $i -lt $sortedFiles.Count; $i++) {
            $file = $sortedFiles[$i]
            $age = (Get-Date) - $file.LastWriteTime
            $ageString = if ($age.Days -gt 0) { "$($age.Days)d ago" } else { "$($age.Hours)h ago" }

            if ($i -eq 0) {
                Write-Host "  [KEEP] $($file.FullName) ($ageString)" -ForegroundColor Green
            } else {
                Write-Host "  [DUP]  $($file.FullName) ($ageString)" -ForegroundColor Yellow

                if ($DeleteDuplicates) {
                    try {
                        Remove-Item $file.FullName -Force
                        Write-Host "         → DELETED" -ForegroundColor Red
                    } catch {
                        Write-Host "         → DELETE FAILED: $($_.Exception.Message)" -ForegroundColor Red
                    }
                }
            }
        }
        Write-Host ""
    }

    $totalDuplicates = ($duplicateGroupsFound | ForEach-Object { $_.Count - 1 } | Measure-Object -Sum).Sum
    Write-Host "Summary:" -ForegroundColor Cyan
    Write-Host "  Duplicate groups found: $($duplicateGroupsFound.Count)" -ForegroundColor White
    Write-Host "  Total duplicate files: $totalDuplicates" -ForegroundColor White

    if ($DeleteDuplicates) {
        Write-Host "  Duplicates deleted: Yes" -ForegroundColor Red
    } else {
        Write-Host "  Duplicates deleted: No (use -DeleteDuplicates to delete)" -ForegroundColor Yellow
    }

} catch {
    Write-Host "Error during duplicate search: $($_.Exception.Message)" -ForegroundColor Red
}