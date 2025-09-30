#!/usr/bin/env python3
"""
TTD - Terminal Todo Application
A powerful terminal-based todo application inspired by Todoist.
"""

import os
import sys
import json
import click
from datetime import datetime, timedelta
from pathlib import Path
from typing import Optional, List, Dict, Any
from rich.console import Console
from rich.table import Table
from rich.panel import Panel
from rich.prompt import Prompt, Confirm
from rich.text import Text
from rich import print as rprint
from dateutil.parser import parse as parse_date

# Initialize rich console
console = Console()

# Application constants
APP_DIR = Path.home() / ".ttd"
TASKS_FILE = APP_DIR / "tasks.json"
CONFIG_FILE = APP_DIR / "config.json"

# Priority colors
PRIORITY_COLORS = {
    "P1": "red",
    "P2": "yellow", 
    "P3": "blue",
    "P4": "dim"
}

class Task:
    """Represents a single task."""
    
    def __init__(self, id: int, content: str, project: str = "Inbox", 
                 priority: str = "P4", due_date: Optional[str] = None,
                 labels: List[str] = None, completed: bool = False,
                 created_at: Optional[str] = None):
        self.id = id
        self.content = content
        self.project = project
        self.priority = priority
        self.due_date = due_date
        self.labels = labels or []
        self.completed = completed
        self.created_at = created_at or datetime.now().isoformat()
        self.completed_at = None
    
    def to_dict(self) -> Dict[str, Any]:
        """Convert task to dictionary for JSON serialization."""
        return {
            "id": self.id,
            "content": self.content,
            "project": self.project,
            "priority": self.priority,
            "due_date": self.due_date,
            "labels": self.labels,
            "completed": self.completed,
            "created_at": self.created_at,
            "completed_at": self.completed_at
        }
    
    @classmethod
    def from_dict(cls, data: Dict[str, Any]) -> 'Task':
        """Create task from dictionary."""
        task = cls(
            id=data["id"],
            content=data["content"],
            project=data.get("project", "Inbox"),
            priority=data.get("priority", "P4"),
            due_date=data.get("due_date"),
            labels=data.get("labels", []),
            completed=data.get("completed", False),
            created_at=data.get("created_at")
        )
        task.completed_at = data.get("completed_at")
        return task

class TodoApp:
    """Main todo application class."""
    
    def __init__(self):
        self.tasks: List[Task] = []
        self.next_id = 1
        self.ensure_app_dir()
        self.load_tasks()
    
    def ensure_app_dir(self):
        """Ensure application directory exists."""
        APP_DIR.mkdir(exist_ok=True)
    
    def load_tasks(self):
        """Load tasks from JSON file."""
        if TASKS_FILE.exists():
            try:
                with open(TASKS_FILE, 'r') as f:
                    data = json.load(f)
                    self.tasks = [Task.from_dict(task_data) for task_data in data.get("tasks", [])]
                    self.next_id = data.get("next_id", 1)
            except (json.JSONDecodeError, KeyError):
                console.print("[red]Error loading tasks file. Starting fresh.[/red]")
                self.tasks = []
                self.next_id = 1
    
    def save_tasks(self):
        """Save tasks to JSON file."""
        data = {
            "tasks": [task.to_dict() for task in self.tasks],
            "next_id": self.next_id
        }
        with open(TASKS_FILE, 'w') as f:
            json.dump(data, f, indent=2)
    
    def add_task(self, content: str, project: str = "Inbox", 
                 priority: str = "P4", due_date: Optional[str] = None,
                 labels: List[str] = None) -> Task:
        """Add a new task."""
        task = Task(
            id=self.next_id,
            content=content,
            project=project,
            priority=priority,
            due_date=due_date,
            labels=labels or []
        )
        self.tasks.append(task)
        self.next_id += 1
        self.save_tasks()
        return task
    
    def get_task(self, task_id: int) -> Optional[Task]:
        """Get task by ID."""
        for task in self.tasks:
            if task.id == task_id:
                return task
        return None
    
    def complete_task(self, task_id: int) -> bool:
        """Mark task as complete/incomplete."""
        task = self.get_task(task_id)
        if task:
            task.completed = not task.completed
            task.completed_at = datetime.now().isoformat() if task.completed else None
            self.save_tasks()
            return True
        return False
    
    def delete_task(self, task_id: int) -> bool:
        """Delete a task."""
        for i, task in enumerate(self.tasks):
            if task.id == task_id:
                del self.tasks[i]
                self.save_tasks()
                return True
        return False
    
    def edit_task(self, task_id: int, **kwargs) -> bool:
        """Edit a task."""
        task = self.get_task(task_id)
        if task:
            for key, value in kwargs.items():
                if hasattr(task, key) and value is not None:
                    setattr(task, key, value)
            self.save_tasks()
            return True
        return False
    
    def get_tasks(self, project: Optional[str] = None, 
                  completed: Optional[bool] = None,
                  priority: Optional[str] = None,
                  search: Optional[str] = None) -> List[Task]:
        """Get filtered tasks."""
        filtered_tasks = self.tasks
        
        if project:
            filtered_tasks = [t for t in filtered_tasks if t.project.lower() == project.lower()]
        
        if completed is not None:
            filtered_tasks = [t for t in filtered_tasks if t.completed == completed]
        
        if priority:
            filtered_tasks = [t for t in filtered_tasks if t.priority == priority]
        
        if search:
            search_lower = search.lower()
            filtered_tasks = [t for t in filtered_tasks if search_lower in t.content.lower()]
        
        return filtered_tasks
    
    def get_projects(self) -> List[str]:
        """Get all unique projects."""
        projects = set(task.project for task in self.tasks)
        return sorted(list(projects))
    
    def get_stats(self) -> Dict[str, Any]:
        """Get task statistics."""
        total_tasks = len(self.tasks)
        completed_tasks = len([t for t in self.tasks if t.completed])
        pending_tasks = total_tasks - completed_tasks
        
        projects = {}
        for task in self.tasks:
            if task.project not in projects:
                projects[task.project] = {"total": 0, "completed": 0}
            projects[task.project]["total"] += 1
            if task.completed:
                projects[task.project]["completed"] += 1
        
        return {
            "total_tasks": total_tasks,
            "completed_tasks": completed_tasks,
            "pending_tasks": pending_tasks,
            "projects": projects
        }

# Initialize the app
app = TodoApp()

def format_task_row(task: Task, show_id: bool = True) -> List[str]:
    """Format a task for table display."""
    # Status icon
    status = "✅" if task.completed else "⭕"
    
    # Priority with color
    priority_color = PRIORITY_COLORS.get(task.priority, "white")
    
    # Due date formatting
    due_str = ""
    if task.due_date:
        try:
            due_date = parse_date(task.due_date)
            today = datetime.now().date()
            if due_date.date() == today:
                due_str = "[red]Today[/red]"
            elif due_date.date() == today + timedelta(days=1):
                due_str = "[yellow]Tomorrow[/yellow]"
            elif due_date.date() < today:
                due_str = "[red bold]Overdue[/red bold]"
            else:
                due_str = due_date.strftime("%b %d")
        except:
            due_str = task.due_date
    
    # Labels
    labels_str = " ".join(f"[cyan]#{label}[/cyan]" for label in task.labels)
    
    row = [
        status,
        f"[{priority_color}]{task.priority}[/{priority_color}]",
        task.content,
        task.project,
        due_str,
        labels_str
    ]
    
    if show_id:
        row.insert(0, str(task.id))
    
    return row

@click.group()
def cli():
    """TTD - Terminal Todo Application"""
    pass

@cli.command()
@click.argument('content')
@click.option('--project', '-p', default='Inbox', help='Project name')
@click.option('--priority', '-P', default='P4', type=click.Choice(['P1', 'P2', 'P3', 'P4']), help='Task priority')
@click.option('--due', '-d', help='Due date (e.g., "tomorrow", "2023-12-25", "next friday")')
@click.option('--labels', '-l', multiple=True, help='Labels for the task')
def add(content, project, priority, due, labels):
    """Add a new task."""
    task = app.add_task(content, project, priority, due, list(labels))
    console.print(f"[green]✅ Added task #{task.id}: {content}[/green]")

@cli.command(name='list')
@click.option('--project', '-p', help='Filter by project')
@click.option('--priority', '-P', type=click.Choice(['P1', 'P2', 'P3', 'P4']), help='Filter by priority')
@click.option('--completed/--pending', default=None, help='Show completed or pending tasks')
@click.option('--search', '-s', help='Search in task content')
def list_tasks(project, priority, completed, search):
    """List tasks with optional filters."""
    tasks = app.get_tasks(project=project, completed=completed, priority=priority, search=search)
    
    if not tasks:
        console.print("[yellow]No tasks found.[/yellow]")
        return
    
    table = Table(show_header=True, header_style="bold magenta")
    table.add_column("ID", style="dim", width=4)
    table.add_column("Status", width=6)
    table.add_column("Priority", width=8)
    table.add_column("Task", min_width=20)
    table.add_column("Project", width=12)
    table.add_column("Due", width=10)
    table.add_column("Labels", width=15)
    
    for task in tasks:
        table.add_row(*format_task_row(task))
    
    console.print(table)
    console.print(f"\nShowing {len(tasks)} task(s)")

@cli.command()
@click.argument('task_id', type=int)
def show(task_id):
    """Show detailed information about a task."""
    task = app.get_task(task_id)
    if not task:
        console.print(f"[red]Task #{task_id} not found.[/red]")
        return
    
    status = "✅ Completed" if task.completed else "⭕ Pending"
    priority_color = PRIORITY_COLORS.get(task.priority, "white")
    
    panel_content = f"""
[bold]Content:[/bold] {task.content}
[bold]Status:[/bold] {status}
[bold]Priority:[/bold] [{priority_color}]{task.priority}[/{priority_color}]
[bold]Project:[/bold] {task.project}
[bold]Due Date:[/bold] {task.due_date or 'Not set'}
[bold]Labels:[/bold] {', '.join(task.labels) if task.labels else 'None'}
[bold]Created:[/bold] {task.created_at}
"""
    
    if task.completed_at:
        panel_content += f"[bold]Completed:[/bold] {task.completed_at}"
    
    console.print(Panel(panel_content, title=f"Task #{task.id}", border_style="blue"))

@cli.command()
@click.argument('task_id', type=int)
def complete(task_id):
    """Toggle task completion status."""
    if app.complete_task(task_id):
        task = app.get_task(task_id)
        status = "completed" if task.completed else "reopened"
        console.print(f"[green]✅ Task #{task_id} {status}.[/green]")
    else:
        console.print(f"[red]Task #{task_id} not found.[/red]")

@cli.command()
@click.argument('task_id', type=int)
@click.confirmation_option(prompt='Are you sure you want to delete this task?')
def delete(task_id):
    """Delete a task."""
    if app.delete_task(task_id):
        console.print(f"[green]✅ Task #{task_id} deleted.[/green]")
    else:
        console.print(f"[red]Task #{task_id} not found.[/red]")

@cli.command()
@click.argument('task_id', type=int)
@click.option('--content', '-c', help='New task content')
@click.option('--project', '-p', help='New project')
@click.option('--priority', '-P', type=click.Choice(['P1', 'P2', 'P3', 'P4']), help='New priority')
@click.option('--due', '-d', help='New due date')
def edit(task_id, content, project, priority, due):
    """Edit a task."""
    updates = {}
    if content:
        updates['content'] = content
    if project:
        updates['project'] = project
    if priority:
        updates['priority'] = priority
    if due:
        updates['due_date'] = due
    
    if not updates:
        console.print("[yellow]No updates provided.[/yellow]")
        return
    
    if app.edit_task(task_id, **updates):
        console.print(f"[green]✅ Task #{task_id} updated.[/green]")
    else:
        console.print(f"[red]Task #{task_id} not found.[/red]")

@cli.command()
def projects():
    """List all projects."""
    project_list = app.get_projects()
    if not project_list:
        console.print("[yellow]No projects found.[/yellow]")
        return
    
    table = Table(show_header=True, header_style="bold magenta")
    table.add_column("Project")
    table.add_column("Total Tasks")
    table.add_column("Completed")
    table.add_column("Pending")
    
    stats = app.get_stats()
    for project in project_list:
        project_stats = stats["projects"].get(project, {"total": 0, "completed": 0})
        total = project_stats["total"]
        completed = project_stats["completed"]
        pending = total - completed
        table.add_row(project, str(total), str(completed), str(pending))
    
    console.print(table)

@cli.command()
def stats():
    """Show task statistics."""
    stats = app.get_stats()
    
    panel_content = f"""
[bold]Total Tasks:[/bold] {stats['total_tasks']}
[bold]Completed:[/bold] [green]{stats['completed_tasks']}[/green]
[bold]Pending:[/bold] [yellow]{stats['pending_tasks']}[/yellow]
[bold]Completion Rate:[/bold] {stats['completed_tasks']/stats['total_tasks']*100:.1f}% (if total > 0)
    """
    
    console.print(Panel(panel_content, title="Task Statistics", border_style="cyan"))

@cli.command()
def interactive():
    """Start interactive mode."""
    console.print("[bold cyan]TTD - Terminal Todo (Interactive Mode)[/bold cyan]")
    console.print("Press 'h' for help, 'q' to quit\n")
    
    while True:
        # Show current tasks
        tasks = app.get_tasks(completed=False)
        if tasks:
            table = Table(show_header=True, header_style="bold magenta")
            table.add_column("ID", style="dim", width=4)
            table.add_column("Priority", width=8)
            table.add_column("Task", min_width=30)
            table.add_column("Project", width=12)
            table.add_column("Due", width=10)
            
            for task in tasks[:10]:  # Show only first 10 tasks
                row = format_task_row(task)
                table.add_row(row[0], row[2], row[3], row[4], row[5])  # Skip status column
            
            console.print(table)
            if len(tasks) > 10:
                console.print(f"... and {len(tasks) - 10} more tasks")
        else:
            console.print("[yellow]No pending tasks! 🎉[/yellow]")
        
        console.print()
        command = Prompt.ask("[bold]Command[/bold] (h for help)", default="h").lower().strip()
        
        if command == 'q':
            break
        elif command == 'h':
            help_text = """
[bold cyan]Available Commands:[/bold cyan]
[bold]a[/bold] - Add new task
[bold]l[/bold] - List all tasks  
[bold]c[/bold] - Complete/uncomplete task
[bold]d[/bold] - Delete task
[bold]e[/bold] - Edit task
[bold]p[/bold] - Show projects
[bold]s[/bold] - Show statistics
[bold]q[/bold] - Quit
[bold]h[/bold] - Show this help
            """
            console.print(Panel(help_text, border_style="blue"))
        elif command == 'a':
            content = Prompt.ask("Task content")
            if content:
                project = Prompt.ask("Project", default="Inbox")
                priority = Prompt.ask("Priority", choices=["P1", "P2", "P3", "P4"], default="P4")
                due = Prompt.ask("Due date (optional)", default="")
                task = app.add_task(content, project, priority, due if due else None)
                console.print(f"[green]✅ Added task #{task.id}[/green]")
        elif command == 'l':
            console.clear()
            continue
        elif command == 'c':
            task_id = Prompt.ask("Task ID to complete/uncomplete", type=int)
            if app.complete_task(task_id):
                task = app.get_task(task_id)
                status = "completed" if task.completed else "reopened"
                console.print(f"[green]✅ Task #{task_id} {status}[/green]")
            else:
                console.print(f"[red]Task #{task_id} not found[/red]")
        elif command == 'd':
            task_id = Prompt.ask("Task ID to delete", type=int)
            if Confirm.ask(f"Delete task #{task_id}?"):
                if app.delete_task(task_id):
                    console.print(f"[green]✅ Task #{task_id} deleted[/green]")
                else:
                    console.print(f"[red]Task #{task_id} not found[/red]")
        elif command == 'e':
            task_id = Prompt.ask("Task ID to edit", type=int)
            task = app.get_task(task_id)
            if task:
                content = Prompt.ask("New content", default=task.content)
                project = Prompt.ask("New project", default=task.project)
                priority = Prompt.ask("New priority", choices=["P1", "P2", "P3", "P4"], default=task.priority)
                app.edit_task(task_id, content=content, project=project, priority=priority)
                console.print(f"[green]✅ Task #{task_id} updated[/green]")
            else:
                console.print(f"[red]Task #{task_id} not found[/red]")
        elif command == 'p':
            projects_list = app.get_projects()
            for project in projects_list:
                console.print(f"• {project}")
        elif command == 's':
            stats = app.get_stats()
            console.print(f"Total: {stats['total_tasks']}, Completed: {stats['completed_tasks']}, Pending: {stats['pending_tasks']}")
        
        console.print()

if __name__ == '__main__':
    try:
        # If no arguments provided, start interactive mode
        if len(sys.argv) == 1:
            interactive()
        else:
            cli()
    except SystemExit:
        # Click sometimes raises SystemExit, which is normal
        pass
    except Exception as e:
        console.print(f"[red]Error: {e}[/red]")
        sys.exit(1)