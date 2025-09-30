param(
    [Parameter(Position=0)]
    [string]$Action = "status"
)

switch ($Action.ToLower()) {
    "status" {
        Write-Host "=== Network Status ===" -ForegroundColor Green
        Write-Host ""

        Write-Host "--- Network Adapters ---" -ForegroundColor Cyan
        $adapters = Get-NetAdapter | Where-Object { $_.Status -eq "Up" }
        $adapters | ForEach-Object {
            Write-Host "$($_.Name): $($_.Status) - $($_.LinkSpeed)" -ForegroundColor White
        }

        Write-Host ""
        Write-Host "--- IP Addresses ---" -ForegroundColor Cyan
        try {
            $externalIP = (Invoke-RestMethod -Uri "http://ifconfig.me/ip" -TimeoutSec 5).Trim()
            Write-Host "External IP: $externalIP" -ForegroundColor White
        } catch {
            Write-Host "External IP: Unable to determine" -ForegroundColor Yellow
        }

        $localIPs = Get-NetIPAddress -AddressFamily IPv4 | Where-Object { $_.InterfaceAlias -notlike "*Loopback*" }
        Write-Host "Local IPs:" -ForegroundColor Yellow
        $localIPs | ForEach-Object {
            Write-Host "  $($_.InterfaceAlias): $($_.IPAddress)" -ForegroundColor White
        }

        Write-Host ""
        Write-Host "--- DNS Servers ---" -ForegroundColor Cyan
        $dnsServers = Get-DnsClientServerAddress | Where-Object { $_.AddressFamily -eq 2 -and $_.ServerAddresses.Count -gt 0 }
        $dnsServers | ForEach-Object {
            Write-Host "$($_.InterfaceAlias):" -ForegroundColor Yellow
            $_.ServerAddresses | ForEach-Object { Write-Host "  $_" -ForegroundColor White }
        }
    }

    "scan" {
        Write-Host "=== Wi-Fi Network Scan ===" -ForegroundColor Green
        Write-Host ""

        try {
            $profiles = netsh wlan show profiles | Select-String "All User Profile" | ForEach-Object {
                ($_ -split ":")[1].Trim()
            }

            if ($profiles) {
                Write-Host "--- Saved Wi-Fi Networks ---" -ForegroundColor Cyan
                $profiles | ForEach-Object {
                    Write-Host "  $_" -ForegroundColor White
                }
            }

            Write-Host ""
            Write-Host "--- Available Wi-Fi Networks ---" -ForegroundColor Cyan
            Write-Host "Scanning for networks..." -ForegroundColor Yellow

            $networks = netsh wlan show profiles | Out-String
            if ($networks) {
                netsh wlan show all
            } else {
                Write-Host "No Wi-Fi adapter found or Wi-Fi is disabled." -ForegroundColor Red
            }
        } catch {
            Write-Host "Error scanning Wi-Fi networks: $($_.Exception.Message)" -ForegroundColor Red
        }
    }

    "speed" {
        Write-Host "=== Network Speed Test ===" -ForegroundColor Green
        Write-Host "Testing connection speed..." -ForegroundColor Yellow

        try {
            $testUrl = "http://speedtest.tele2.net/10MB.zip"
            $startTime = Get-Date

            $response = Invoke-WebRequest -Uri $testUrl -OutFile $null -PassThru -UseBasicParsing -TimeoutSec 30
            $endTime = Get-Date

            $duration = ($endTime - $startTime).TotalSeconds
            if ($duration -gt 0) {
                $speed = [math]::Round(10 / $duration, 2)
                Write-Host "Approximate download speed: $speed MB/s" -ForegroundColor Green
            } else {
                Write-Host "Test completed too quickly to measure accurately" -ForegroundColor Yellow
            }
        } catch {
            Write-Host "Speed test failed: $($_.Exception.Message)" -ForegroundColor Red
            Write-Host "You can try online speed tests like speedtest.net" -ForegroundColor Yellow
        }
    }

    "fix" {
        Write-Host "=== Network Troubleshooting ===" -ForegroundColor Green

        Write-Host "Flushing DNS cache..." -ForegroundColor Yellow
        try {
            ipconfig /flushdns | Out-Null
            Write-Host "DNS cache flushed successfully." -ForegroundColor Green
        } catch {
            Write-Host "Failed to flush DNS cache." -ForegroundColor Red
        }

        Write-Host ""
        Write-Host "Releasing and renewing IP address..." -ForegroundColor Yellow
        try {
            ipconfig /release | Out-Null
            Start-Sleep 2
            ipconfig /renew | Out-Null
            Write-Host "IP address renewed successfully." -ForegroundColor Green
        } catch {
            Write-Host "Failed to renew IP address." -ForegroundColor Red
        }

        Write-Host ""
        Write-Host "Resetting Winsock..." -ForegroundColor Yellow
        try {
            netsh winsock reset | Out-Null
            Write-Host "Winsock reset successfully." -ForegroundColor Green
            Write-Host "Note: A restart may be required for full effect." -ForegroundColor Yellow
        } catch {
            Write-Host "Failed to reset Winsock." -ForegroundColor Red
        }

        Write-Host ""
        Write-Host "Network troubleshooting complete." -ForegroundColor Green
        Write-Host "Try your connection now. If issues persist, restart your computer." -ForegroundColor Yellow
    }

    "ping" {
        Write-Host "=== Connectivity Test ===" -ForegroundColor Green

        $targets = @("8.8.8.8", "1.1.1.1", "google.com", "github.com")

        foreach ($target in $targets) {
            Write-Host "Testing connection to $target..." -ForegroundColor Yellow
            try {
                $result = Test-NetConnection -ComputerName $target -Port 80 -WarningAction SilentlyContinue
                if ($result.TcpTestSucceeded) {
                    Write-Host "  ✓ $target - Connected ($($result.RemoteAddress))" -ForegroundColor Green
                } else {
                    Write-Host "  ✗ $target - Failed" -ForegroundColor Red
                }
            } catch {
                Write-Host "  ✗ $target - Error: $($_.Exception.Message)" -ForegroundColor Red
            }
        }
    }

    default {
        Write-Host "Usage: network_info {status|scan|speed|fix|ping}" -ForegroundColor Yellow
        Write-Host "  status : Show current network information" -ForegroundColor White
        Write-Host "  scan   : Scan for available Wi-Fi networks" -ForegroundColor White
        Write-Host "  speed  : Test network speed" -ForegroundColor White
        Write-Host "  fix    : Reset network settings" -ForegroundColor White
        Write-Host "  ping   : Test connectivity to common sites" -ForegroundColor White
    }
}