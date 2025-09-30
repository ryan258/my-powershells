#!/usr/bin/env powershell
<#
.SYNOPSIS
    Sets up a DDEV environment for a specific Drupal module.

.PARAMETER ModuleName
    The machine name of the module to set up (e.g., 'token', 'ctools').
#>
param(
    [Parameter(Mandatory=$true)]
    [string]$ModuleName
)

$ErrorActionPreference = 'Stop'

$moduleRepo = "https://git.drupalcode.org/project/$ModuleName.git"

Write-Host "Setting up environment for Drupal module: $ModuleName..." -ForegroundColor Yellow

# Get the path to the main script
$scriptPath = "$PSScriptRoot\new-drupal-project.ps1"

& $scriptPath -ProjectName $ModuleName -GitRepo $moduleRepo
