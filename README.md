# Terminal Todo Tracker (ttt)

A simple terminal-based todo application with zero external dependencies, featuring a clean, colorful interface.

## Features

- Organize tasks by due date
- Single-key shortcuts for task management
- Mark tasks as done, not required, or postpone
- Completed tasks are strikethrough and moved to the bottom
- Colorful, intuitive interface
- Task numbering for easy selection
- Visual separation with italicized action menus

## Screenshots

```
==== Terminal Todo Tracker ====

ACTIVE TASKS:

Due: 25/05/23
----------------------------------------
 [1] Complete project proposal
 [2] Send meeting agenda

Due: 30/05/23
----------------------------------------
 [3] Review team performance

----------------------------------------
Actions: Select task number, then choose:
 d-Done  p-Postpone  n-Not Required  a-Add New  q-Quit
----------------------------------------

COMPLETED TASKS:
----------------------------------------
 Update documentation (completed on 22/05/23)

Status: 3 active, 1 completed
```
*Note: Action menus appear in italics in the actual application*

## Installation

### Method 1: Using the Installer (Recommended)

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

### Method 2: Manual Installation

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

From the main screen:
- `a` - Add a new task
- `q` - Quit the application

## Data Storage

All tasks are stored in `~/.ttt/tasks.txt` in a simple text format.

## Troubleshooting

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