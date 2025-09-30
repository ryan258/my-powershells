Write-Host "=== Windows System Information ===" -ForegroundColor Green
Write-Host ""

Write-Host "--- Hardware ---" -ForegroundColor Cyan
$computerInfo = Get-ComputerInfo
Write-Host "Model: $($computerInfo.CsModel)" -ForegroundColor White
Write-Host "Manufacturer: $($computerInfo.CsManufacturer)" -ForegroundColor White
Write-Host "Processor: $($computerInfo.CsProcessors[0].Name)" -ForegroundColor White
Write-Host "Total Memory: $([math]::Round($computerInfo.TotalPhysicalMemory / 1GB, 2)) GB" -ForegroundColor White

Write-Host ""
Write-Host "--- CPU Usage ---" -ForegroundColor Cyan
$cpu = Get-WmiObject -Class Win32_Processor | Measure-Object -Property LoadPercentage -Average
Write-Host "Average CPU Usage: $($cpu.Average)%" -ForegroundColor White

$topProcesses = Get-Process | Sort-Object CPU -Descending | Select-Object -First 5
Write-Host "Top 5 CPU processes:" -ForegroundColor Yellow
$topProcesses | ForEach-Object {
    Write-Host "  $($_.ProcessName): $([math]::Round($_.CPU, 2))s" -ForegroundColor White
}

Write-Host ""
Write-Host "--- Memory Usage ---" -ForegroundColor Cyan
$memory = Get-WmiObject -Class Win32_OperatingSystem
$totalMem = [math]::Round($memory.TotalVisibleMemorySize / 1MB, 2)
$freeMem = [math]::Round($memory.FreePhysicalMemory / 1MB, 2)
$usedMem = $totalMem - $freeMem
$memPercent = [math]::Round(($usedMem / $totalMem) * 100, 1)

Write-Host "Total: $totalMem GB" -ForegroundColor White
Write-Host "Used: $usedMem GB ($memPercent%)" -ForegroundColor White
Write-Host "Free: $freeMem GB" -ForegroundColor White

Write-Host ""
Write-Host "--- Disk Usage ---" -ForegroundColor Cyan
Get-WmiObject -Class Win32_LogicalDisk | Where-Object { $_.DriveType -eq 3 } | ForEach-Object {
    $totalSize = [math]::Round($_.Size / 1GB, 2)
    $freeSpace = [math]::Round($_.FreeSpace / 1GB, 2)
    $usedSpace = $totalSize - $freeSpace
    $usedPercent = [math]::Round(($usedSpace / $totalSize) * 100, 1)

    Write-Host "Drive $($_.DeviceID) - Total: $totalSize GB, Used: $usedSpace GB ($usedPercent%), Free: $freeSpace GB" -ForegroundColor White
}

Write-Host ""
Write-Host "--- Network ---" -ForegroundColor Cyan
try {
    $externalIP = (Invoke-RestMethod -Uri "http://ifconfig.me/ip" -TimeoutSec 5).Trim()
    Write-Host "External IP: $externalIP" -ForegroundColor White
} catch {
    Write-Host "External IP: Unable to determine" -ForegroundColor Yellow
}

$adapters = Get-NetAdapter | Where-Object { $_.Status -eq "Up" }
Write-Host "Active network adapters:" -ForegroundColor Yellow
$adapters | ForEach-Object {
    Write-Host "  $($_.Name): $($_.LinkSpeed)" -ForegroundColor White
}

Write-Host ""
Write-Host "--- Windows Version ---" -ForegroundColor Cyan
Write-Host "OS: $($computerInfo.WindowsProductName)" -ForegroundColor White
Write-Host "Version: $($computerInfo.WindowsVersion)" -ForegroundColor White
Write-Host "Build: $($computerInfo.WindowsBuildLabEx)" -ForegroundColor White

Write-Host ""
Write-Host "--- Uptime ---" -ForegroundColor Cyan
$uptime = (Get-Date) - (Get-CimInstance -ClassName Win32_OperatingSystem).LastBootUpTime
Write-Host "System uptime: $($uptime.Days) days, $($uptime.Hours) hours, $($uptime.Minutes) minutes" -ForegroundColor White