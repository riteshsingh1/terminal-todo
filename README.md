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

```bash
# Clone this repository or download the files
git clone https://github.com/riteshsingh1/terminal-todo.git
cd terminal-todo

# Run the installation script
./install.sh
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