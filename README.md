# PowerShell Productivity Scripts Collection

A comprehensive collection of 42 PowerShell scripts designed to boost productivity and streamline daily development workflows. Originally ported from bash scripts, these tools are optimized for Windows PowerShell with native Windows features like toast notifications, Windows APIs, and proper error handling.

## 🚀 Quick Start

1. **Clone or download** this repository to `$env:USERPROFILE\scripts\my-powershells`
2. **Update your PowerShell profile** by copying the contents of `Microsoft.PowerShell_profile_reference.txt`
3. **Restart PowerShell** or run `. $PROFILE` to load the new aliases
4. **Start using** any of the 55+ aliases immediately!

## 📋 Complete Script Collection (42 Scripts)

### 🎯 **Core Productivity (16 scripts)**

#### **Task & Time Management**
- **`todo`** (`todo.ps1`) - Comprehensive task management system
  ```powershell
  todo add "Fix authentication bug"
  todo list                    # Show all tasks
  todo done 2                  # Mark task 2 as complete
  todo clear                   # Clear all tasks
  ```

- **`journal`** (`journal.ps1`) - Quick journaling with timestamps
  ```powershell
  journal "Started working on the new feature"
  journal                      # Show last 5 entries
  ```

- **`memo`** (`memo.ps1`) - Quick note-taking with search
  ```powershell
  memo add "Remember to update documentation"
  memo list                    # Show all memos
  memo today                   # Show today's memos
  memo clear                   # Clear all memos
  ```

- **`note`** (`quick_note.ps1`) - Advanced note system with search
  ```powershell
  note add "Meeting notes from standup"
  note search "meeting"        # Search through notes
  note recent 5               # Show 5 most recent notes
  note today                  # Show today's notes
  ```

- **`remind`** (`remind_me.ps1`) - Timer-based reminders with notifications
  ```powershell
  remind "+30m" "Take a break"
  remind "+2h" "Call the dentist"
  ```

- **`takebreak`** (`take_a_break.ps1`) - Health break timer
  ```powershell
  takebreak 15                    # 15-minute break (default)
  takebreak 5                     # 5-minute break
  ```

#### **Information & Utilities**
- **`weather`** (`weather.ps1`) - Weather information
  ```powershell
  weather                     # Weather for default city
  weather "New York"          # Weather for specific city
  ```

- **`cheatsheet`** (`cheatsheet.ps1`) - Command reference
  ```powershell
  cheatsheet                  # Show PowerShell/Windows commands
  ```

- **`findtext`** (`findtext.ps1`) - Search text in files
  ```powershell
  findtext "function"         # Search in current directory
  findtext "TODO" C:\projects # Search in specific directory
  ```

#### **File & System Management**
- **`findbig`** (`findbig.ps1`) - Find largest files and directories
  ```powershell
  findbig                     # Scan current directory
  findbig C:\Users           # Scan specific path
  ```

- **`organize`** (`file_organizer.ps1`) - Organize files by type/date/size
  ```powershell
  organize bytype            # Organize by file type
  organize bydate            # Organize by date
  organize bysize            # Organize by file size
  ```

- **`unpack`** (`unpacker.ps1`) - Extract various archive formats
  ```powershell
  unpack archive.zip
  unpack document.tar.gz
  unpack software.7z
  ```

- **`backup`** (`backup_project.ps1`) - Project backup with robocopy
  ```powershell
  backup                     # Backup current directory
  backup C:\MyProject       # Backup specific directory
  ```

#### **Daily Routine Scripts**
- **`startday`** (`startday.ps1`) - Morning startup routine
- **`goodevening`** (`goodevening.ps1`) - Evening wrap-up
- **`greeting`** (`greeting.ps1`) - Context-aware greeting

### 🖥️ **System & Network (5 scripts)**

- **`sysinfo`** (`system_info.ps1`) - Comprehensive system information
  ```powershell
  sysinfo                    # Hardware, CPU, memory, disk, network info
  ```

- **`netinfo`** (`network_info.ps1`) - Network diagnostics and troubleshooting
  ```powershell
  netinfo status             # Current network status
  netinfo scan               # Scan Wi-Fi networks
  netinfo speed              # Test network speed
  netinfo fix                # Reset network settings
  netinfo ping               # Test connectivity
  ```

- **`duplicates`** (`duplicate_finder.ps1`) - Find and manage duplicate files
  ```powershell
  duplicates                 # Find duplicates in current directory
  duplicates C:\Photos       # Find duplicates in specific folder
  duplicates -DeleteDuplicates # Find and delete duplicates
  duplicates -MinSize 1MB    # Only check files larger than 1MB
  ```

- **`processes`** (`process_manager.ps1`) - Process and service management
  ```powershell
  processes find chrome      # Find processes by name
  processes top              # Top CPU-using processes
  processes memory           # Top memory-using processes
  processes kill notepad     # Safely kill processes
  processes services         # Show running services
  processes threads chrome   # Show thread info
  ```

- **`battery`** (`battery_check.ps1`) - Battery status and optimization tips
  ```powershell
  battery                    # Show battery status and tips
  ```

### 📁 **File & Navigation (4 scripts)**

- **`tidydown`** (`tidy_downloads.ps1`) - Organize and clean downloads folder
  ```powershell
  tidydown                   # Organize downloads folder
  tidydown -DryRun          # Preview what would be moved
  tidydown -DownloadsPath "C:\MyDownloads" # Custom downloads path
  ```

- **`openfile`** (`open_file.ps1`) - Find and open files with fuzzy matching
  ```powershell
  openfile budget           # Find files containing "budget"
  openfile report           # Find files containing "report"
  ```

- **`goto`** (`goto.ps1`) - Directory bookmarking system
  ```powershell
  goto save projects        # Save current directory as "projects"
  goto projects            # Jump to saved bookmark
  goto list                # List all bookmarks
  goto remove projects     # Remove bookmark
  ```

- **`recentdirs`** (`recent_dirs.ps1`) - Navigate to recently visited directories
  ```powershell
  recentdirs               # Show recent directories and jump to one
  recentdirs add           # Add current directory to history
  ```

### 💻 **Development Tools (12 scripts)**

#### **General Development**
- **`dev`** (`dev_shortcuts.ps1`) - Development workflow shortcuts
  ```powershell
  dev server               # Start development server (port 8000)
  dev server 3000         # Start server on specific port
  dev json                # Pretty print JSON from clipboard
  dev json data.json      # Pretty print JSON from file
  dev env                 # Create Python virtual environment
  dev gitquick "Fix bug"  # Quick git add, commit, push
  dev npm install         # Run npm commands
  dev code                # Open VS Code in current directory
  ```

- **`newproject`** (`start_project.ps1`) - Create new project structure
  ```powershell
  newproject              # Interactive project creation
  ```

- **`newpy`** (`mkproject_py.ps1`) - Create Python projects with virtual environments
  ```powershell
  newpy                   # Interactive Python project setup
  ```

- **`progress`** (`my_progress.ps1`) - Git commit history and stats
  ```powershell
  progress                # Show recent commits and weekly stats
  ```

- **`textproc`** (`text_processor.ps1`) - Text file processing utilities
  ```powershell
  textproc count file.txt              # Count lines, words, characters
  textproc search "pattern" file.txt   # Search for text
  textproc replace "old" "new" file.txt # Replace text (creates backup)
  textproc clean file.txt             # Remove extra whitespace
  textproc lines file.txt 10 20       # Show lines 10-20
  ```

- **`archive`** (`archive_manager.ps1`) - Archive management utilities
  ```powershell
  archive create backup.zip folder1 folder2  # Create archive
  archive extract backup.zip                 # Extract archive
  archive list backup.zip                    # List archive contents
  archive info backup.zip                    # Show archive information
  ```

- **`media`** (`media_converter.ps1`) - Media file conversion utilities
  ```powershell
  media video2audio video.mp4        # Extract audio from video
  media resize_image photo.jpg 800   # Resize image to 800px width
  media pdf_compress document.pdf    # Compress PDF file
  media video_compress video.mp4     # Compress video file
  ```

#### **Drupal Development**
This suite of scripts automates the setup of various Drupal development environments using DDEV. The core logic resides in `new-drupal-project.ps1`, with convenient wrappers for common tasks.

- **`new-drupal`** (`new-drupal-project.ps1`) - The main script for creating new Drupal projects. It supports multiple workflows via parameters.
  ```powershell
  # Create a brand-new standard Drupal site
  new-drupal -ProjectName my-new-site

  # Create a contribution sandbox for the Token module with dependency linking
  new-drupal -ProjectName token -GitRepo https://git.drupalcode.org/project/token.git -SetupType module -LinkExtensionDependencies
  
  # Clone and bootstrap an existing Drupal site from a private repository
  new-drupal -ProjectName my-existing-site -GitRepo git@github.com:user/my-site.git -SkipSiteInstall
  ```

- **`new-drupal-core`** (`drupal-core-dev.ps1`) - A wrapper to quickly set up a sandbox for contributing to Drupal Core.
  ```powershell
  new-drupal-core
  ```

- **`new-drupal-module`** (`drupal-module-dev.ps1`) - A wrapper for setting up a contribution environment for a specific module.
  ```powershell
  new-drupal-module token
  ```

- **`new-drupal-theme`** (`drupal-theme-dev.ps1`) - A wrapper for setting up a contribution environment for a specific theme.
  ```powershell
  new-drupal-theme bootstrap5
  ```

- **`new-drupal-headless`** (`new-headless-drupal.ps1`) - A wrapper that sets up a standard Drupal site and provides instructions for using it as a headless backend.
  ```powershell
  new-drupal-headless my-headless-backend
  ```

**Key Features & Parameters:**
- **`-SetupType`**: Controls the workflow. Can be `site` (default), `core`, `module`, or `theme`.
- **`-GitRepo`**: The Git URL to clone for an existing project or for a contribution sandbox.
- **`-LinkExtensionDependencies`**: For `module` and `theme` setups, this automatically links the extension's `composer.json` and installs its PHP dependencies.
- **`-SkipSiteInstall`**: Skips the `ddev drush site:install` step, which is useful when you plan to import an existing database.
- **`-Docroot`**: Manually specify the docroot if the script cannot detect it automatically.
- **Auto-Discovery**: Automatically detects the docroot (`web`, `docroot`, etc.) in most cloned projects.

### 🔧 **Workspace & Utilities (5 scripts)**

- **`app`** (`app_launcher.ps1`) - Application launcher with favorites
  ```powershell
  app add code "Visual Studio Code"   # Add favorite app
  app add chrome "C:\Program Files\Google\Chrome\Application\chrome.exe"
  app list                           # List favorite apps
  app code                           # Launch favorite app
  app remove code                    # Remove favorite app
  ```

- **`clip`** (`clipboard_manager.ps1`) - Enhanced clipboard management
  ```powershell
  clip save               # Save current clipboard
  clip save notes         # Save clipboard with specific name
  clip load notes         # Load saved clip to clipboard
  clip list               # Show all saved clips
  clip peek               # Show current clipboard content
  clip clear              # Clear saved clips
  ```

- **`workspace`** (`workspace_manager.ps1`) - Manage different work contexts
  ```powershell
  workspace save project1    # Save current workspace
  workspace load project1    # Load workspace (directory + context)
  workspace list            # List all workspaces
  workspace remove project1 # Remove workspace
  workspace show project1   # Show workspace details
  ```

- **`done`** (`done.ps1`) - Run commands with completion notifications
  ```powershell
  done ping google.com      # Run command with notification when done
  done robocopy src dest    # Long-running command with notification
  ```

- **`weekreview`** (`week_in_review.ps1`) - Weekly activity summary
  ```powershell
  weekreview                # Show completed tasks, journal entries, git commits
  ```

## 🛠️ Installation & Setup

### Prerequisites
- **Windows PowerShell 5.1+** or **PowerShell 7+**
- **Git** (for some development scripts)
- **Optional tools** for enhanced functionality:
  - **DDEV** (for Drupal development): `winget install DDEV.DDEV`
  - **FFmpeg** (for media conversion): `winget install ffmpeg`
  - **ImageMagick** (for image processing): `winget install ImageMagick.ImageMagick`
  - **7-Zip** (for archive management): `winget install 7zip.7zip`
  - **Ghostscript** (for PDF compression): `winget install ArtifexSoftware.GhostScript`

### Step-by-Step Installation

1. **Clone or Download Repository**
   ```powershell
   # Option 1: Clone with Git
   git clone <repository-url> "$env:USERPROFILE\scripts\my-powershells"

   # Option 2: Download and extract ZIP to:
   # C:\Users\YourName\scripts\my-powershells
   ```

2. **Set Execution Policy** (if needed)
   ```powershell
   Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
   ```

3. **Update PowerShell Profile**
   ```powershell
   # Backup existing profile
   Copy-Item $PROFILE "$PROFILE.backup-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

   # Copy contents from Microsoft.PowerShell_profile_reference.txt to your $PROFILE
   # Or append the new aliases section to your existing profile
   ```

4. **Reload Profile**
   ```powershell
   . $PROFILE
   ```

5. **Test Installation**
   ```powershell
   todo list        # Should work without errors
   weather          # Should show weather information
   sysinfo          # Should display system information
   ```

## 🎨 Customization

### Changing Default Cities
Edit `weather.ps1` to change the default city:
```powershell
param(
    [Parameter(Position=0)]
    [string]$City = "YourCity"  # Change this
)
```

### Custom File Paths
Many scripts support environment variables for customization:
- `$env:TODO_FILE` - Custom todo file location
- `$env:MEMO_FILE` - Custom memo file location
- Scripts create files in `$env:USERPROFILE` by default

### Adding New Aliases
Add custom aliases to your PowerShell profile:
```powershell
Set-Alias -Name myalias "$PSScriptRoot\script_name.ps1"
```

## 🚨 Troubleshooting

### Common Issues

**1. Scripts not found**
- Ensure the scripts directory is in your PATH
- Check that `$PSScriptRoot` is set correctly in your profile

**2. Execution policy errors**
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

**3. Missing dependencies**
- Install optional tools as needed
- Scripts will show helpful error messages with installation commands

**4. Toast notifications not working**
- Windows 10/11 required for toast notifications
- Scripts fall back to message boxes or console output

**5. Git commands not working**
- Ensure Git is installed and in PATH
- Some scripts gracefully handle missing Git

### Getting Help
Each script includes built-in help:
```powershell
scriptname          # Shows usage information
scriptname --help   # For scripts that support it
```

## 📊 Script Statistics

- **Total Scripts**: 42
- **Total Aliases**: 55+
- **Lines of Code**: 3,000+
- **Features**: Toast notifications, error handling, progress indicators, file backups, cross-platform compatibility considerations

## 🔄 Updates and Maintenance

### Updating Scripts
```powershell
# If using Git
cd "$env:USERPROFILE\scripts\my-powershells"
git pull
```

### Backup Important Data
Scripts automatically create backups for:
- Configuration files (.backup extension)
- Text processing operations
- Profile updates

### Logs and History
Scripts maintain history in:
- `~/.todo_done.txt` - Completed tasks
- `~/journal.txt` - Journal entries
- `~/health_breaks.log` - Break tracking
- Various other log files in user profile

## 🤝 Contributing

Feel free to:
- Add new scripts following the existing patterns
- Improve error handling and user experience
- Add more Windows-specific features
- Submit issues and feature requests

## 📜 License

This collection is provided as-is for productivity enhancement. Individual scripts may have different requirements based on external dependencies.

## 🙏 Acknowledgments

Originally inspired by bash productivity scripts, enhanced for Windows PowerShell with:
- Native Windows API integration
- Toast notification support
- Robust error handling
- Windows-specific file operations
- PowerShell best practices

---

**Happy scripting! 🚀**

*For questions or issues, refer to the troubleshooting section or check individual script help output.*