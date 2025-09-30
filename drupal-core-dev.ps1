#!/usr/bin/env powershell
<#
.SYNOPSIS
    Sets up a DDEV environment for Drupal Core development.
#>

$ErrorActionPreference = 'Stop'

$coreRepo = "https://git.drupalcode.org/project/drupal.git"
$projectName = "drupal"

Write-Host "Setting up environment for Drupal Core contribution..." -ForegroundColor Yellow

# Get the path to the main script
$scriptPath = "$PSScriptRoot\new-drupal-project.ps1"

& $scriptPath -ProjectName $projectName -GitRepo $coreRepo
