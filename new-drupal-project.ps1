<#
.SYNOPSIS
    Automates the setup of Drupal development environments using DDEV.

.DESCRIPTION
    Supports multiple workflows:
      - Create a brand-new Drupal site using the recommended project template.
      - Clone an existing Drupal project and bootstrap it with DDEV.
      - Scaffold contribution sandboxes for Drupal core, modules, or themes.

.PARAMETER ProjectName
    The name of the project directory to create (or use when cloning).

.PARAMETER GitRepo
    (Optional) Git URL of a Drupal project, module, or theme to clone.

.PARAMETER SetupType
    Controls the workflow. Valid values: site (default), core, module, theme.

.PARAMETER Docroot
    (Optional) Overrides docroot detection when cloning existing projects.

.PARAMETER SkipLaunch
    Skip the final `ddev launch` call. Connection info is still printed.

.PARAMETER SkipSiteInstall
    Skip the automatic `ddev drush site:install` step (useful when importing an existing database).

.PARAMETER LinkExtensionDependencies
    Adds the cloned module/theme as a Composer path repository and runs `composer require` so its PHP dependencies are installed automatically.

.EXAMPLE
    # Create a new Drupal site named "my-project"
    .\new-drupal-project.ps1 -ProjectName my-project

.EXAMPLE
    # Bootstrap a Drupal core contribution checkout
    .\new-drupal-project.ps1 -ProjectName drupal -GitRepo https://git.drupalcode.org/project/drupal.git -SetupType core

.EXAMPLE
    # Create a contribution sandbox for the "token" module with dependency linking
    .\new-drupal-project.ps1 -ProjectName token -GitRepo https://git.drupalcode.org/project/token.git -SetupType module -LinkExtensionDependencies
#>
param(
    [Parameter(Mandatory = $true)]
    [string]$ProjectName,

    [Parameter()]
    [string]$GitRepo,

    [Parameter()]
    [ValidateSet('site', 'core', 'module', 'theme')]
    [string]$SetupType = 'site',

    [Parameter()]
    [string]$Docroot,

    [switch]$SkipLaunch,
    [switch]$SkipSiteInstall,
    [switch]$LinkExtensionDependencies
)

$ErrorActionPreference = 'Stop'

function Ensure-Command {
    param([string]$Name)
    if (-not (Get-Command $Name -ErrorAction SilentlyContinue)) {
        throw "Required command '$Name' not found in PATH."
    }
}

function Resolve-Docroot {
    param(
        [string]$ProjectRoot,
        [string]$UserDocroot
    )

    if ($UserDocroot) {
        $candidatePath = if ($UserDocroot -eq '.' -or $UserDocroot -eq '') { $ProjectRoot } else { Join-Path $ProjectRoot $UserDocroot }
        if (-not (Test-Path $candidatePath)) {
            throw "Docroot override '$UserDocroot' does not exist inside $ProjectRoot."
        }
        if ($UserDocroot -eq '.' -or $UserDocroot -eq '') {
            return '.'
        }
        return $UserDocroot
    }

    $candidates = @('web', 'docroot', 'html', 'public', '.')
    foreach ($candidate in $candidates) {
        $path = if ($candidate -eq '.') { $ProjectRoot } else { Join-Path $ProjectRoot $candidate }
        $hasIndex = Test-Path (Join-Path $path 'index.php')
        $hasCoreBootstrap = Test-Path (Join-Path $path 'core/install.php')
        if ($hasIndex -or $hasCoreBootstrap) {
            if ($candidate -eq '.') {
                return '.'
            }
            return $candidate
        }
    }

    return $null
}

function Show-ConnectionInfo {
    param([switch]$SkipLaunch)

    try {
        ddev describe
    } catch {
        Write-Host "Unable to retrieve DDEV connection info: $($_.Exception.Message)" -ForegroundColor Yellow
        return
    }

    if ($SkipLaunch) {
        Write-Host "Skipped automatic browser launch. Run 'ddev launch' when ready." -ForegroundColor Yellow
    } else {
        try {
            ddev launch
        } catch {
            Write-Host "Failed to launch browser automatically: $($_.Exception.Message)" -ForegroundColor Yellow
        }
    }
}

function Setup-NewSite {
    param(
        [string]$ProjectPath,
        [switch]$SkipLaunch,
        [switch]$SkipSiteInstall
    )

    Write-Host "--- Creating a new Drupal project ---" -ForegroundColor Yellow

    New-Item -Path $ProjectPath -ItemType Directory | Out-Null
    Push-Location $ProjectPath
    try {
        Write-Host "(1/5) Configuring DDEV" -ForegroundColor Cyan
        ddev config --project-type=drupal11 --docroot=web | Out-Null

        Write-Host "(2/5) Starting DDEV (this may take a minute...)" -ForegroundColor Cyan
        ddev start --skip-confirmation | Out-Null

        Write-Host "(3/6) Installing Drupal scaffold with Composer" -ForegroundColor Cyan
        ddev composer create drupal/recommended-project . --no-progress | Out-Null

        Write-Host "(4/7) Installing Drush" -ForegroundColor Cyan
        ddev composer require drush/drush --no-progress | Out-Null

        Write-Host "(5/7) Installing Developer Tools (Devel, Admin Toolbar, Coder)" -ForegroundColor Cyan
        ddev composer require drupal/devel drupal/admin_toolbar drupal/coder --dev --no-progress | Out-Null

        if (-not $SkipSiteInstall) {
            Write-Host "(6/7) Installing Drupal via Drush with user/pass: admin/admin" -ForegroundColor Cyan
            ddev drush site:install standard --account-name=admin --account-pass=admin -y | Out-Null
            $Global:DrupalAdminPassword = "admin"
        } else {
            Write-Host "(6/7) Skipping Drush site install (-SkipSiteInstall provided)." -ForegroundColor Yellow
        }

        Write-Host "(7/7) Finalizing environment" -ForegroundColor Cyan
        Show-ConnectionInfo -SkipLaunch:$SkipLaunch
    } finally {
        Pop-Location
    }
}

function Setup-ExistingProject {
    param(
        [string]$ProjectPath,
        [string]$GitRepo,
        [string]$Docroot,
        [switch]$SkipLaunch,
        [switch]$SkipSiteInstall
    )

    Write-Host "--- Cloning existing project ---" -ForegroundColor Yellow
    git clone $GitRepo $ProjectPath | Out-Null

    Push-Location $ProjectPath
    try {
        $projectRoot = (Get-Location).ProviderPath
        $resolvedDocroot = Resolve-Docroot -ProjectRoot $projectRoot -UserDocroot $Docroot
        if (-not $resolvedDocroot) {
            throw "Unable to determine docroot for cloned project. Specify -Docroot explicitly."
        }

        $docrootArg = if ($resolvedDocroot -eq '.') { '--docroot=.' } else { "--docroot=$resolvedDocroot" }

        Write-Host "Docroot detected: $resolvedDocroot" -ForegroundColor Green

        Write-Host "(1/4) Configuring DDEV" -ForegroundColor Cyan
        ddev config --project-type=drupal11 $docrootArg | Out-Null

        Write-Host "(2/4) Starting DDEV (this may take a minute...)" -ForegroundColor Cyan
        ddev start --skip-confirmation | Out-Null

        $composerFile = Join-Path $projectRoot 'composer.json'
        if (Test-Path $composerFile) {
            Write-Host "(3/4) Installing Composer dependencies" -ForegroundColor Cyan
            ddev composer install --no-progress | Out-Null
        } else {
            Write-Host "composer.json not found; skipping dependency install." -ForegroundColor Yellow
        }

        if (-not $SkipSiteInstall) {
            Write-Host "(4/4) Attempting Drupal site install" -ForegroundColor Cyan
            try {
                ddev drush site:install -y | Out-Null
            } catch {
                Write-Host "Drush site:install did not complete automatically: $($_.Exception.Message)" -ForegroundColor Yellow
                Write-Host "You may need to import an existing database or complete installation manually." -ForegroundColor Yellow
            }
        } else {
            Write-Host "(4/4) Skipping Drush site install (-SkipSiteInstall provided)." -ForegroundColor Yellow
        }

        Show-ConnectionInfo -SkipLaunch:$SkipLaunch
    } finally {
        Pop-Location
    }
}

function Setup-ContributionSandbox {
    param(
        [ValidateSet('module', 'theme')]
        [string]$Kind,
        [string]$ProjectPath,
        [string]$GitRepo,
        [switch]$SkipLaunch,
        [switch]$SkipSiteInstall,
        [switch]$LinkDependencies
    )

    Setup-NewSite -ProjectPath $ProjectPath -SkipLaunch:$true -SkipSiteInstall:$SkipSiteInstall

    Push-Location $ProjectPath
    try {
        $subdir = if ($Kind -eq 'module') { 'web/modules/custom' } else { 'web/themes/custom' }
        $targetDir = Join-Path $subdir $ProjectName
        $absoluteTarget = Join-Path (Get-Location).ProviderPath $targetDir

        $targetParent = Split-Path $absoluteTarget -Parent
        if (-not (Test-Path $targetParent)) {
            New-Item -Path $targetParent -ItemType Directory -Force | Out-Null
        }

        Write-Host "Cloning $Kind repository into $targetDir" -ForegroundColor Cyan
        git clone $GitRepo $absoluteTarget | Out-Null

        if ($LinkDependencies) {
            $relativePath = ($targetDir -replace '\\', '/')
            $repositoryKey = "sandbox-$ProjectName"
            try {
                Write-Host "Linking $Kind dependencies via Composer path repository" -ForegroundColor Cyan
                ddev composer config "repositories.$repositoryKey" path $relativePath --working-dir . | Out-Null
            } catch {
                Write-Host "Failed to register Composer path repository: $($_.Exception.Message)" -ForegroundColor Yellow
            }

            $extensionComposerPath = Join-Path $absoluteTarget 'composer.json'
            $packageName = $null
            if (Test-Path $extensionComposerPath) {
                try {
                    $extensionComposer = Get-Content -Path $extensionComposerPath -Raw | ConvertFrom-Json
                    if ($extensionComposer.name) {
                        $packageName = [string]$extensionComposer.name
                    }
                } catch {
                    Write-Host "Warning: Unable to parse $Kind composer.json: $($_.Exception.Message)" -ForegroundColor Yellow
                }
            }

            if (-not $packageName) {
                $packageName = "drupal/$ProjectName"
            }

            try {
                ddev composer require "${packageName}:@dev" --no-progress | Out-Null
                Write-Host "Composer dependencies for '$packageName' are linked." -ForegroundColor Green
            } catch {
                Write-Host "Failed to install Composer dependencies for '$packageName': $($_.Exception.Message)" -ForegroundColor Yellow
            }
        }

        if (-not $SkipSiteInstall) {
            if ($Kind -eq 'module') {
                try {
                    ddev drush en $ProjectName -y | Out-Null
                    Write-Host "Module '$ProjectName' enabled." -ForegroundColor Green
                } catch {
                    Write-Host "Failed to enable module automatically: $($_.Exception.Message)" -ForegroundColor Yellow
                    Write-Host "Enable it manually with 'ddev drush en $ProjectName'." -ForegroundColor Yellow
                }
            } else {
                try {
                    ddev drush theme:enable $ProjectName -y | Out-Null
                    Write-Host "Theme '$ProjectName' enabled." -ForegroundColor Green
                } catch {
                    Write-Host "Failed to enable theme automatically: $($_.Exception.Message)" -ForegroundColor Yellow
                    Write-Host "Enable it manually with 'ddev drush theme:enable $ProjectName'." -ForegroundColor Yellow
                }
            }
        } else {
            Write-Host "Site install was skipped; enable the $Kind after completing installation." -ForegroundColor Yellow
        }

        Write-Host "Contribution sandbox ready at $ProjectPath" -ForegroundColor Green
        Show-ConnectionInfo -SkipLaunch:$SkipLaunch
    } finally {
        Pop-Location
    }
}

Ensure-Command -Name 'ddev'
Ensure-Command -Name 'git'

$projectPath = Join-Path (Get-Location) $ProjectName
if (Test-Path $projectPath) {
    throw "A directory named '$ProjectName' already exists in this location."
}

$originalLocation = Get-Location
try {
    switch ($SetupType) {
        'site' {
            if ([string]::IsNullOrEmpty($GitRepo)) {
                Setup-NewSite -ProjectPath $projectPath -SkipLaunch:$SkipLaunch -SkipSiteInstall:$SkipSiteInstall
            } else {
                Setup-ExistingProject -ProjectPath $projectPath -GitRepo $GitRepo -Docroot $Docroot -SkipLaunch:$SkipLaunch -SkipSiteInstall:$SkipSiteInstall
            }
        }
        'core' {
            if ([string]::IsNullOrEmpty($GitRepo)) {
                throw "SetupType 'core' requires -GitRepo to clone Drupal core."
            }
            $coreDocroot = if ([string]::IsNullOrEmpty($Docroot)) { '.' } else { $Docroot }
            Setup-ExistingProject -ProjectPath $projectPath -GitRepo $GitRepo -Docroot $coreDocroot -SkipLaunch:$SkipLaunch -SkipSiteInstall:$SkipSiteInstall
        }
        'module' {
            if ([string]::IsNullOrEmpty($GitRepo)) {
                throw "SetupType 'module' requires -GitRepo pointing to the module repository."
            }
            Setup-ContributionSandbox -Kind 'module' -ProjectPath $projectPath -GitRepo $GitRepo -SkipLaunch:$SkipLaunch -SkipSiteInstall:$SkipSiteInstall -LinkDependencies:$LinkExtensionDependencies
        }
        'theme' {
            if ([string]::IsNullOrEmpty($GitRepo)) {
                throw "SetupType 'theme' requires -GitRepo pointing to the theme repository."
            }
            Setup-ContributionSandbox -Kind 'theme' -ProjectPath $projectPath -GitRepo $GitRepo -SkipLaunch:$SkipLaunch -SkipSiteInstall:$SkipSiteInstall -LinkDependencies:$LinkExtensionDependencies
        }
    }

    Write-Host "Project '$ProjectName' is ready." -ForegroundColor Green

    if ($Global:DrupalAdminPassword) {
        Write-Host "Drupal Admin Username: admin" -ForegroundColor Yellow
        Write-Host "Drupal Admin Password: $Global:DrupalAdminPassword" -ForegroundColor Yellow
    }
} finally {
    Set-Location $originalLocation
}
