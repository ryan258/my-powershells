Write-Host "===============================================" -ForegroundColor Cyan
Write-Host "    POWERSHELL PRODUCTIVITY CHEATSHEET" -ForegroundColor Cyan
Write-Host "         37 Scripts * 55+ Aliases" -ForegroundColor Gray
Write-Host "===============================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "=== CORE PRODUCTIVITY ===" -ForegroundColor Green
Write-Host "Task Management:" -ForegroundColor Yellow
Write-Host "  todo add 'task'         # Add new task" -ForegroundColor White
Write-Host "  todo list               # Show all tasks" -ForegroundColor White
Write-Host "  todo done 2             # Complete task #2" -ForegroundColor White
Write-Host "  todo clear              # Clear all tasks" -ForegroundColor White
Write-Host ""
Write-Host "Note Taking:" -ForegroundColor Yellow
Write-Host "  journal 'entry'         # Add journal entry" -ForegroundColor White
Write-Host "  journal                 # Show recent entries" -ForegroundColor White
Write-Host "  memo add 'quick note'   # Add memo" -ForegroundColor White
Write-Host "  note add 'detailed note'# Advanced notes with search" -ForegroundColor White
Write-Host ""
Write-Host "Time Management:" -ForegroundColor Yellow
Write-Host "  remind '+30m' 'message' # Set reminder in 30 minutes" -ForegroundColor White
Write-Host "  takebreak 15            # Take 15-minute health break" -ForegroundColor White
Write-Host ""

Write-Host "=== SYSTEM & NETWORK ===" -ForegroundColor Green
Write-Host "System Information:" -ForegroundColor Yellow
Write-Host "  sysinfo                 # Complete system information" -ForegroundColor White
Write-Host "  battery                 # Battery status and tips" -ForegroundColor White
Write-Host ""
Write-Host "Network Diagnostics:" -ForegroundColor Yellow
Write-Host "  netinfo status          # Network status" -ForegroundColor White
Write-Host "  netinfo scan            # Scan Wi-Fi networks" -ForegroundColor White
Write-Host "  netinfo speed           # Test network speed" -ForegroundColor White
Write-Host "  netinfo fix             # Reset network settings" -ForegroundColor White
Write-Host ""
Write-Host "Process Management:" -ForegroundColor Yellow
Write-Host "  processes find chrome   # Find processes by name" -ForegroundColor White
Write-Host "  processes top           # Top CPU processes" -ForegroundColor White
Write-Host "  processes memory        # Top memory processes" -ForegroundColor White
Write-Host "  processes kill notepad  # Kill processes safely" -ForegroundColor White
Write-Host ""

Write-Host "=== FILE & DIRECTORY MANAGEMENT ===" -ForegroundColor Green
Write-Host "File Operations:" -ForegroundColor Yellow
Write-Host "  findbig                 # Find largest files/folders" -ForegroundColor White
Write-Host "  duplicates              # Find duplicate files" -ForegroundColor White
Write-Host "  organize bytype         # Organize files by type" -ForegroundColor White
Write-Host "  tidydown                # Clean downloads folder" -ForegroundColor White
Write-Host "  openfile 'name'         # Find and open files" -ForegroundColor White
Write-Host ""
Write-Host "Navigation:" -ForegroundColor Yellow
Write-Host "  goto save work          # Bookmark current directory" -ForegroundColor White
Write-Host "  goto work               # Jump to bookmark" -ForegroundColor White
Write-Host "  recentdirs              # Show recent directories" -ForegroundColor White
Write-Host ""
Write-Host "Archives:" -ForegroundColor Yellow
Write-Host "  unpack archive.zip      # Extract any archive" -ForegroundColor White
Write-Host "  archive create data.zip folder1 folder2 # Create archive" -ForegroundColor White
Write-Host "  archive list data.zip   # List archive contents" -ForegroundColor White
Write-Host ""

Write-Host "=== DEVELOPMENT TOOLS ===" -ForegroundColor Green
Write-Host "Project Creation:" -ForegroundColor Yellow
Write-Host "  newproject              # Create new project structure" -ForegroundColor White
Write-Host "  newpy                   # Create Python project with venv" -ForegroundColor White
Write-Host ""
Write-Host "Drupal Development:" -ForegroundColor Yellow
Write-Host "  new-drupal -ProjectName <name> # Create a new Drupal site" -ForegroundColor White
Write-Host "  new-drupal-core                # Set up Drupal core for contributing" -ForegroundColor White
Write-Host "  new-drupal-module <name>         # Set up a contrib module" -ForegroundColor White
Write-Host "  new-drupal-theme <name>          # Set up a contrib theme" -ForegroundColor White
Write-Host "  new-drupal-headless <name>     # Create a new headless Drupal site" -ForegroundColor White
Write-Host ""
Write-Host "Development Shortcuts:" -ForegroundColor Yellow
Write-Host "  dev server 3000         # Start dev server on port 3000" -ForegroundColor White
Write-Host "  dev json                # Pretty print JSON from clipboard" -ForegroundColor White
Write-Host "  dev env                 # Create Python virtual environment" -ForegroundColor White
Write-Host "  dev gitquick 'message'  # Quick git add, commit, push" -ForegroundColor White
Write-Host "  dev code                # Open VS Code" -ForegroundColor White
Write-Host ""
Write-Host "Git & Progress:" -ForegroundColor Yellow
Write-Host "  progress                # Show recent commits and stats" -ForegroundColor White
Write-Host "  gs                      # git status" -ForegroundColor White
Write-Host "  ga .                    # git add ." -ForegroundColor White
Write-Host "  gc 'message'            # git commit -m" -ForegroundColor White
Write-Host "  gp                      # git push" -ForegroundColor White
Write-Host ""
Write-Host "Text Processing:" -ForegroundColor Yellow
Write-Host "  textproc count file.txt # Count lines/words/chars" -ForegroundColor White
Write-Host "  textproc search 'text' file.txt # Search in file" -ForegroundColor White
Write-Host "  textproc replace 'old' 'new' file.txt # Replace text" -ForegroundColor White
Write-Host ""

Write-Host "=== MEDIA & UTILITIES ===" -ForegroundColor Green
Write-Host "Media Conversion:" -ForegroundColor Yellow
Write-Host "  media video2audio video.mp4    # Extract audio from video" -ForegroundColor White
Write-Host "  media resize_image photo.jpg 800 # Resize image" -ForegroundColor White
Write-Host "  media pdf_compress doc.pdf     # Compress PDF" -ForegroundColor White
Write-Host ""
Write-Host "Workspace Management:" -ForegroundColor Yellow
Write-Host "  workspace save project1 # Save current workspace" -ForegroundColor White
Write-Host "  workspace load project1 # Load workspace" -ForegroundColor White
Write-Host "  workspace list          # List all workspaces" -ForegroundColor White
Write-Host ""
Write-Host "Application Launcher:" -ForegroundColor Yellow
Write-Host "  app add code 'VS Code'  # Add favorite application" -ForegroundColor White
Write-Host "  app code                # Launch favorite app" -ForegroundColor White
Write-Host "  app list                # List favorite apps" -ForegroundColor White
Write-Host ""
Write-Host "Clipboard Manager:" -ForegroundColor Yellow
Write-Host "  clip save               # Save current clipboard" -ForegroundColor White
Write-Host "  clip load notes         # Load saved clip" -ForegroundColor White
Write-Host "  clip list               # Show all saved clips" -ForegroundColor White
Write-Host ""

Write-Host "=== DAILY ROUTINE ===" -ForegroundColor Green
Write-Host "  startday                # Morning startup routine" -ForegroundColor White
Write-Host "  goodevening             # Evening wrap-up" -ForegroundColor White
Write-Host "  greeting                # Context-aware greeting" -ForegroundColor White
Write-Host "  weekreview              # Weekly activity summary" -ForegroundColor White
Write-Host "  weather                 # Current weather" -ForegroundColor White
Write-Host "  done ping google.com    # Run command with notification" -ForegroundColor White
Write-Host ""

Write-Host "=== BUILT-IN POWERSHELL COMMANDS ===" -ForegroundColor Green
Write-Host "File Operations:" -ForegroundColor Yellow
Write-Host "  Get-ChildItem / ls / ll # List files" -ForegroundColor White
Write-Host "  Set-Location / cd       # Change directory" -ForegroundColor White
Write-Host "  Copy-Item / cp          # Copy files" -ForegroundColor White
Write-Host "  Move-Item / mv          # Move files" -ForegroundColor White
Write-Host "  Remove-Item / rm        # Delete files" -ForegroundColor White
Write-Host ""
Write-Host "System Information:" -ForegroundColor Yellow
Write-Host "  Get-Process             # List running processes" -ForegroundColor White
Write-Host "  Get-Service             # List Windows services" -ForegroundColor White
Write-Host "  Get-EventLog System -Newest 10 # Recent system events" -ForegroundColor White
Write-Host ""
Write-Host "Network Commands:" -ForegroundColor Yellow
Write-Host "  Test-NetConnection host -Port 80 # Test connectivity" -ForegroundColor White
Write-Host "  ipconfig /all           # Network configuration" -ForegroundColor White
Write-Host "  ipconfig /flushdns      # Clear DNS cache" -ForegroundColor White
Write-Host "  netstat -an             # Network connections" -ForegroundColor White
Write-Host ""

Write-Host "=== PACKAGE MANAGEMENT ===" -ForegroundColor Green
Write-Host "Windows Package Manager:" -ForegroundColor Yellow
Write-Host "  winget search <package> # Search for packages" -ForegroundColor White
Write-Host "  winget install <package># Install package" -ForegroundColor White
Write-Host "  winget upgrade --all    # Update all packages" -ForegroundColor White
Write-Host ""
Write-Host "Chocolatey (if installed):" -ForegroundColor Yellow
Write-Host "  choco search <package>  # Search packages" -ForegroundColor White
Write-Host "  choco install <package> # Install package" -ForegroundColor White
Write-Host "  choco upgrade all       # Update all packages" -ForegroundColor White
Write-Host ""

Write-Host "=== PYTHON DEVELOPMENT ===" -ForegroundColor Green
Write-Host "  python -m venv venv     # Create virtual environment" -ForegroundColor White
Write-Host "  .\venv\Scripts\Activate.ps1 # Activate environment" -ForegroundColor White
Write-Host "  pip install <package>   # Install package" -ForegroundColor White
Write-Host "  pip freeze > requirements.txt # Save dependencies" -ForegroundColor White
Write-Host "  deactivate              # Exit virtual environment" -ForegroundColor White
Write-Host ""

Write-Host "=== USEFUL SHORTCUTS ===" -ForegroundColor Green
Write-Host "Navigation Aliases:" -ForegroundColor Yellow
Write-Host "  ..                      # cd .." -ForegroundColor White
Write-Host "  ...                     # cd ../.." -ForegroundColor White
Write-Host "  home                    # cd $env:USERPROFILE" -ForegroundColor White
Write-Host "  downloads               # cd Downloads" -ForegroundColor White
Write-Host "  documents               # cd Documents" -ForegroundColor White
Write-Host "  desktop                 # cd Desktop" -ForegroundColor White
Write-Host ""
Write-Host "Quick Commands:" -ForegroundColor Yellow
Write-Host "  c / cls                 # Clear screen" -ForegroundColor White
Write-Host "  now                     # Current date/time" -ForegroundColor White
Write-Host "  timestamp               # Filename-friendly timestamp" -ForegroundColor White
Write-Host "  myip                    # External IP address" -ForegroundColor White
Write-Host "  localip                 # Local IP addresses" -ForegroundColor White
Write-Host ""
Write-Host "File Info:" -ForegroundColor Yellow
Write-Host "  newest                  # 10 newest files" -ForegroundColor White
Write-Host "  biggest                 # 10 largest files" -ForegroundColor White
Write-Host "  fcount                  # Count files in directory" -ForegroundColor White
Write-Host ""

Write-Host "===============================================" -ForegroundColor Cyan
Write-Host "TIP: Run 'cheatsheet' anytime for this reference!" -ForegroundColor Yellow
Write-Host "NOTE: For detailed help: See README.md in scripts folder" -ForegroundColor Gray
Write-Host "===============================================" -ForegroundColor Cyan