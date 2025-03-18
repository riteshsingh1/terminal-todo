# Terminal Todo Tracker (ttt)

A simple terminal-based todo application with zero external dependencies, featuring a clean, colorful interface.

## Features

- Organize tasks by due date
- Single-key shortcuts for task management
- Mark tasks as done, not required, or postpone
- Completed tasks shown with strikethrough inline with active tasks
- Colorful, intuitive interface
- Task numbering for easy selection
- Visual separation with italicized action menus

## Screenshots

```
==== Terminal Todo Tracker ====

TASKS:

Due: 25/05/23
----------------------------------------
 [1] Complete project proposal
 [2] Send meeting agenda
 [3] Update documentation (done)

Due: 30/05/23
----------------------------------------
 [4] Review team performance
 [5] Submit quarterly report

----------------------------------------
Actions: Select task number, then choose:
 d-Done  p-Postpone  n-Not Required  a-Add New  q-Quit
----------------------------------------

Status: 4 active, 1 completed
```
*Note: Action menus appear in italics in the actual application, and completed tasks appear with strikethrough formatting*

## Installation

### For Unix-like Systems (Linux, macOS)

#### Method 1: Using the Installer (Recommended)

```bash
# Clone this repository or download the files
git clone https://github.com/riteshsingh1/terminal-todo.git
cd terminal-todo

# Run the installation script
./install.sh
```

The installer will guide you through the process and give you two options:
1. Install for the current user only (in `~/.local/bin`)
2. Install system-wide (in `/usr/local/bin`, requires sudo)

After installation, you can run `ttt` from anywhere in your terminal.

#### Method 2: Manual Installation

```bash
# Clone this repository
git clone https://github.com/riteshsingh1/terminal-todo.git
cd terminal-todo

# Make the script executable
chmod +x ttt

# Option 1: Copy to a directory in your PATH
cp ttt ~/.local/bin/   # For personal use
# OR
sudo cp ttt /usr/local/bin/   # System-wide installation (requires sudo)

# Make sure ~/.local/bin is in your PATH (add to your shell profile if needed)
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc  # for bash
# OR
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc   # for zsh
```

### For Windows Systems

#### Option 1: Windows Subsystem for Linux (WSL) - Recommended

This is the most straightforward approach if you want a Unix-like environment:

1. Install WSL by opening PowerShell as Administrator and running:
   ```powershell
   wsl --install
   ```

2. After installation and restart, open your WSL terminal and follow the Linux installation instructions:
   ```bash
   git clone https://github.com/riteshsingh1/terminal-todo.git
   cd terminal-todo
   chmod +x install.sh
   ./install.sh
   ```

#### Option 2: Git Bash

If you already have Git for Windows installed:

1. Open Git Bash
2. Clone the repository and navigate to it:
   ```bash
   git clone https://github.com/riteshsingh1/terminal-todo.git
   cd terminal-todo
   ```

3. Make the script executable and move it to a directory in your PATH:
   ```bash
   chmod +x ttt
   mkdir -p ~/bin
   cp ttt ~/bin/
   ```

4. Add this to your `.bashrc` file:
   ```bash
   echo 'export PATH="$HOME/bin:$PATH"' >> ~/.bashrc
   source ~/.bashrc
   ```

#### Option 3: Using the Batch Wrapper (cmd.exe)

For users who prefer to use Windows Command Prompt:

1. Clone or download the repository
2. Navigate to the repository directory
3. Run the provided `ttt.bat` file:
   ```
   ttt.bat
   ```

4. To make it accessible from anywhere:
   - Right-click on "This PC" or "My Computer" → Properties
   - Click "Advanced system settings"
   - Click "Environment Variables"
   - Edit the "Path" variable and add the full path to the directory containing `ttt.bat`

#### Option 4: Using the PowerShell Wrapper

For PowerShell users:

1. Clone or download the repository
2. Navigate to the repository directory
3. Run the provided PowerShell script:
   ```powershell
   .\ttt.ps1
   ```

4. To make it accessible from anywhere in PowerShell:
   - Create a directory for PowerShell scripts if you don't have one: `mkdir "$env:USERPROFILE\Documents\WindowsPowerShell\Scripts"`
   - Copy the script there: `Copy-Item ttt.ps1 "$env:USERPROFILE\Documents\WindowsPowerShell\Scripts"`
   - Add this directory to your PowerShell profile:
   
     ```powershell
     # Create a profile if you don't have one
     if (!(Test-Path $PROFILE)) {
         New-Item -Path $PROFILE -Type File -Force
     }
     
     # Add the scripts path to your profile
     Add-Content $PROFILE "`$env:Path += `";$env:USERPROFILE\Documents\WindowsPowerShell\Scripts`""
     
     # Optionally create an alias
     Add-Content $PROFILE "Set-Alias -Name ttt -Value $env:USERPROFILE\Documents\WindowsPowerShell\Scripts\ttt.ps1"
     ```

#### Option 5: Windows Terminal with Git Bash

If you use Windows Terminal:

1. Install Windows Terminal from the Microsoft Store if you don't have it
2. Add Git Bash as a profile in Windows Terminal
3. Follow the Git Bash instructions (Option 2)

## Usage

```bash
# Show task list and interact with tasks
ttt

# Add a new task directly
ttt add

# Clear completed tasks
ttt clear

# Show help
ttt help
```

## POSIX-Compliant Alternative

For systems where bash may not be available, a POSIX-compliant shell script `ttt.sh` is provided:

```bash
# Make it executable
chmod +x ttt.sh

# Run directly
./ttt.sh

# Or install it
cp ttt.sh /usr/local/bin/ttt
```

## Keyboard Shortcuts

When interacting with a task:
- `d` - Mark as done
- `p` - Postpone (will prompt for a new date)
- `n` - Mark as not required (removes the task)
- `r` - Restore a completed task to active status

From the main screen:
- `a` - Add a new task
- `q` - Quit the application

## Data Storage

All tasks are stored in `~/.ttt/tasks.txt` in a simple text format.

For Windows users with the batch or PowerShell wrapper, tasks are stored in your user profile directory in `.ttt/tasks.txt`.

## Troubleshooting

### Unix-like Systems

If you can't run `ttt` after installation, try these steps:

1. Make sure the installation directory is in your PATH:
   ```bash
   echo $PATH
   ```

2. If you installed to `~/.local/bin` and it's not in your PATH, update your shell's configuration:
   ```bash
   # For Bash
   echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
   source ~/.bashrc
   
   # For Zsh
   echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
   source ~/.zshrc
   ```

3. Check if the script is executable:
   ```bash
   ls -l $(which ttt)
   ```

   If it's not executable, run:
   ```bash
   chmod +x $(which ttt)
   ```

### Windows Systems

If the batch or PowerShell files don't work:

1. Make sure you have Git for Windows or a bash implementation installed
2. Check that the path to bash.exe in the wrapper scripts is correct
3. Try running the scripts directly from the repository directory 
4. If using WSL, make sure WSL is properly installed and initialized
5. For PowerShell, you might need to set the execution policy:
   ```powershell
   Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
   ``` 