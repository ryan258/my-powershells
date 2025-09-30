param(
    [Parameter(Position=0)]
    [string]$Action,

    [Parameter(Position=1, ValueFromRemainingArguments=$true)]
    [string[]]$Arguments
)

switch ($Action.ToLower()) {
    "server" {
        $port = if ($Arguments -and $Arguments[0]) { $Arguments[0] } else { "8000" }
        Write-Host "Starting development server on port $port..." -ForegroundColor Cyan
        Write-Host "Access at: http://localhost:$port" -ForegroundColor Green

        try {
            # Try Python first
            if (Get-Command python -ErrorAction SilentlyContinue) {
                python -m http.server $port
            } elseif (Get-Command python3 -ErrorAction SilentlyContinue) {
                python3 -m http.server $port
            } else {
                # Fallback to PowerShell simple server
                Write-Host "Python not found. Starting simple PowerShell server..." -ForegroundColor Yellow

                $listener = New-Object System.Net.HttpListener
                $listener.Prefixes.Add("http://localhost:$port/")
                $listener.Start()
                Write-Host "Server started. Press Ctrl+C to stop." -ForegroundColor Green

                try {
                    while ($listener.IsListening) {
                        $context = $listener.GetContext()
                        $response = $context.Response
                        $content = "<h1>PowerShell Simple Server</h1><p>Server running on port $port</p>"
                        $buffer = [System.Text.Encoding]::UTF8.GetBytes($content)
                        $response.ContentLength64 = $buffer.Length
                        $response.OutputStream.Write($buffer, 0, $buffer.Length)
                        $response.OutputStream.Close()
                    }
                } finally {
                    $listener.Stop()
                }
            }
        } catch {
            Write-Host "Failed to start server: $($_.Exception.Message)" -ForegroundColor Red
        }
    }

    "json" {
        if ($Arguments -and $Arguments[0]) {
            $file = $Arguments[0]
            if (Test-Path $file) {
                Write-Host "Pretty printing JSON from file: $file" -ForegroundColor Cyan
                try {
                    Get-Content $file | ConvertFrom-Json | ConvertTo-Json -Depth 10
                } catch {
                    Write-Host "Invalid JSON in file: $($_.Exception.Message)" -ForegroundColor Red
                }
            } else {
                Write-Host "File not found: $file" -ForegroundColor Red
            }
        } else {
            Write-Host "Pretty printing JSON from clipboard:" -ForegroundColor Cyan
            try {
                $clipContent = Get-Clipboard -Raw
                if ($clipContent) {
                    $clipContent | ConvertFrom-Json | ConvertTo-Json -Depth 10
                } else {
                    Write-Host "Clipboard is empty" -ForegroundColor Yellow
                }
            } catch {
                Write-Host "Invalid JSON in clipboard: $($_.Exception.Message)" -ForegroundColor Red
            }
        }
    }

    "env" {
        if (!(Test-Path "venv")) {
            Write-Host "Creating virtual environment..." -ForegroundColor Cyan
            try {
                if (Get-Command python -ErrorAction SilentlyContinue) {
                    python -m venv venv
                } elseif (Get-Command python3 -ErrorAction SilentlyContinue) {
                    python3 -m venv venv
                } else {
                    Write-Host "Python not found. Please install Python first." -ForegroundColor Red
                    exit 1
                }
            } catch {
                Write-Host "Failed to create virtual environment: $($_.Exception.Message)" -ForegroundColor Red
                exit 1
            }
        }

        Write-Host "Virtual environment ready." -ForegroundColor Green
        Write-Host "To activate: .\venv\Scripts\Activate.ps1" -ForegroundColor Yellow
        Write-Host "To deactivate: deactivate" -ForegroundColor Yellow
    }

    "gitquick" {
        if (-not $Arguments -or $Arguments.Count -eq 0) {
            Write-Host "Usage: dev_shortcuts gitquick <commit_message>" -ForegroundColor Red
            exit 1
        }

        $commitMessage = $Arguments -join " "

        try {
            Write-Host "Adding all changes..." -ForegroundColor Cyan
            git add .

            Write-Host "Committing changes..." -ForegroundColor Cyan
            git commit -m $commitMessage

            Write-Host "Pushing to remote..." -ForegroundColor Cyan
            git push

            Write-Host "Changes committed and pushed: $commitMessage" -ForegroundColor Green
        } catch {
            Write-Host "Git operation failed: $($_.Exception.Message)" -ForegroundColor Red
        }
    }

    "npm" {
        $subAction = if ($Arguments -and $Arguments[0]) { $Arguments[0] } else { "start" }

        switch ($subAction.ToLower()) {
            "init" {
                Write-Host "Initializing new npm project..." -ForegroundColor Cyan
                npm init -y
            }
            "install" {
                Write-Host "Installing dependencies..." -ForegroundColor Cyan
                npm install
            }
            "dev" {
                Write-Host "Starting development server..." -ForegroundColor Cyan
                npm run dev
            }
            "build" {
                Write-Host "Building project..." -ForegroundColor Cyan
                npm run build
            }
            default {
                Write-Host "Starting npm script: $subAction" -ForegroundColor Cyan
                npm run $subAction
            }
        }
    }

    "code" {
        $target = if ($Arguments -and $Arguments[0]) { $Arguments[0] } else { "." }
        Write-Host "Opening VS Code..." -ForegroundColor Cyan
        code $target
    }

    default {
        Write-Host "Usage: dev_shortcuts {server|json|env|gitquick|npm|code}" -ForegroundColor Yellow
        Write-Host "  server [port]     : Start development server (default port 8000)" -ForegroundColor White
        Write-Host "  json [file]       : Pretty print JSON (from clipboard or file)" -ForegroundColor White
        Write-Host "  env               : Create Python virtual environment" -ForegroundColor White
        Write-Host "  gitquick <msg>    : Quick git add, commit, push" -ForegroundColor White
        Write-Host "  npm [action]      : Run npm commands (init|install|dev|build|start)" -ForegroundColor White
        Write-Host "  code [path]       : Open VS Code (default: current directory)" -ForegroundColor White
    }
}