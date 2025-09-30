# TTD - Terminal Todo

A powerful, terminal-based todo application inspired by Todoist, designed for macOS and Linux.

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

## Usage

```bash
# Start the interactive mode
./ttd.py

# Or use command line interface
./ttd.py add "Buy groceries" --project "Personal" --priority P2 --due "tomorrow"
./ttd.py list --project "Work"
./ttd.py complete 5
./ttd.py show --help
```

## Commands

- `add` - Add a new task
- `list` - List tasks with filters
- `show` - Show task details
- `edit` - Edit a task
- `complete` - Mark task as complete
- `delete` - Delete a task
- `projects` - Manage projects
- `stats` - Show statistics

## Keyboard Shortcuts (Interactive Mode)

- `a` - Add task
- `e` - Edit selected task
- `d` - Delete selected task
- `c` - Complete/uncomplete task
- `p` - Change priority
- `f` - Filter tasks
- `s` - Search tasks
- `q` - Quit
- `h` - Help

## Configuration

The application stores data in `~/.ttd/` directory:
- `tasks.json` - Task data
- `config.json` - User configuration

## License

MIT License