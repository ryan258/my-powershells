#!/usr/bin/env powershell
<#
.SYNOPSIS
    Sets up a new DDEV environment for a headless Drupal backend.

.PARAMETER ProjectName
    The name of the project and the directory to be created.
#>
param(
    [Parameter(Mandatory=$true)]
    [string]$ProjectName
)

$ErrorActionPreference = 'Stop'

Write-Host "Setting up a new headless Drupal backend: $ProjectName..." -ForegroundColor Yellow

# Get the path to the main script
$scriptPath = (Get-Command new-drupal-project.ps1).Source

& $scriptPath -ProjectName $ProjectName

# Add post-setup instructions for headless
Write-Host ""
Write-Host "--- Next Steps for Headless ---" -ForegroundColor Yellow
Write-Host "Your Drupal backend is ready. To complete your headless setup:"
Write-Host "1. Enable the 'JSON:API' module in your new Drupal site."
Write-Host "2. Configure permissions for API access under 'People > Permissions' for the relevant roles."
Write-Host "3. In a separate directory, create your frontend project (e.g., Next.js, Gatsby, Hugo)."
Write-Host "4. Use the URL provided by 'ddev describe' (`https://$ProjectName.ddev.site`) as your Drupal backend URL in your frontend application."
