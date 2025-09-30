param(
    [Parameter(Position=0, ValueFromRemainingArguments=$true, Mandatory=$true)]
    [string[]]$Command
)

if ($Command.Count -eq 0) {
    Write-Host "Usage: done <your_command_here>" -ForegroundColor Red
    Write-Host "Examples:" -ForegroundColor Yellow
    Write-Host "  done ping google.com" -ForegroundColor White
    Write-Host "  done robocopy C:\source C:\dest /MIR" -ForegroundColor White
    exit 1
}

$commandString = $Command -join " "
Write-Host "Running command: '$commandString' ..." -ForegroundColor Cyan
Write-Host "You will be notified upon completion." -ForegroundColor Gray

$startTime = Get-Date

try {
    # Execute the command
    $process = Start-Process -FilePath "cmd.exe" -ArgumentList "/c", $commandString -Wait -PassThru -NoNewWindow

    $endTime = Get-Date
    $duration = $endTime - $startTime
    $durationString = "{0:mm}m {0:ss}s" -f $duration

    if ($process.ExitCode -eq 0) {
        $title = "Task Finished"
        $message = "Your command '$commandString' completed successfully in $durationString."
        $color = "Green"
    } else {
        $title = "Task Failed"
        $message = "Your command '$commandString' finished with exit code $($process.ExitCode) after $durationString."
        $color = "Red"
    }

    Write-Host $message -ForegroundColor $color

    # Windows Toast Notification
    try {
        [Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime] | Out-Null
        [Windows.Data.Xml.Dom.XmlDocument, Windows.Data.Xml.Dom.XmlDocument, ContentType = WindowsRuntime] | Out-Null

        $template = @"
<toast>
    <visual>
        <binding template="ToastText02">
            <text id="1">$title</text>
            <text id="2">$message</text>
        </binding>
    </visual>
</toast>
"@

        $xml = New-Object Windows.Data.Xml.Dom.XmlDocument
        $xml.LoadXml($template)
        $toast = [Windows.UI.Notifications.ToastNotification]::new($xml)
        [Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier("PowerShell Done").Show($toast)
    } catch {
        # Fallback to message box
        try {
            Add-Type -AssemblyName System.Windows.Forms
            [System.Windows.Forms.MessageBox]::Show($message, $title, 'OK', 'Information')
        } catch {
            # Silent fallback if GUI not available
            Write-Host "Notification failed - GUI not available" -ForegroundColor Yellow
        }
    }

} catch {
    $endTime = Get-Date
    $duration = $endTime - $startTime
    $durationString = "{0:mm}m {0:ss}s" -f $duration

    $message = "Command '$commandString' failed: $($_.Exception.Message)"
    Write-Host $message -ForegroundColor Red

    # Notify about failure
    try {
        [Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime] | Out-Null
        [Windows.Data.Xml.Dom.XmlDocument, Windows.Data.Xml.Dom.XmlDocument, ContentType = WindowsRuntime] | Out-Null

        $template = @"
<toast>
    <visual>
        <binding template="ToastText02">
            <text id="1">Task Error</text>
            <text id="2">$message</text>
        </binding>
    </visual>
</toast>
"@

        $xml = New-Object Windows.Data.Xml.Dom.XmlDocument
        $xml.LoadXml($template)
        $toast = [Windows.UI.Notifications.ToastNotification]::new($xml)
        [Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier("PowerShell Done").Show($toast)
    } catch {
        # Fallback to message box
        try {
            Add-Type -AssemblyName System.Windows.Forms
            [System.Windows.Forms.MessageBox]::Show($message, "Task Error", 'OK', 'Error')
        } catch {
            # Silent fallback if GUI not available
        }
    }
}