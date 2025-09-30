param(
    [Parameter(Position=0)]
    [int]$Minutes = 15
)

if ($Minutes -lt 1 -or $Minutes -gt 120) {
    Write-Host "Please specify a break time between 1 and 120 minutes." -ForegroundColor Red
    exit 1
}

Write-Host "Starting a $Minutes minute break..." -ForegroundColor Green
Write-Host "Break suggestions:" -ForegroundColor Cyan
Write-Host "- Step away from the screen" -ForegroundColor Yellow
Write-Host "- Do gentle neck rolls" -ForegroundColor Yellow
Write-Host "- Stretch your hands and wrists" -ForegroundColor Yellow
Write-Host "- Take deep breaths" -ForegroundColor Yellow
Write-Host "- Walk around if possible" -ForegroundColor Yellow
Write-Host ""
Write-Host "Timer starting now..." -ForegroundColor Green

$seconds = $Minutes * 60
Start-Sleep $seconds

Write-Host ""
Write-Host "=========================================" -ForegroundColor Green
Write-Host "  Break time is over! Welcome back." -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Green

try {
    # Windows Toast Notification
    [Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime] | Out-Null
    [Windows.Data.Xml.Dom.XmlDocument, Windows.Data.Xml.Dom.XmlDocument, ContentType = WindowsRuntime] | Out-Null

    $template = @"
<toast>
    <visual>
        <binding template="ToastText02">
            <text id="1">Health Break Complete</text>
            <text id="2">Break time is over! Welcome back.</text>
        </binding>
    </visual>
</toast>
"@

    $xml = New-Object Windows.Data.Xml.Dom.XmlDocument
    $xml.LoadXml($template)
    $toast = [Windows.UI.Notifications.ToastNotification]::new($xml)
    [Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier("Health Break").Show($toast)
} catch {
    # Fallback to message box
    try {
        Add-Type -AssemblyName System.Windows.Forms
        [System.Windows.Forms.MessageBox]::Show("Break time is over! Welcome back.", "Health Break Complete", 'OK', 'Information')
    } catch {
        # Silent fallback if GUI not available
    }
}

$logFile = "$env:USERPROFILE\health_breaks.log"
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
Add-Content -Path $logFile -Value "[$timestamp] Completed $Minutes minute break"