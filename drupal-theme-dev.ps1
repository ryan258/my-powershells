#!/usr/bin/env powershell
<#
.SYNOPSIS
    Sets up a DDEV environment for a specific Drupal theme.

.PARAMETER ThemeName
    The machine name of the theme to set up (e.g., 'bootstrap5').
#>
param(
    [Parameter(Mandatory=$true)]
    [string]$ThemeName
)

$ErrorActionPreference = 'Stop'

$themeRepo = "https://git.drupalcode.org/project/$ThemeName.git"

Write-Host "Setting up environment for Drupal theme: $ThemeName..." -ForegroundColor Yellow

# Get the path to the main script
$scriptPath = (Get-Command new-drupal-project.ps1).Source

& $scriptPath -ProjectName $ThemeName -GitRepo $themeRepo
