$projectName = Read-Host "Enter your Python project name"

if ([string]::IsNullOrWhiteSpace($projectName)) {
    Write-Host "No project name provided. Exiting." -ForegroundColor Red
    exit 1
}

if (Test-Path $projectName) {
    Write-Host "Error: Directory '$projectName' already exists." -ForegroundColor Red
    exit 1
}

Write-Host "Creating project directory: $projectName" -ForegroundColor Cyan
New-Item -Path $projectName -ItemType Directory | Out-Null
Set-Location $projectName

Write-Host "Setting up Python virtual environment in 'venv'..." -ForegroundColor Cyan

try {
    # Try different Python commands
    $pythonCmd = $null
    $pythonCommands = @("python", "python3", "py")

    foreach ($cmd in $pythonCommands) {
        if (Get-Command $cmd -ErrorAction SilentlyContinue) {
            $pythonCmd = $cmd
            break
        }
    }

    if (-not $pythonCmd) {
        Write-Host "Python not found. Please install Python first." -ForegroundColor Red
        exit 1
    }

    & $pythonCmd -m venv venv
    Write-Host "Virtual environment created successfully." -ForegroundColor Green
} catch {
    Write-Host "Failed to create virtual environment: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "Make sure Python is installed and accessible." -ForegroundColor Yellow
}

Write-Host "Creating .gitignore file..." -ForegroundColor Cyan
$gitignoreContent = @"
# Python virtual environment
venv/
env/

# Python cache files
__pycache__/
*.py[cod]
*$py.class

# Distribution / packaging
.Python
build/
develop-eggs/
dist/
downloads/
eggs/
.eggs/
lib/
lib64/
parts/
sdist/
var/
wheels/
*.egg-info/
.installed.cfg
*.egg
MANIFEST

# PyInstaller
*.manifest
*.spec

# Installer logs
pip-log.txt
pip-delete-this-directory.txt

# Unit test / coverage reports
htmlcov/
.tox/
.coverage
.coverage.*
.cache
nosetests.xml
coverage.xml
*.cover
.hypothesis/
.pytest_cache/

# Translations
*.mo
*.pot

# Django stuff:
*.log
local_settings.py
db.sqlite3

# Flask stuff:
instance/
.webassets-cache

# Scrapy stuff:
.scrapy

# Sphinx documentation
docs/_build/

# PyBuilder
target/

# Jupyter Notebook
.ipynb_checkpoints

# pyenv
.python-version

# celery beat schedule file
celerybeat-schedule

# SageMath parsed files
*.sage.py

# Environment variables
.env
.venv
ENV/
env/
venv/

# Spyder project settings
.spyderproject
.spyproject

# Rope project settings
.ropeproject

# mkdocs documentation
/site

# mypy
.mypy_cache/
.dmypy.json
dmypy.json

# Windows specific
Thumbs.db
ehthumbs.db
Desktop.ini

# VS Code
.vscode/

# PyCharm
.idea/
"@

$gitignoreContent | Out-File -FilePath ".gitignore" -Encoding UTF8

Write-Host "Creating requirements.txt..." -ForegroundColor Cyan
New-Item -Path "requirements.txt" -ItemType File | Out-Null

Write-Host "Creating main.py with a starter template..." -ForegroundColor Cyan
$mainPyContent = @"
#!/usr/bin/env python3
"""
$projectName - Main module

A Python project created with mkproject_py.ps1
"""

def main():
    """Main function for the project."""
    print(f"Hello from {projectName}!")
    print("Your Python project is ready!")


if __name__ == "__main__":
    main()
"@

$mainPyContent | Out-File -FilePath "main.py" -Encoding UTF8

Write-Host "Creating README.md..." -ForegroundColor Cyan
$readmeContent = @"
# $projectName

## Description
[Add project description here]

## Setup

1. **Activate the virtual environment:**
   ```
   # Windows
   .\venv\Scripts\Activate.ps1

   # macOS/Linux
   source venv/bin/activate
   ```

2. **Install dependencies:**
   ```
   pip install -r requirements.txt
   ```

3. **Run the project:**
   ```
   python main.py
   ```

## Development

- Add your dependencies to `requirements.txt`
- Write your main code in `main.py` or create additional modules
- Use `pip freeze > requirements.txt` to update dependencies

## Project Structure
```
$projectName/
├── venv/              # Virtual environment
├── main.py            # Main application file
├── requirements.txt   # Python dependencies
├── .gitignore        # Git ignore file
└── README.md         # This file
```
"@

$readmeContent | Out-File -FilePath "README.md" -Encoding UTF8

# Initialize Git if available
if (Get-Command git -ErrorAction SilentlyContinue) {
    Write-Host "Initializing Git repository..." -ForegroundColor Cyan
    try {
        git init | Out-Null
        git add .
        git commit -m "Initial commit: Python project setup" | Out-Null
        Write-Host "Git repository initialized with initial commit." -ForegroundColor Green
    } catch {
        Write-Host "Git initialization failed: $($_.Exception.Message)" -ForegroundColor Yellow
    }
} else {
    Write-Host "Git not found. Skipping repository initialization." -ForegroundColor Yellow
}

Write-Host ""
Write-Host "✅ Project '$projectName' created successfully!" -ForegroundColor Green
Write-Host ""
Write-Host "--- Next Steps ---" -ForegroundColor Cyan
Write-Host "1. Navigate into your project: Set-Location $projectName" -ForegroundColor White
Write-Host "2. Activate the virtual environment: .\venv\Scripts\Activate.ps1" -ForegroundColor White
Write-Host "3. Install packages: pip install <package_name>" -ForegroundColor White
Write-Host "4. Add packages to requirements.txt: pip freeze > requirements.txt" -ForegroundColor White
Write-Host "5. Start coding in main.py!" -ForegroundColor White
Write-Host ""

# Ask if user wants to activate the environment
$activate = Read-Host "Activate virtual environment now? (y/n)"
if ($activate -eq 'y' -or $activate -eq 'Y') {
    Write-Host "To activate the virtual environment, run:" -ForegroundColor Yellow
    Write-Host ".\venv\Scripts\Activate.ps1" -ForegroundColor Green
    Write-Host ""
    Write-Host "Note: You may need to adjust PowerShell execution policy:" -ForegroundColor Gray
    Write-Host "Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser" -ForegroundColor Gray
}