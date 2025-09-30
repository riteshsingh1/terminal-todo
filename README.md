# TTD - Terminal Todo

A powerful, terminal-based todo application inspired by Todoist, designed for macOS and Linux.

## Table of Contents

- [Features](#features)
- [Installation](#installation)
- [Quick Start Tutorial](#quick-start-tutorial)
  - [Getting Started](#1-getting-started)
  - [Adding Your First Tasks](#2-adding-your-first-tasks)
  - [Viewing and Managing Tasks](#3-viewing-and-managing-tasks)
  - [Task Selection & Operations](#4-task-selection--operations)
  - [Project Management](#5-project-management)
  - [Interactive Mode](#6-interactive-mode-tutorial)
  - [Advanced Usage](#7-advanced-usage-examples)
- [Commands](#commands)
- [Interactive Mode Commands](#interactive-mode-commands)
- [Task Selection Quick Reference](#task-selection-quick-reference)
- [Enhanced Project Browsing](#enhanced-project-browsing)
- [Pro Tips & Best Practices](#pro-tips--best-practices)
- [Configuration](#configuration)
- [Troubleshooting](#troubleshooting)
- [Testing & Development](#testing--development)
- [License](#license)

## Features

- 📝 Add, edit, and delete tasks
- 🏷️ Organize tasks with projects and labels
- ⭐ Set task priorities (P1, P2, P3, P4)
- 📅 Due dates and scheduling
- ✅ Mark tasks as complete
- 🔍 Search and filter tasks
- 📊 View task statistics
- 💾 Persistent storage with JSON
- 🎨 Beautiful terminal UI with colors
- ⌨️ Intuitive keyboard shortcuts

## Installation

```bash
# Clone the repository
git clone <your-repo-url>
cd ttd

# Install dependencies
pip install -r requirements.txt

# Make the script executable
chmod +x ttd.py

# Optionally, create a symlink for global access
ln -s $(pwd)/ttd.py /usr/local/bin/ttd
```

## Quick Start Tutorial

### 1. Getting Started

First, run TTD to see the help:
```bash
./ttd.py --help
```

Start with interactive mode to get familiar:
```bash
./ttd.py
```

### 2. Adding Your First Tasks

Let's add some tasks using the command line:

```bash
# Basic task
./ttd.py add "Buy milk"

# Task with project and priority
./ttd.py add "Review code" --project "Work" --priority P1

# Task with due date
./ttd.py add "Doctor appointment" --project "Personal" --priority P2 --due "tomorrow"

# Task with labels
./ttd.py add "Plan vacation" --project "Personal" --priority P3 --labels "travel" --labels "planning"
```

### 3. Viewing and Managing Tasks

List all your tasks:
```bash
./ttd.py list
```

Filter tasks by project:
```bash
./ttd.py list --project "Work"
```

Filter by priority:
```bash
./ttd.py list --priority P1
```

Search for specific tasks:
```bash
./ttd.py list --search "doctor"
```

View completed tasks:
```bash
./ttd.py list --completed
```

### 4. Task Selection & Operations

**Understanding Task IDs:**
Every task has a unique ID number shown in the first column when you list tasks. This is how you select specific tasks for operations.

```bash
# List tasks to see their IDs
./ttd.py list
```

**Command Line Task Selection:**
```bash
# Select task by ID for different operations
./ttd.py show 5        # View details of task #5
./ttd.py complete 3    # Complete task #3
./ttd.py edit 7 --priority P1    # Edit task #7
./ttd.py delete 2      # Delete task #2
```

**Interactive Mode Task Selection:**
```bash
# Start interactive mode
./ttd.py

# Then use these commands:
# c -> Enter task ID -> Complete/uncomplete that task
# e -> Enter task ID -> Edit that task  
# d -> Enter task ID -> Delete that task
```

**Finding Tasks to Select:**
```bash
# Use filtering to find the task you want
./ttd.py list --project "Work"           # Show only Work tasks
./ttd.py list --priority P1              # Show only P1 tasks  
./ttd.py list --search "meeting"         # Find tasks containing "meeting"
./ttd.py list --completed                # Show completed tasks
./ttd.py list --pending                  # Show pending tasks
```

**Examples of Task Selection:**
```bash
# Scenario: Complete all high-priority work tasks
./ttd.py list --project "Work" --priority P1    # Find the tasks
./ttd.py complete 12     # Complete task #12
./ttd.py complete 15     # Complete task #15

# Scenario: Edit overdue tasks
./ttd.py list            # Find overdue tasks (shown in red)
./ttd.py edit 8 --due "today" --priority P1     # Update task #8
```

### 5. Project Management

View all projects:
```bash
./ttd.py projects
```

View statistics:
```bash
./ttd.py stats
```

### 6. Interactive Mode Tutorial

Start interactive mode:
```bash
./ttd.py
```

In interactive mode, you'll see:
- Current pending tasks in a table with ID numbers
- Command prompt at the bottom

**Task Selection in Interactive Mode:**

1. **View the task list** - Task IDs are shown in the first column
2. **Select tasks by ID** - When prompted, enter the task ID number

Try these commands:
- Type `a` and press Enter to add a new task
- Type `c` and enter a task ID (e.g., `5`) to complete it
- Type `e` and enter a task ID to edit that specific task
- Type `d` and enter a task ID to delete that task
- Type `l` to refresh the task list (see updated IDs)
- Type `p` to view projects
- Type `s` to view statistics
- Type `h` for help
- Type `q` to quit

**Interactive Selection Examples:**

*Method 1: Inline commands (fastest)*
```
Command (h for help): c 7        # Complete task #7
✅ Task #7 completed

Command (h for help): s 3        # Show task #3 details
[Task details displayed]

Command (h for help): d 5        # Delete task #5
Delete task #5? [y/N]: y
✅ Task #5 deleted
```

*Method 2: Step-by-step (traditional)*
```
Command (h for help): c
Task ID to complete/uncomplete: 7
✅ Task #7 completed

Command (h for help): e  
Task ID to edit: 3
New content: Updated task content
✅ Task #3 updated
```

### 7. Advanced Usage Examples

**Due Date Formats:**
```bash
./ttd.py add "Meeting" --due "2023-12-25"      # Specific date
./ttd.py add "Call client" --due "tomorrow"     # Natural language
./ttd.py add "Review report" --due "next friday" # Natural language
```

**Priority Levels:**
- `P1` - Urgent (red) 🔴
- `P2` - High (yellow) 🟡  
- `P3` - Medium (blue) 🔵
- `P4` - Low (dim) ⚪

**Complex Filtering:**
```bash
# High priority work tasks
./ttd.py list --project "Work" --priority P1

# Pending personal tasks
./ttd.py list --project "Personal" --pending

# Search across all tasks
./ttd.py list --search "meeting"
```

**Batch Operations:**
```bash
# Add multiple related tasks
./ttd.py add "Plan presentation" --project "Work" --priority P1 --due "friday"
./ttd.py add "Create slides" --project "Work" --priority P2 --due "thursday"  
./ttd.py add "Practice presentation" --project "Work" --priority P3 --due "friday"
```

## Usage

## Commands

- `add` - Add a new task
- `list` - List tasks with filters
- `show` - Show task details
- `edit` - Edit a task
- `complete` - Mark task as complete
- `delete` - Delete a task
- `projects` - Manage projects
- `stats` - Show statistics

## Interactive Mode Commands

### Quick Commands (Inline)
- `c 5` - Complete/uncomplete task #5
- `d 3` - Delete task #3  
- `e 7` - Edit task #7
- `s 2` - Show task #2 details

### Project Navigation
- `pr work` - Browse "Work" project tasks (exact match)
- `pr wor.*` - Browse projects matching regex pattern
- `pr ^dev` - Browse projects starting with "dev"

### Basic Commands
- `a` - Add task
- `l` - Refresh task list
- `p` - Show projects list
- `stats` - Show statistics
- `h` - Show help
- `q` - Quit

### Legacy Commands (still supported)
- `c` - Complete task (asks for ID)
- `d` - Delete task (asks for ID)
- `e` - Edit task (asks for ID)

## Task Selection Quick Reference

| Method | How to Select | Example |
|--------|---------------|---------|
| **Command Line** | Use task ID from list | `./ttd.py complete 5` |
| **Interactive (Inline)** | Type command + ID directly | `c 5` (fastest method) |
| **Interactive (Legacy)** | Enter ID when prompted | `c` → `5` → Enter |
| **View Details** | Show specific task | `./ttd.py show 3` or `s 3` |
| **Find Tasks** | Use filters first | `./ttd.py list --project "Work"` |
| **Multiple Tasks** | Select each by ID | `c 1`, `c 2`, `c 3` in interactive mode |

**Project Browsing with Regex:**
```bash
# Interactive mode project navigation
Command: pr work                         # Browse "Work" project
Command: pr per.*                        # Browse projects matching "per.*" (Personal, etc.)
Command: pr ^dev                         # Browse projects starting with "dev"

# In project browser:
1    # Select and view task #1
c3   # Complete task #3
d5   # Delete task #5  
s2   # Show details for task #2
q    # Return to main menu
```

**Common Task Selection Patterns:**
```bash
# Pattern 1: Find → Select → Act
./ttd.py list --priority P1              # Find high priority tasks
./ttd.py complete 7                      # Complete task #7

# Pattern 2: Project Browse → Quick Actions
pr work                                  # Enter project browser
c1                                       # Complete task #1 in project
d3                                       # Delete task #3 in project

# Pattern 3: Filter → Bulk Operations
./ttd.py list --project "Personal"       # Show personal tasks
./ttd.py complete 3                      # Complete task #3
./ttd.py complete 8                      # Complete task #8
./ttd.py delete 15                       # Delete task #15
```

## Enhanced Project Browsing

TTD features an advanced project browsing system with regex pattern matching and interactive task management.

### Project Selection with Regex

The `pr` command supports powerful regex patterns for project selection:

```bash
# In interactive mode
pr work           # Exact match for "Work" project
pr wor.*          # Match "Work", "Work-Dev", "Workflow", etc.
pr ^dev           # Projects starting with "dev" 
pr (work|home)    # Projects containing "work" OR "home"
pr .*-2024$       # Projects ending with "-2024"
```

### Multiple Project Matches

When multiple projects match your pattern:
```
Command: pr work
Multiple projects match 'work':
  1. Work (7 tasks)
  2. Work-Development (2 tasks)  
  3. Homework (5 tasks)
Select project number: 1
```

### Project Task Management

Inside a project, use simple numbered commands:
```
📁 Project: Work
7 task(s) found

Tasks in Work:
   1. ⭕ P1 Attend daily standup (due: today)
   2. ⭕ P1 Meeting with team (due: tomorrow)
   3. ⭕ P2 Create slides (due: friday)

Commands: [number] to select, c[number] to complete, d[number] to delete, s[number] to show, q to quit
Command: c1        # Complete task #1
✅ Task #12 completed
```

### Benefits

- **No Screen Flickering**: Clean, static interface
- **Regex Power**: Find projects with complex patterns
- **Quick Actions**: Single-command task operations
- **Visual Organization**: Clear project-focused view
- **Efficient Navigation**: Direct numbered selection

## Pro Tips & Best Practices

### Organizing Your Workflow

1. **Use Projects Effectively:**
   ```bash
   # Create projects for different areas of life
   ./ttd.py add "Review budget" --project "Finance"
   ./ttd.py add "Learn Python" --project "Learning"
   ./ttd.py add "Grocery shopping" --project "Personal"
   ```

2. **Priority System:**
   - P1: Must do today (urgent deadlines, critical tasks)
   - P2: Should do soon (important but not urgent)
   - P3: Nice to do (when you have time)
   - P4: Someday/maybe (ideas and low priority items)

3. **Label Strategy:**
   ```bash
   # Use labels for contexts and themes
   ./ttd.py add "Call insurance" --labels "phone-calls" --labels "errands"
   ./ttd.py add "Buy birthday gift" --labels "shopping" --labels "family"
   ```

### Keyboard-First Workflow

For maximum efficiency, use these command patterns:

```bash
# Quick add with aliases (add to your shell profile)
alias ta="./ttd.py add"
alias tl="./ttd.py list"
alias tc="./ttd.py complete"

# Then use like:
ta "New task" --project "Work" --priority P2
tl --project "Work"
tc 5
```

### Daily Workflow Example

**Morning Planning:**
```bash
# Review today's tasks
./ttd.py list --priority P1
./ttd.py list --priority P2

# Check overdue items (shows in red)
./ttd.py list
```

**During the Day:**
```bash
# Quick task entry
./ttd.py add "Follow up with client" --project "Work" --priority P2

# Mark completed tasks
./ttd.py complete 3

# Check progress
./ttd.py stats
```

**Evening Review:**
```bash
# See what you accomplished
./ttd.py list --completed

# Plan tomorrow
./ttd.py add "Prepare presentation" --project "Work" --priority P1 --due "tomorrow"
```

## Configuration

The application stores data in `~/.ttd/` directory:
- `tasks.json` - Task data  
- `config.json` - User configuration

### Data Location
```bash
# View your data directory
ls -la ~/.ttd/

# Backup your tasks
cp ~/.ttd/tasks.json ~/backup-tasks-$(date +%Y%m%d).json
```

### Customization
Copy `config.example.json` to `~/.ttd/config.json` to customize:
- Default project and priority
- Color schemes
- Display preferences

## Troubleshooting

### Common Issues

**Command not found:**
```bash
# Make sure the script is executable
chmod +x ttd.py

# Or run with python directly
python3 ttd.py --help
```

**Permission errors:**
```bash
# Check if ~/.ttd directory exists and is writable
ls -ld ~/.ttd
mkdir -p ~/.ttd
```

**Python dependencies:**
```bash
# Reinstall dependencies
pip3 install -r requirements.txt --upgrade
```

### Getting Help

- Run `./ttd.py --help` for command overview
- Run `./ttd.py COMMAND --help` for specific command help
- Use interactive mode (`./ttd.py`) and press `h` for help
- Check the demo script: `./demo.sh`

### Advanced Usage

**Automation with Scripts:**
```bash
#!/bin/bash
# daily-standup.sh - Review daily tasks
echo "=== Today's High Priority Tasks ==="
./ttd.py list --priority P1 --priority P2

echo -e "\n=== Work Tasks ==="  
./ttd.py list --project "Work" --pending

echo -e "\n=== Statistics ==="
./ttd.py stats
```

**Integration with Other Tools:**
```bash
# Export tasks to text file
./ttd.py list > my-tasks.txt

# Create task from calendar event
./ttd.py add "Team meeting prep" --project "Work" --priority P2 --due "$(date -d '+1 day' +%Y-%m-%d)"
```

## Testing & Development

Run the test suite:
```bash
python3 test_ttd.py
```

Run the demo:
```bash
./demo.sh
```

Use the Makefile for common tasks:
```bash
make help     # Show available commands
make test     # Run tests
make demo     # Run demo
make clean    # Clean up files
```

## License

MIT License