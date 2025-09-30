# PowerShell Productivity Scripts: A Study Guide

## Introduction

Welcome! This collection of PowerShell scripts is designed to supercharge your command-line productivity. Think of them as a set of swiss-army knives that automate common, repetitive, and complex tasks, allowing you to focus on your work.

The scripts are designed to be **modular and self-contained**. Each one is independent, so you can easily understand, modify, or use them individually without affecting the others.

This guide will walk you through the setup, core concepts, and provide example workflows to help you integrate these powerful tools into your daily routine.

## Getting Started

### 1. Prerequisites

*   **Windows OS:** These scripts are built for the Windows environment.
*   **PowerShell:** A modern version of PowerShell is recommended.

### 2. Installation

1.  **Place the Scripts:**
    Ensure all the `.ps1` script files are located in a single directory. The recommended location is `C:\Users\<YourUsername>\scripts\my-powershells`.

2.  **Add to PATH:**
    To run these scripts from anywhere in your terminal, you must add their directory to your system's `PATH` environment variable.
    *   Search for "Edit the system environment variables" in the Start Menu.
    *   Click the "Environment Variables..." button.
    *   In the "User variables" section, select `Path` and click "Edit...".
    *   Click "New" and add the full path to your scripts directory (e.g., `C:\Users\ryanl\scripts\my-powershells`).
    *   Click OK on all windows to save the changes.
    *   **You will need to restart your PowerShell terminal for this change to take effect.**

3.  **Set Execution Policy:**
    PowerShell has a security feature that can prevent scripts from running. You need to set the execution policy to allow them. Open PowerShell **as an Administrator** and run the following command:
    ```powershell
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
    ```
    This command allows locally created scripts to run.

### 3. External Dependencies

Some scripts rely on popular, free command-line tools for heavy lifting. For full functionality, you should install them using a package manager like [Winget](https://docs.microsoft.com/en-us/windows/package-manager/winget/) or [Chocolatey](https://chocolatey.org/).

*   **`archive_manager` & `unpacker`:**
    *   **7-Zip:** For `.7z` and `.rar` files.
        *   `winget install -e --id 7zip.7zip`
*   **`media_converter`:**
    *   **FFmpeg:** For audio/video conversion.
        *   `winget install -e --id Gyan.FFmpeg`
    *   **ImageMagick:** For resizing images.
        *   `winget install -e --id ImageMagick.ImageMagick`
    *   **Ghostscript:** For compressing PDFs.
        *   `winget install -e --id ArtifexSoftware.Ghostscript`
*   **`my_progress` & `dev_shortcuts`:**
    *   **Git:** For version control tasks.
        *   `winget install -e --id Git.Git`

## How to Use the Scripts

The primary way to learn about the scripts is by using the built-in cheatsheet.

### Your Command Center: `cheatsheet`

Simply run `cheatsheet` in your terminal. This command displays a comprehensive list of all available scripts, their primary functions, and example usage. It's your go-to reference.

### Basic Syntax

Most scripts follow a simple and consistent syntax:

```powershell
<script-name> [action] [parameters...] 
```

*   `<script-name>`: The name of the script file (e.g., `todo`, `goto`).
*   `[action]`: The operation you want to perform (e.g., `add`, `list`, `done`). If you omit the action, most scripts will display help text.
*   `[parameters...]`: Any additional information the script needs, like text, a filename, or a number.

## Script Showcase (by Category)

Here is a high-level overview of the scripts, grouped by their purpose.

#### Core Productivity

*   **`todo`**: A simple command-line task manager.
*   **`journal`**: Add timestamped entries to a personal journal.
*   **`memo`**: Quickly jot down notes to a single file.
*   **`quick_note`**: A more advanced note-taker with search and tagging.
*   **`remind_me`**: Set a future reminder that will pop up a notification.
*   **`take_a_break`**: A simple timer to remind you to step away from the screen.

#### File & Directory Management

*   **`findbig`**: Find the largest files and folders in a directory.
*   **`duplicate_finder`**: Scan a directory to find and optionally delete duplicate files.
*   **`file_organizer`**: Sort files into folders based on type, date, or size.
*   **`tidy_downloads`**: A specialized script to clean up your Downloads folder.
*   **`open_file`**: Quickly search for and open a file by name.
*   **`goto`**: Bookmark your favorite directories and jump to them instantly.
*   **`recent_dirs`**: Shows a list of your most recently visited directories and lets you jump to them.
*   **`archive_manager` / `unpacker`**: Create, extract, and inspect archive files like `.zip`, `.7z`, and `.tar`.

#### Development Tools

*   **`mkproject_py`**: Creates a complete Python project structure with a virtual environment, `.gitignore`, and `main.py`.
*   **`start_project`**: Creates a generic project structure for any language.
*   **`dev_shortcuts`**: A collection of useful developer commands, like starting a local server or pretty-printing JSON.
*   **`my_progress`**: If you're in a Git repository, this shows your recent commit activity.

#### System & Network

*   **`system_info`**: Displays a comprehensive overview of your system hardware, software, and resource usage.
*   **`battery_check`**: Shows your current battery status and provides tips for low power.
*   **`network_info`**: A powerful tool to check your IP address, scan Wi-Fi, test speed, and even reset your network settings.
*   **`process_manager`**: Find, inspect, and kill running processes.

#### Utilities & Daily Routine

*   **`media_converter`**: Convert video to audio, resize images, and compress PDFs.
*   **`workspace_manager`**: Save and load your working directory to quickly switch between projects.
*   **`app_launcher`**: Create short aliases to launch your favorite applications.
*   **`clipboard_manager`**: Save and restore multiple clipboard entries.
*   **`text_processor`**: Perform operations on text files like counting words, searching, and replacing text.
*   **`weather`**: Get the current weather for any city.
*   **`done`**: Run a long-running command and get a desktop notification when it completes.
*   **`startday` / `goodevening` / `greeting`**: Scripts to help structure your day.
*   **`week_in_review`**: Aggregates your activity from your `todo` list, `journal`, and `git` commits for the past week.

## Example Workflows

### Morning Routine

1.  Open a new PowerShell terminal.
2.  Run `startday` to see your to-do list.
3.  Run `greeting` to get a "Good morning" message, the weather, and a task overview.
4.  Run `goto work` to immediately jump to your primary project directory.

### Cleaning Up Your PC

1.  Navigate to your Downloads folder: `cd ~/Downloads`.
2.  See what the script would do without moving files: `tidy_downloads -DryRun`.
3.  If you're happy with the plan, run it for real: `tidy_downloads`.
4.  Find large, forgotten files eating up space: `findbig`.
5.  Find and remove duplicate files: `duplicate_finder`.

### Starting a New Python Project

1.  Navigate to your projects folder: `goto projects`.
2.  Create a new, fully-structured Python project: `mkproject_py my-awesome-app`.
3.  Navigate into the new directory: `cd my-awesome-app`.
4.  Your Git repository is already initialized. Start coding!
5.  After making some changes, commit them easily: `dev gitquick "Initial feature implementation"`.

## Customization

Because the scripts are self-contained, you can easily modify them. For example, you can open `todo.ps1` and change the location of the `todo_list.txt` file if you wish.

Some scripts also look for environment variables for configuration (e.g., `TODO_FILE`, `MEMO_FILE`), which provides a way to customize them without changing the code.

---

Enjoy your new, more productive workflow!
