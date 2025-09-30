Write-Host "=== Battery Status ===" -ForegroundColor Green

try {
    # Get battery information using WMI
    $battery = Get-WmiObject -Class Win32_Battery -ErrorAction SilentlyContinue

    if (-not $battery) {
        Write-Host "No battery information available (desktop PC?)" -ForegroundColor Yellow
        exit 1
    }

    $batteryStatus = switch ($battery.BatteryStatus) {
        1 { "Discharging" }
        2 { "On AC Power" }
        3 { "Fully Charged" }
        4 { "Low" }
        5 { "Critical" }
        6 { "Charging" }
        7 { "Charging and High" }
        8 { "Charging and Low" }
        9 { "Charging and Critical" }
        10 { "Undefined" }
        11 { "Partially Charged" }
        default { "Unknown" }
    }

    $percentage = $battery.EstimatedChargeRemaining
    $powerOnline = (Get-WmiObject -Class Win32_PowerSupply).PowerOnline

    Write-Host "Battery Level: $percentage%" -ForegroundColor White
    Write-Host "Status: $batteryStatus" -ForegroundColor White
    Write-Host "Power Adapter: $(if ($powerOnline) { 'Connected' } else { 'Disconnected' })" -ForegroundColor White

    if ($battery.EstimatedRunTime -and $battery.EstimatedRunTime -ne 71582788) {
        $hours = [math]::Floor($battery.EstimatedRunTime / 60)
        $minutes = $battery.EstimatedRunTime % 60
        Write-Host "Estimated Runtime: ${hours}h ${minutes}m" -ForegroundColor White
    }

    Write-Host ""

    # Provide suggestions based on battery level
    if ($percentage -lt 20) {
        Write-Host "⚠️  Low battery! Consider:" -ForegroundColor Red
        Write-Host "- Reducing screen brightness" -ForegroundColor Yellow
        Write-Host "- Closing unnecessary applications" -ForegroundColor Yellow
        Write-Host "- Enabling Battery Saver mode" -ForegroundColor Yellow
        Write-Host "- Plugging in your charger" -ForegroundColor Yellow
    } elseif ($percentage -lt 50) {
        Write-Host "💡 Moderate battery. You might want to:" -ForegroundColor Yellow
        Write-Host "- Save your work periodically (Ctrl+S)" -ForegroundColor Gray
        Write-Host "- Consider plugging in soon" -ForegroundColor Gray
        Write-Host "- Close background apps you're not using" -ForegroundColor Gray
    } else {
        Write-Host "✅ Battery level looks good!" -ForegroundColor Green
    }

    # Additional power information
    Write-Host ""
    Write-Host "=== Power Plan ===" -ForegroundColor Cyan
    $powerPlan = Get-WmiObject -Namespace root\cimv2\power -Class Win32_PowerPlan | Where-Object { $_.IsActive }
    if ($powerPlan) {
        Write-Host "Active Power Plan: $($powerPlan.ElementName)" -ForegroundColor White
    }

} catch {
    Write-Host "Error reading battery information: $($_.Exception.Message)" -ForegroundColor Red
}