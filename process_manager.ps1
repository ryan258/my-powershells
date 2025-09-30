param(
    [Parameter(Position=0, Mandatory=$true)]
    [string]$Action,

    [Parameter(Position=1)]
    [string]$ProcessName
)

switch ($Action.ToLower()) {
    "find" {
        if (-not $ProcessName) {
            Write-Host "Usage: process_manager find <process_name>" -ForegroundColor Red
            exit 1
        }

        Write-Host "Searching for processes containing '$ProcessName'..." -ForegroundColor Cyan

        $processes = Get-Process | Where-Object { $_.ProcessName -like "*$ProcessName*" }

        if ($processes) {
            $processes | Format-Table ProcessName, Id, CPU, WorkingSet, @{
                Name="Memory(MB)"; Expression={[math]::Round($_.WorkingSet64 / 1MB, 2)}
            } -AutoSize
        } else {
            Write-Host "No processes found matching '$ProcessName'" -ForegroundColor Yellow
        }
    }

    "top" {
        Write-Host "=== Top 10 CPU-using processes ===" -ForegroundColor Green

        Get-Process | Where-Object { $_.CPU -ne $null } |
        Sort-Object CPU -Descending |
        Select-Object -First 10 |
        Format-Table ProcessName, Id, @{
            Name="CPU(s)"; Expression={[math]::Round($_.CPU, 2)}
        }, @{
            Name="Memory(MB)"; Expression={[math]::Round($_.WorkingSet64 / 1MB, 2)}
        } -AutoSize
    }

    "memory" {
        Write-Host "=== Top 10 Memory-using processes ===" -ForegroundColor Green

        Get-Process |
        Sort-Object WorkingSet64 -Descending |
        Select-Object -First 10 |
        Format-Table ProcessName, Id, @{
            Name="Memory(MB)"; Expression={[math]::Round($_.WorkingSet64 / 1MB, 2)}
        }, @{
            Name="CPU(s)"; Expression={if($_.CPU){[math]::Round($_.CPU, 2)}else{"N/A"}}
        } -AutoSize
    }

    "kill" {
        if (-not $ProcessName) {
            Write-Host "Usage: process_manager kill <process_name>" -ForegroundColor Red
            exit 1
        }

        $processes = Get-Process | Where-Object { $_.ProcessName -like "*$ProcessName*" }

        if (-not $processes) {
            Write-Host "No processes found matching '$ProcessName'" -ForegroundColor Yellow
            exit 1
        }

        Write-Host "Found processes matching '$ProcessName':" -ForegroundColor Yellow
        $processes | Format-Table ProcessName, Id, @{
            Name="Memory(MB)"; Expression={[math]::Round($_.WorkingSet64 / 1MB, 2)}
        } -AutoSize

        $confirm = Read-Host "Kill these processes? (y/n)"

        if ($confirm -eq 'y' -or $confirm -eq 'Y') {
            foreach ($proc in $processes) {
                try {
                    Stop-Process -Id $proc.Id -Force
                    Write-Host "Killed process: $($proc.ProcessName) (ID: $($proc.Id))" -ForegroundColor Green
                } catch {
                    Write-Host "Failed to kill process $($proc.ProcessName) (ID: $($proc.Id)): $($_.Exception.Message)" -ForegroundColor Red
                }
            }
        } else {
            Write-Host "Operation cancelled." -ForegroundColor Yellow
        }
    }

    "services" {
        Write-Host "=== Windows Services Status ===" -ForegroundColor Green

        if ($ProcessName) {
            Write-Host "Searching for services containing '$ProcessName'..." -ForegroundColor Cyan
            Get-Service | Where-Object { $_.Name -like "*$ProcessName*" -or $_.DisplayName -like "*$ProcessName*" } |
            Format-Table Name, Status, DisplayName -AutoSize
        } else {
            Write-Host "Running services:" -ForegroundColor Cyan
            Get-Service | Where-Object { $_.Status -eq "Running" } |
            Sort-Object Name |
            Format-Table Name, Status, DisplayName -AutoSize
        }
    }

    "threads" {
        if (-not $ProcessName) {
            Write-Host "Usage: process_manager threads <process_name>" -ForegroundColor Red
            exit 1
        }

        $processes = Get-Process | Where-Object { $_.ProcessName -like "*$ProcessName*" }

        if (-not $processes) {
            Write-Host "No processes found matching '$ProcessName'" -ForegroundColor Yellow
            exit 1
        }

        Write-Host "Thread information for processes matching '$ProcessName':" -ForegroundColor Cyan

        foreach ($proc in $processes) {
            Write-Host ""
            Write-Host "Process: $($proc.ProcessName) (ID: $($proc.Id))" -ForegroundColor Yellow
            Write-Host "Threads: $($proc.Threads.Count)" -ForegroundColor White
            Write-Host "Handles: $($proc.HandleCount)" -ForegroundColor White
            Write-Host "Start Time: $($proc.StartTime)" -ForegroundColor White
        }
    }

    default {
        Write-Host "Usage: process_manager {find|top|memory|kill|services|threads} [process_name]" -ForegroundColor Yellow
        Write-Host "  find <name>     : Find processes by name" -ForegroundColor White
        Write-Host "  top             : Show top CPU users" -ForegroundColor White
        Write-Host "  memory          : Show top memory users" -ForegroundColor White
        Write-Host "  kill <name>     : Safely kill processes by name" -ForegroundColor White
        Write-Host "  services [name] : Show running services (optionally filtered)" -ForegroundColor White
        Write-Host "  threads <name>  : Show thread information for processes" -ForegroundColor White
    }
}