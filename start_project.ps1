$ErrorActionPreference = 'Stop'

$projectName = Read-Host "What is the name of your new project?"

if ([string]::IsNullOrWhiteSpace($projectName)) {
    Write-Host "No project name given. Exiting." -ForegroundColor Red
    exit 1
}

Write-Host "Creating project: $projectName" -ForegroundColor Cyan

try {
    # Create project directory structure
    $projectPath = Join-Path (Get-Location) $projectName

    # Create main directory and subdirectories
    New-Item -Path $projectPath -ItemType Directory -Force | Out-Null
    New-Item -Path "$projectPath\src" -ItemType Directory -Force | Out-Null
    New-Item -Path "$projectPath\docs" -ItemType Directory -Force | Out-Null
    New-Item -Path "$projectPath\assets" -ItemType Directory -Force | Out-Null
    New-Item -Path "$projectPath\tests" -ItemType Directory -Force | Out-Null

    # Create README.md with project title
    $readmeContent = @"
# $projectName

## Description
[Add project description here]

## Installation
[Add installation instructions here]

## Usage
[Add usage instructions here]

## Contributing
[Add contributing guidelines here]

## License
[Add license information here]
"@

    $readmeContent | Out-File -FilePath "$projectPath\README.md" -Encoding UTF8

    # Create basic .gitignore
    $gitignoreContent = @"
# Dependencies
node_modules/
venv/
env/

# Build outputs
dist/
build/
*.exe
*.dll

# IDE files
.vscode/
.vs/
*.suo
*.user

# OS files
.DS_Store
Thumbs.db

# Logs
*.log
logs/

# Environment variables
.env
.env.local

# Temporary files
temp/
tmp/
*.tmp
"@

    $gitignoreContent | Out-File -FilePath "$projectPath\.gitignore" -Encoding UTF8

    Write-Host "Project created successfully!" -ForegroundColor Green
    Write-Host "Project location: $projectPath" -ForegroundColor White

    # Ask if user wants to initialize git
    $initGit = Read-Host "Initialize git repository? (y/n)"
    if ($initGit -eq 'y' -or $initGit -eq 'Y') {
        Push-Location $projectPath
        try {
            git init
            git add .
            git commit -m "Initial commit"
            Write-Host "Git repository initialized with initial commit." -ForegroundColor Green
        } catch {
            Write-Host "Failed to initialize git: $($_.Exception.Message)" -ForegroundColor Yellow
        } finally {
            Pop-Location
        }
    }

    # Ask if user wants to navigate to the project
    $changeDir = Read-Host "Navigate to project directory? (y/n)"
    if ($changeDir -eq 'y' -or $changeDir -eq 'Y') {
        Set-Location $projectPath
        Write-Host "You are now in the '$projectName' directory." -ForegroundColor Green
    } else {
        Write-Host "Tip: run 'Set-Location `"$projectPath`"' to enter the project directory." -ForegroundColor Gray
    }

    # Show project structure
    Write-Host ""
    Write-Host "Project structure created:" -ForegroundColor Cyan
    Get-ChildItem $projectPath -Recurse | ForEach-Object {
        $relativePath = $_.FullName.Replace($projectPath, "")
        Write-Host "  $projectName$relativePath" -ForegroundColor White
    }

} catch {
    Write-Host "Failed to create project: $($_.Exception.Message)" -ForegroundColor Red
}