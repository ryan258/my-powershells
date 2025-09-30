param(
    [Parameter(Position=0, Mandatory=$true)]
    [string]$Time,

    [Parameter(Position=1, ValueFromRemainingArguments=$true)]
    [string[]]$Message
)

if (-not $Message -or ($Message.Count -eq 0)) {
    Write-Host "Usage: remind_me <time> <reminder_message>" -ForegroundColor Red
    Write-Host "Examples:" -ForegroundColor Yellow
    Write-Host "  remind_me '+30m' 'Take a break'" -ForegroundColor White
    Write-Host "  remind_me '+2h' 'Call the dentist'" -ForegroundColor White
    exit 1
}

$reminderMessage = $Message -join " "

function Show-Notification {
    param([string]$Title, [string]$Message)

    try {
        # Windows 10/11 Toast Notification
        $ToastMessage = @"
[Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime] | Out-Null
[Windows.Data.Xml.Dom.XmlDocument, Windows.Data.Xml.Dom.XmlDocument, ContentType = WindowsRuntime] | Out-Null

`$template = @"
<toast>
    <visual>
        <binding template="ToastText02">
            <text id="1">$Title</text>
            <text id="2">$Message</text>
        </binding>
    </visual>
</toast>
"@

`$xml = New-Object Windows.Data.Xml.Dom.XmlDocument
`$xml.LoadXml(`$template)
`$toast = [Windows.UI.Notifications.ToastNotification]::new(`$xml)
[Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier("PowerShell Reminder").Show(`$toast)
"@

        Invoke-Expression $ToastMessage
    } catch {
        # Fallback to simple message box
        Add-Type -AssemblyName System.Windows.Forms
        [System.Windows.Forms.MessageBox]::Show($Message, $Title, 'OK', 'Information')
    }
}

switch -Regex ($Time) {
    '^\+(\d+)m$' {
        $minutes = [int]$Matches[1]
        if ($minutes -lt 1 -or $minutes -gt 1440) {
            Write-Host "Please specify between 1 and 1440 minutes." -ForegroundColor Red
            exit 1
        }
        $delay = $minutes * 60
        Write-Host "Reminder set for $minutes minutes from now: '$reminderMessage'" -ForegroundColor Green

        Start-Job -ScriptBlock {
            param($DelaySeconds, $Title, $Message)
            Start-Sleep $DelaySeconds

            try {
                [Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime] | Out-Null
                [Windows.Data.Xml.Dom.XmlDocument, Windows.Data.Xml.Dom.XmlDocument, ContentType = WindowsRuntime] | Out-Null

                $template = @"
<toast>
    <visual>
        <binding template="ToastText02">
            <text id="1">$Title</text>
            <text id="2">$Message</text>
        </binding>
    </visual>
</toast>
"@

                $xml = New-Object Windows.Data.Xml.Dom.XmlDocument
                $xml.LoadXml($template)
                $toast = [Windows.UI.Notifications.ToastNotification]::new($xml)
                [Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier("PowerShell Reminder").Show($toast)
            } catch {
                Add-Type -AssemblyName System.Windows.Forms
                [System.Windows.Forms.MessageBox]::Show($Message, $Title, 'OK', 'Information')
            }
        } -ArgumentList $delay, "Reminder", $reminderMessage | Out-Null
    }

    '^\+(\d+)h$' {
        $hours = [int]$Matches[1]
        if ($hours -lt 1 -or $hours -gt 24) {
            Write-Host "Please specify between 1 and 24 hours." -ForegroundColor Red
            exit 1
        }
        $delay = $hours * 3600
        Write-Host "Reminder set for $hours hours from now: '$reminderMessage'" -ForegroundColor Green

        Start-Job -ScriptBlock {
            param($DelaySeconds, $Title, $Message)
            Start-Sleep $DelaySeconds

            try {
                [Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime] | Out-Null
                [Windows.Data.Xml.Dom.XmlDocument, Windows.Data.Xml.Dom.XmlDocument, ContentType = WindowsRuntime] | Out-Null

                $template = @"
<toast>
    <visual>
        <binding template="ToastText02">
            <text id="1">$Title</text>
            <text id="2">$Message</text>
        </binding>
    </visual>
</toast>
"@

                $xml = New-Object Windows.Data.Xml.Dom.XmlDocument
                $xml.LoadXml($template)
                $toast = [Windows.UI.Notifications.ToastNotification]::new($xml)
                [Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier("PowerShell Reminder").Show($toast)
            } catch {
                Add-Type -AssemblyName System.Windows.Forms
                [System.Windows.Forms.MessageBox]::Show($Message, $Title, 'OK', 'Information')
            }
        } -ArgumentList $delay, "Reminder", $reminderMessage | Out-Null
    }

    default {
        Write-Host "Simple time format not recognized." -ForegroundColor Red
        Write-Host "Supported formats: +30m (30 minutes), +2h (2 hours)" -ForegroundColor Yellow
        exit 1
    }
}