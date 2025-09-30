param(
    [Parameter(Position=0)]
    [string]$Action,

    [Parameter(Position=1)]
    [string]$WorkspaceName
)

$WORKSPACE_DIR = "$env:USERPROFILE\.workspaces"

if (!(Test-Path $WORKSPACE_DIR)) {
    New-Item -Path $WORKSPACE_DIR -ItemType Directory -Force | Out-Null
}

switch ($Action.ToLower()) {
    "save" {
        if (-not $WorkspaceName) {
            Write-Host "Usage: workspace_manager save <workspace_name>" -ForegroundColor Red
            exit 1
        }

        $workspaceFile = "$WORKSPACE_DIR\$WorkspaceName.workspace"
        $currentDir = Get-Location

        $workspaceContent = @"
# Workspace: $WorkspaceName
# Saved: $(Get-Date)
DIRECTORY=$currentDir

# Running Processes (that might be relevant):
"@

        # Get running processes that might be development-related
        $relevantProcesses = Get-Process | Where-Object {
            $_.ProcessName -match "code|studio|notepad|chrome|firefox|edge|cmd|powershell"
        } | Select-Object ProcessName, MainWindowTitle | Format-Table -AutoSize | Out-String

        $workspaceContent += $relevantProcesses

        $workspaceContent | Out-File -FilePath $workspaceFile -Encoding UTF8

        Write-Host "Workspace '$WorkspaceName' saved" -ForegroundColor Green
    }

    "load" {
        if (-not $WorkspaceName) {
            Write-Host "Available workspaces:" -ForegroundColor Cyan
            $workspaces = Get-ChildItem -Path $WORKSPACE_DIR -Filter "*.workspace" -ErrorAction SilentlyContinue
            if ($workspaces) {
                $workspaces | ForEach-Object {
                    $name = $_.BaseName
                    Write-Host "  $name" -ForegroundColor White
                }
            } else {
                Write-Host "No workspaces saved" -ForegroundColor Yellow
            }
            exit 1
        }

        $workspaceFile = "$WORKSPACE_DIR\$WorkspaceName.workspace"
        if (Test-Path $workspaceFile) {
            Write-Host "Loading workspace: $WorkspaceName" -ForegroundColor Cyan

            $content = Get-Content $workspaceFile
            $directoryLine = $content | Where-Object { $_ -match "^DIRECTORY=" }

            if ($directoryLine) {
                $targetDir = $directoryLine -replace "^DIRECTORY=", ""

                if (Test-Path $targetDir) {
                    try {
                        Set-Location $targetDir
                        Write-Host "Switched to: $targetDir" -ForegroundColor Green
                    } catch {
                        Write-Host "Failed to change directory to: $targetDir" -ForegroundColor Red
                        Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
                    }
                } else {
                    Write-Host "Directory no longer exists: $targetDir" -ForegroundColor Red
                }
            }

            Write-Host "Workspace '$WorkspaceName' loaded" -ForegroundColor Green
        } else {
            Write-Host "Workspace '$WorkspaceName' not found" -ForegroundColor Red
        }
    }

    "list" {
        Write-Host "=== Saved Workspaces ===" -ForegroundColor Cyan
        $workspaces = Get-ChildItem -Path $WORKSPACE_DIR -Filter "*.workspace" -ErrorAction SilentlyContinue

        if ($workspaces) {
            foreach ($workspace in $workspaces) {
                $name = $workspace.BaseName
                $content = Get-Content $workspace.FullName
                $savedLine = $content | Where-Object { $_ -match "^# Saved:" }

                if ($savedLine) {
                    $saved = $savedLine -replace "^# Saved: ", ""
                    Write-Host "$name - $saved" -ForegroundColor White
                } else {
                    Write-Host "$name" -ForegroundColor White
                }
            }
        } else {
            Write-Host "No workspaces saved yet." -ForegroundColor Yellow
        }
    }

    "remove" {
        if (-not $WorkspaceName) {
            Write-Host "Usage: workspace_manager remove <workspace_name>" -ForegroundColor Red
            exit 1
        }

        $workspaceFile = "$WORKSPACE_DIR\$WorkspaceName.workspace"
        if (Test-Path $workspaceFile) {
            Remove-Item $workspaceFile -Force
            Write-Host "Workspace '$WorkspaceName' removed" -ForegroundColor Green
        } else {
            Write-Host "Workspace '$WorkspaceName' not found" -ForegroundColor Red
        }
    }

    "show" {
        if (-not $WorkspaceName) {
            Write-Host "Usage: workspace_manager show <workspace_name>" -ForegroundColor Red
            exit 1
        }

        $workspaceFile = "$WORKSPACE_DIR\$WorkspaceName.workspace"
        if (Test-Path $workspaceFile) {
            Write-Host "=== Workspace: $WorkspaceName ===" -ForegroundColor Cyan
            Get-Content $workspaceFile | ForEach-Object {
                Write-Host $_ -ForegroundColor White
            }
        } else {
            Write-Host "Workspace '$WorkspaceName' not found" -ForegroundColor Red
        }
    }

    default {
        Write-Host "Usage: workspace_manager {save|load|list|remove|show}" -ForegroundColor Yellow
        Write-Host "  save <name>   : Save current workspace" -ForegroundColor White
        Write-Host "  load <name>   : Load workspace" -ForegroundColor White
        Write-Host "  list          : List all workspaces" -ForegroundColor White
        Write-Host "  remove <name> : Remove workspace" -ForegroundColor White
        Write-Host "  show <name>   : Show workspace details" -ForegroundColor White
    }
}