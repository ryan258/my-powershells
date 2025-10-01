# A Foolproof Guide to Drupal 11 Development with DDEV

## Introduction

This guide is dedicated to creating a stable, repeatable, and stress-free development workflow for Drupal 11. The goal is to remove any uncertainty about your local environment so you can focus your valuable time on building projects and contributing to the Drupal community, including its vital accessibility efforts.

We will use **DDEV**, a professional, open-source tool that abstracts away the complexities of Docker. It is widely used and highly regarded within the Drupal community, making it a perfect choice for a standardized setup.

---

## The Easiest Way: Intention-Driven Setup

With the new automation scripts, setting up any type of Drupal project is now a single command. These commands match your specific intention, whether you are starting a new project or contributing to an existing one.

**Note:** Since DDEV runs in WSL, run these commands from your WSL terminal (type `wsl` to enter).

**Important:** Projects are created in your current directory. Navigate to where you want your Drupal projects before running these commands (e.g., `cd ~/projects` or `cd /mnt/c/Users/ryanl/projects`).

### To Start a New Drupal Site
```bash
# Navigate to your projects directory
cd ~/projects

# Run the script
pwsh /mnt/c/Users/ryanl/scripts/my-powershells/new-drupal-project.ps1 -ProjectName my-new-site
```

### To Start a Headless Project
```bash
cd ~/projects
pwsh /mnt/c/Users/ryanl/scripts/my-powershells/new-headless-drupal.ps1 -ProjectName my-api-backend
```

### To Contribute to Drupal Core
```bash
cd ~/projects
pwsh /mnt/c/Users/ryanl/scripts/my-powershells/drupal-core-dev.ps1
```

### To Contribute to a Module or Theme
```bash
cd ~/projects

# To set up a module (e.g., the Token module)
pwsh /mnt/c/Users/ryanl/scripts/my-powershells/drupal-module-dev.ps1 -ModuleName token

# To set up a theme (e.g., the Bootstrap5 theme)
pwsh /mnt/c/Users/ryanl/scripts/my-powershells/drupal-theme-dev.ps1 -ThemeName bootstrap5
```

---

## Part 1: One-Time Setup (Prerequisites)

Before you start your first project, you need to set up a few tools on your computer. You only have to do this once.

### 1. Install WSL2 (Windows Subsystem for Linux)
WSL2 is the foundation of the modern DDEV workflow on Windows.
Open PowerShell **as an administrator** and run:
```powershell
wsl --install
```
This will install WSL and a default Ubuntu distribution. **Restart your computer** after this step is complete.

### 2. Install DDEV (inside WSL)
Once WSL is ready, you need to install DDEV inside your new Linux environment.
Open your Ubuntu terminal (type `wsl` in your Start Menu) and run:
```bash
curl -fsSL https://raw.githubusercontent.com/ddev/ddev/master/scripts/install_ddev.sh | bash
```

### 3. Install PowerShell for WSL (`pwsh`)
The aliases in your Windows PowerShell profile need `pwsh` to be available inside WSL to work correctly.
Open your Ubuntu terminal and run:
```bash
sudo snap install powershell --classic
```

### 4. (Optional) Install Git and a Code Editor
It is highly recommended to have Git and a code editor like Visual Studio Code installed on your main Windows machine.
```powershell
winget install -e --id Git.Git
winget install -e --id Microsoft.VisualStudioCode
```

---

## Part 2: The Automated Scripts (How They Work)

This section briefly explains the manual steps that the intention-driven aliases automate for you. You don't need to run these commands if you use the aliases, but it is useful to understand the process.

### Workflow for a **New** Drupal Project

This workflow is used by the `new-drupal` and `new-drupal-headless` aliases.

1.  **Create Project Folder**: A directory for the project is created.
2.  **Configure DDEV**: `ddev config` is run to prepare the environment.
3.  **Start DDEV**: The environment is started (this may take a minute on first run).
4.  **Install Drupal Scaffold**: `ddev composer create` downloads the recommended Drupal project structure.
5.  **Install Drush**: `ddev composer require drush/drush` installs the Drush command-line tool.
6.  **Install Developer Tools**: `ddev composer require` installs Devel, Admin Toolbar, and Coder modules for development.
7.  **Install Site**: `ddev drush site:install` creates the database and runs the Drupal installer with admin/admin credentials.
8.  **Launch Site**: The new site is opened in the browser.

### Workflow for **Contributing** to Drupal

This workflow is used by the `new-drupal-core`, `new-drupal-module`, and `new-drupal-theme` aliases. It creates a complete, runnable Drupal "sandbox" site and places the extension you want to work on inside it.

1.  **Create Sandbox Project**: A new Drupal site is created first (similar to the workflow above).
2.  **Clone Extension**: The specific module, theme, or core repository is cloned from Drupal.org into the correct subdirectory (`web/modules/custom`, `web/themes/custom`, etc.).
3.  **Link Dependencies (Optional)**: The script can automatically update the sandbox's `composer.json` to recognize the cloned extension and install its dependencies.
4.  **Enable Extension**: The script attempts to enable the module or theme (`drush en`, `drush theme:enable`) so it's ready for testing immediately.

---

## Part 3: The Daily DDEV Workflow

Once a project is set up, you only need a few commands for your daily work.

*   **Start your project:** (from the project folder)
    `ddev start`

*   **Stop your project:** (frees up system resources)
    `ddev stop`

*   **Open your site in a browser:**
    `ddev launch`

*   **Run any Drush command:** (e.g., clear the cache)
    `ddev drush cr`

*   **Connect directly to the database:**
    `ddev mysql`

*   **View project details:** (URLs, credentials, etc.)
    `ddev describe`

*   **Completely delete a project:** (removes containers and database)
    `ddev delete -O`

## A Final Word of Encouragement

This workflow is reliable, community-tested, and should give you the confidence that your environment is set up correctly. The Drupal community is always in need of passionate contributors, and your goal to improve accessibility is incredibly important and valuable.

Now you can focus on the code, not the setup. Happy building!