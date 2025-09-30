# Python Development Workflow Guide

This guide focuses specifically on using the PowerShell script collection to streamline your Python development workflow, from project creation to environment management.

## Prerequisites

1.  **Python Installed:** You must have Python installed on your system and accessible from your `PATH`. You can verify this by running `python --version` or `py --version` in your terminal.
2.  **Scripts Configured:** The PowerShell productivity scripts must be installed and configured as described in the `STUDY_GUIDE.md`.

---

## The Easy Way: Create a New Project with `mkproject_py`

The `mkproject_py` script is the fastest and most recommended way to start a new Python project. It automates all the initial setup steps in a single command.

### What it Does:

*   Creates a new project directory.
*   Sets up a dedicated Python virtual environment inside a `venv` folder.
*   Creates a standard `.gitignore` file tailored for Python projects.
*   Creates a `requirements.txt` file for managing dependencies.
*   Adds a `main.py` file with a simple "Hello World" template.
*   Adds a `README.md` file for your project's documentation.
*   Initializes a Git repository and makes the first commit.

### How to Use It

1.  Navigate to the directory where you want to create your project (e.g., `cd ~/Documents/projects`).
2.  Run the script:
    ```powershell
    mkproject_py
    ```
3.  The script will prompt you for your project's name. Enter it and press Enter.

**Example:**

```powershell
> mkproject_py
Enter your Python project name: my-new-api

Creating project directory: my-new-api
Setting up Python virtual environment in 'venv'...
...
✅ Project 'my-new-api' created successfully!

--- Next Steps ---
1. Navigate into your project: Set-Location my-new-api
2. Activate the virtual environment: .\venv\Scripts\Activate.ps1
3. Install packages: pip install <package_name>
4. Add packages to requirements.txt: pip freeze > requirements.txt
5. Start coding in main.py!
```

### Resulting Project Structure

The script will generate the following clean and organized structure:

```
my-new-api/
├── venv/              # Your isolated Python virtual environment
├── .git/              # Git repository folder
├── main.py            # Main application file
├── requirements.txt   # Python dependencies list
├── .gitignore         # Git ignore file for Python
└── README.md          # Your project's README
```

---

## Workflow 2: Setting Up a Python Project from GitHub

Often, you'll want to work on an existing project from a platform like GitHub. This workflow shows how to use your scripts to quickly set up a cloned repository.

### Step 1: Clone the Repository

First, use the standard `git clone` command to download the project to your local machine. You can get the URL from the project's GitHub page.

```powershell
# Example using a popular project
git clone https://github.com/pallets/flask.git
```

### Step 2: Navigate into the Project Directory

Change your location to the newly created project folder.

```powershell
cd flask
```

### Step 3: Create and Activate the Virtual Environment

The project code is now on your machine, but you need an isolated environment for its dependencies. This is where your `dev` script comes in handy.

1.  **Create the venv:**
    ```powershell
    dev env
    ```
    This command creates a `venv` folder right inside the project, which is standard practice and is usually included in the project's `.gitignore` file.

2.  **Activate the venv:**
    ```powershell
    .\venv\Scripts\Activate.ps1
    ```
    Your terminal prompt should now start with `(venv)`.

### Step 4: Install Dependencies

Most Python projects on GitHub include a `requirements.txt` file (or a variation like `requirements/dev.txt`). Use `pip` to install all the listed dependencies at once.

```powershell
pip install -r requirements.txt
```

### You're All Set!

The project is now ready. You have the source code, a dedicated environment, and all the necessary packages installed. You can now run the project's tests, start its development server, or begin contributing code.

---

## Configuring Visual Studio Code

To get the most out of your new Python project, you should configure your code editor to recognize and use the virtual environment (`venv`). This enables powerful features like IntelliSense (autocompletion), linting (error checking), and debugging to work correctly.

### 1. Prerequisites

*   **Visual Studio Code:** Must be installed.
*   **Python Extension for VS Code:** You must install the official Python extension from Microsoft. If you don't have it, open VS Code, go to the Extensions view (`Ctrl+Shift+X`), and search for `ms-python.python`.

### 2. The Goal: Automatic Environment Detection

VS Code is smart enough to automatically detect a virtual environment if it's in a folder named `.venv`. However, our scripts create it in a folder named `venv` (without the leading dot), which is also a common convention. 

We can create a simple workspace setting to ensure VS Code always finds the correct Python interpreter.

### 3. Configuration Steps

For any Python project you create or clone, follow these steps once:

1.  **Open the project in VS Code.** From your project's root directory in the terminal, run:
    ```powershell
    code .
    ```

2.  **Create a workspace settings file.** This file will contain settings that apply only to the current project.
    *   Create a new folder in your project's root directory named `.vscode`.
    *   Inside the `.vscode` folder, create a new file named `settings.json`.

3.  **Add the Python Path setting.** Copy and paste the following JSON content into your `.vscode/settings.json` file:

    ```json
    {
        "python.defaultInterpreterPath": "${workspaceFolder}/venv/Scripts/python.exe"
    }
    ```

    This setting explicitly tells VS Code to use the Python interpreter located inside your project's `venv` folder.

### 4. Verification

You'll know the configuration is working if you see these signs:

*   **Interpreter in Status Bar:** When you open a `.py` file, the bottom-right corner of the VS Code status bar should display the interpreter from your `venv` (e.g., `Python 3.9.5 ('venv': venv)`).
*   **Automatic Activation:** When you open a new integrated terminal in VS Code (`Ctrl+` `), the virtual environment should be activated automatically. You will see `(venv)` at the beginning of your terminal prompt.

With this setup, you have a streamlined and correctly configured environment for every Python project.

---

## Managing the Virtual Environment

A virtual environment (`venv`) is crucial for keeping your project's dependencies isolated from other projects.

### Activating the Environment

Before you install packages or run your code, you **must** activate the environment. From your project's root directory, run:

```powershell
.\venv\Scripts\Activate.ps1
```

Your terminal prompt will change to indicate that the virtual environment is active, usually by showing `(venv)` at the beginning of the line.

> **Note:** If you get an error, you may need to adjust your PowerShell execution policy. See the main `STUDY_GUIDE.md` for instructions.

### Deactivating the Environment

When you are finished working on your project, you can deactivate the environment by simply running:

```powershell
deactivate
```

### Adding an Environment to an Existing Project

If you have a project that doesn't have a virtual environment yet, you can easily add one.

1.  Navigate into your project's directory.
2.  Run the `dev` shortcut command:
    ```powershell
    dev env
    ```
    This will create the `venv` folder in your current directory.
3.  Activate it as usual: `.\venv\Scripts\Activate.ps1`.

---

## Managing Python Dependencies

Once your virtual environment is active, you can manage your project's dependencies.

*   **Install a package:**
    ```powershell
    pip install requests
    pip install flask
    ```

*   **Save dependencies to `requirements.txt`:**
    After installing new packages, you must save them to your `requirements.txt` file. This is critical for allowing others (or yourself, on a different machine) to replicate your setup.
    ```powershell
    pip freeze > requirements.txt
    ```

*   **Install dependencies from `requirements.txt`:**
    When you set up a project for the first time, you can install all of its dependencies in one go:
    ```powershell
    pip install -r requirements.txt
    ```

---

## Troubleshooting Common Issues

Even with a streamlined process, you can run into issues. Here are solutions to the most common problems.

#### Issue: `python`, `pip`, or `git` is not recognized as a command.

*   **Symptom:** You see an error like `'python' is not recognized as the name of a cmdlet, function, script file, or operable program.`
*   **Cause:** The program is either not installed, or its location is not in your system's `PATH` environment variable.
*   **Solution:**
    1.  Install the required program (e.g., from python.org or git-scm.com).
    2.  During installation, ensure you check the box that says **"Add Python to PATH"** or similar.
    3.  If it's already installed, you must add its installation folder to your system `PATH` manually.
    4.  **Important:** You must restart your terminal after installing a program or changing the `PATH` for the changes to take effect.

#### Issue: The `Activate.ps1` script won't run.

*   **Symptom:** You see a red error message containing `...cannot be loaded because running scripts is disabled on this system.`
*   **Cause:** Your PowerShell Execution Policy is too restrictive.
*   **Solution:** This is a one-time setup. Open a new PowerShell terminal **as an Administrator** and run the following command:
    ```powershell
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
    ```

#### Issue: `ModuleNotFoundError` when running your code.

*   **Symptom:** Your Python script fails with an error like `ModuleNotFoundError: No module named 'requests'`.
*   **Cause 1:** Your virtual environment is not active. You installed the package in your global Python environment, but your project is running in an isolated environment that doesn't have it.
*   **Solution 1:** Always activate your virtual environment before running your code. Run `.\venv\Scripts\Activate.ps1`.
*   **Cause 2:** The package is simply not installed in the active environment.
*   **Solution 2:** Make sure your venv is active (you see `(venv)` in your prompt), then run `pip install <package_name>`.

#### Issue: VS Code is not using the virtual environment.

*   **Symptom:** Code completion doesn't work, you see linting errors for installed modules, or the Python interpreter in the bottom status bar shows a global version (e.g., `3.9.1 C:\Python39\python.exe`) instead of your `venv`.
*   **Cause:** VS Code hasn't been told which interpreter to use for this specific workspace.
*   **Solution:**
    1.  Ensure the `.vscode/settings.json` file exists and has the correct path: `{"python.defaultInterpreterPath": "${workspaceFolder}/venv/Scripts/python.exe"}`.
    2.  Use the Command Palette (`Ctrl+Shift+P`) and run the **`Python: Select Interpreter`** command. A list will appear. Choose the one that has `('venv': venv)` in its description and points to your project's `venv` folder.
    3.  Reload the VS Code window (`Ctrl+Shift+P` -> **`Developer: Reload Window`**).

## Quick Reference

Don't forget to use the `cheatsheet` script for a quick reminder of these commands. The Python section contains:

```
=== PYTHON DEVELOPMENT ===
  python -m venv venv     # Create virtual environment
  .\venv\Scripts\Activate.ps1 # Activate environment
  pip install <package>   # Install package
  pip freeze > requirements.txt # Save dependencies
  deactivate              # Exit virtual environment
```
