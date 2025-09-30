<#
.SYNOPSIS
    Automates the setup of a new Drupal 11 project using DDEV.

.DESCRIPTION
    This script handles everything from creating the project directory to installing Drupal,
    providing a ready-to-use local development environment. It can either create a
    brand-new site or clone an existing repository for contributing.

.PARAMETER ProjectName
    The name of the project and the directory to be created. This is mandatory.

.PARAMETER GitRepo
    (Optional) The full Git URL of a Drupal project to clone. If provided, the script
    will set up a contribution environment. If omitted, it will create a new site.

.EXAMPLE
    # Create a new Drupal project named 'my-new-site'
    .new-drupal-project.ps1 -ProjectName my-new-site

.EXAMPLE
    # Set up a local environment for contributing to the 'token' module
    .new-drupal-project.ps1 -ProjectName token -GitRepo https://git.drupalcode.org/project/token.git
#>
param(
    [Parameter(Mandatory=$true)]
    [string]$ProjectName,

    [Parameter()]
    [string]$GitRepo
)

$ErrorActionPreference = 'Stop'

# --- Verification ---
Write-Host "Checking for DDEV..." -ForegroundColor Cyan
$ddevCheck = Get-Command ddev -ErrorAction SilentlyContinue
if (-not $ddevCheck) {
    Write-Host "DDEV command not found. Please ensure DDEV is installed and accessible in your PATH." -ForegroundColor Red
    exit 1
}
Write-Host "DDEV found." -ForegroundColor Green

Write-Host "Checking for Git..." -ForegroundColor Cyan
$gitCheck = Get-Command git -ErrorAction SilentlyContinue
if (-not $gitCheck) {
    Write-Host "Git command not found. Please ensure Git is installed and accessible in your PATH." -ForegroundColor Red
    exit 1
}
Write-Host "Git found." -ForegroundColor Green

# --- Main Logic ---
$projectPath = Join-Path (Get-Location) $ProjectName

if (Test-Path $projectPath) {
    Write-Host "Error: A directory named '$ProjectName' already exists in this location." -ForegroundColor Red
    exit 1
}

try {
    if ([string]::IsNullOrEmpty($GitRepo)) {
        # --- New Project Workflow ---
        Write-Host "--- Creating a new Drupal project: $ProjectName ---" -ForegroundColor Yellow

        Write-Host "(1/6) Creating project directory..." -ForegroundColor Cyan
        New-Item -Path $projectPath -ItemType Directory | Out-Null
        Set-Location $projectPath

        Write-Host "(2/6) Configuring DDEV..." -ForegroundColor Cyan
        ddev config --project-type=drupal11 --docroot=web --create-docroot

        Write-Host "(3/6) Starting DDEV environment..." -ForegroundColor Cyan
        ddev start

        Write-Host "(4/6) Downloading Drupal with Composer..." -ForegroundColor Cyan
        ddev composer create drupal/recommended-project --no-install --no-progress

        Write-Host "(5/6) Installing Drupal dependencies..." -ForegroundColor Cyan
        ddev composer install --no-progress

        Write-Host "(6/6) Installing Drupal site with Drush..." -ForegroundColor Cyan
        ddev drush site:install -y
    }
    else {
        # --- Contribution Workflow ---
        Write-Host "--- Setting up contribution environment for $ProjectName from $GitRepo ---" -ForegroundColor Yellow

        Write-Host "(1/6) Cloning repository..." -ForegroundColor Cyan
        git clone $GitRepo $ProjectName
        Set-Location $projectPath

        Write-Host "(2/6) Configuring DDEV..." -ForegroundColor Cyan
        ddev config --project-type=drupal11 --docroot=web

        Write-Host "(3/6) Starting DDEV environment..." -ForegroundColor Cyan
        ddev start

        Write-Host "(4/6) Installing Drupal dependencies with Composer..." -ForegroundColor Cyan
        ddev composer install --no-progress

        Write-Host "(5/6) Installing Drupal site with Drush..." -ForegroundColor Cyan
        ddev drush site:install -y

        Write-Host "(6/6) Setup complete." -ForegroundColor Cyan
    }

    # --- Success ---
    Write-Host ""
    Write-Host "✅ Project '$ProjectName' is ready!" -ForegroundColor Green
    Write-Host ""
    ddev describe
    Write-Host ""
    Write-Host "Launching your new site in the browser..." -ForegroundColor Yellow
    ddev launch

} catch {
    Write-Host "An error occurred during setup: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "Please check the output above for details. You may need to run 'ddev delete -O' in the '$projectPath' directory to clean up before trying again." -ForegroundColor Yellow
    exit 1
}
