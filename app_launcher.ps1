param(
    [Parameter(Position=0)]
    [string]$Action,

    [Parameter(Position=1)]
    [string]$AppName,

    [Parameter(Position=2)]
    [string]$AppPath
)

$APPS_FILE = "$env:USERPROFILE\.favorite_apps.txt"

switch ($Action.ToLower()) {
    "add" {
        if (-not $AppName -or -not $AppPath) {
            Write-Host "Usage: app_launcher add <shortname> <app_name_or_path>" -ForegroundColor Red
            Write-Host "Example: app_launcher add code 'Visual Studio Code'" -ForegroundColor Yellow
            Write-Host "Example: app_launcher add chrome 'C:\Program Files\Google\Chrome\Application\chrome.exe'" -ForegroundColor Yellow
            exit 1
        }

        Add-Content -Path $APPS_FILE -Value "$AppName`:$AppPath"
        Write-Host "Added '$AppName' -> '$AppPath'" -ForegroundColor Green
    }

    "list" {
        Write-Host "=== Favorite Applications ===" -ForegroundColor Cyan
        if (Test-Path $APPS_FILE) {
            Get-Content $APPS_FILE | ForEach-Object {
                $parts = $_ -split ':', 2
                Write-Host "$($parts[0]) -> $($parts[1])" -ForegroundColor White
            }
        } else {
            Write-Host "No favorite apps configured." -ForegroundColor Yellow
            Write-Host "Add some with: app_launcher add <shortname> <app_name>" -ForegroundColor Gray
        }
    }

    "remove" {
        if (-not $AppName) {
            Write-Host "Usage: app_launcher remove <shortname>" -ForegroundColor Red
            exit 1
        }

        if (Test-Path $APPS_FILE) {
            $apps = Get-Content $APPS_FILE | Where-Object { -not ($_ -match "^$AppName`:") }
            $apps | Set-Content $APPS_FILE
            Write-Host "Removed app '$AppName'" -ForegroundColor Green
        } else {
            Write-Host "No apps file found." -ForegroundColor Yellow
        }
    }

    default {
        if (-not $Action) {
            Write-Host "Usage:" -ForegroundColor Yellow
            Write-Host "  app_launcher add <shortname> <app_name>  : Add favorite app" -ForegroundColor White
            Write-Host "  app_launcher list                        : List favorites" -ForegroundColor White
            Write-Host "  app_launcher remove <shortname>          : Remove favorite" -ForegroundColor White
            Write-Host "  app_launcher <shortname>                 : Launch favorite app" -ForegroundColor White
            exit 1
        }

        if (Test-Path $APPS_FILE) {
            $appEntry = Get-Content $APPS_FILE | Where-Object { $_ -match "^$Action`:" } | Select-Object -First 1

            if ($appEntry) {
                $appPath = ($appEntry -split ':', 2)[1]

                try {
                    # Try different ways to launch the app
                    if ($appPath -match '\.exe$|\.msi$|\.com$') {
                        # Executable file
                        Start-Process -FilePath $appPath
                    } else {
                        # Try as app name first, then as path
                        try {
                            Start-Process -FilePath $appPath
                        } catch {
                            # Try Windows Store app or installed program
                            Start-Process "shell:AppsFolder\$appPath"
                        }
                    }
                    Write-Host "Launched: $appPath" -ForegroundColor Green
                } catch {
                    Write-Host "Failed to launch '$appPath': $($_.Exception.Message)" -ForegroundColor Red
                    Write-Host "Tip: Make sure the path is correct or use the full executable path" -ForegroundColor Yellow
                }
            } else {
                Write-Host "App '$Action' not found. Use 'app_launcher list' to see available apps." -ForegroundColor Yellow
            }
        } else {
            Write-Host "No favorite apps configured yet." -ForegroundColor Yellow
        }
    }
}