#!/usr/bin/env python3
"""
Test suite for TTD - Terminal Todo Application
"""

import unittest
import tempfile
import json
import os
from pathlib import Path
from datetime import datetime

# Import the main application
import sys
sys.path.insert(0, os.path.dirname(__file__))
from ttd import Task, TodoApp

class TestTask(unittest.TestCase):
    """Test the Task class."""
    
    def test_task_creation(self):
        """Test creating a new task."""
        task = Task(1, "Test task", "Work", "P1", "2023-12-25", ["urgent"])
        
        self.assertEqual(task.id, 1)
        self.assertEqual(task.content, "Test task") 
        self.assertEqual(task.project, "Work")
        self.assertEqual(task.priority, "P1")
        self.assertEqual(task.due_date, "2023-12-25")
        self.assertEqual(task.labels, ["urgent"])
        self.assertFalse(task.completed)
        self.assertIsNotNone(task.created_at)
    
    def test_task_to_dict(self):
        """Test task serialization."""
        task = Task(1, "Test task")
        task_dict = task.to_dict()
        
        self.assertIsInstance(task_dict, dict)
        self.assertEqual(task_dict["id"], 1)
        self.assertEqual(task_dict["content"], "Test task")
    
    def test_task_from_dict(self):
        """Test task deserialization."""
        task_data = {
            "id": 1,
            "content": "Test task",
            "project": "Work",
            "priority": "P2",
            "due_date": None,
            "labels": [],
            "completed": False,
            "created_at": "2023-01-01T00:00:00",
            "completed_at": None
        }
        
        task = Task.from_dict(task_data)
        self.assertEqual(task.id, 1)
        self.assertEqual(task.content, "Test task")
        self.assertEqual(task.project, "Work")
        self.assertEqual(task.priority, "P2")

class TestTodoApp(unittest.TestCase):
    """Test the TodoApp class."""
    
    def setUp(self):
        """Set up test environment."""
        # Create temporary directory for test data
        self.test_dir = tempfile.mkdtemp()
        self.tasks_file = Path(self.test_dir) / "tasks.json"
        
        # Monkey patch the file paths
        import ttd
        ttd.APP_DIR = Path(self.test_dir)
        ttd.TASKS_FILE = self.tasks_file
        
        # Create fresh app instance
        self.app = TodoApp()
    
    def tearDown(self):
        """Clean up test environment."""
        import shutil
        shutil.rmtree(self.test_dir)
    
    def test_add_task(self):
        """Test adding a task."""
        task = self.app.add_task("Test task", "Work", "P1")
        
        self.assertEqual(task.content, "Test task")
        self.assertEqual(task.project, "Work") 
        self.assertEqual(task.priority, "P1")
        self.assertEqual(len(self.app.tasks), 1)
        self.assertEqual(self.app.next_id, 2)
    
    def test_get_task(self):
        """Test getting a task by ID."""
        task = self.app.add_task("Test task")
        retrieved_task = self.app.get_task(task.id)
        
        self.assertIsNotNone(retrieved_task)
        self.assertEqual(retrieved_task.content, "Test task")
        
        # Test non-existent task
        self.assertIsNone(self.app.get_task(999))
    
    def test_complete_task(self):
        """Test completing a task."""
        task = self.app.add_task("Test task")
        
        # Complete the task
        result = self.app.complete_task(task.id)
        self.assertTrue(result)
        self.assertTrue(task.completed)
        self.assertIsNotNone(task.completed_at)
        
        # Uncomplete the task
        result = self.app.complete_task(task.id)
        self.assertTrue(result)
        self.assertFalse(task.completed)
        self.assertIsNone(task.completed_at)
        
        # Test non-existent task
        self.assertFalse(self.app.complete_task(999))
    
    def test_delete_task(self):
        """Test deleting a task."""
        task = self.app.add_task("Test task")
        initial_count = len(self.app.tasks)
        
        result = self.app.delete_task(task.id)
        self.assertTrue(result)
        self.assertEqual(len(self.app.tasks), initial_count - 1)
        
        # Test non-existent task
        self.assertFalse(self.app.delete_task(999))
    
    def test_edit_task(self):
        """Test editing a task."""
        task = self.app.add_task("Original task", "Inbox", "P4")
        
        result = self.app.edit_task(task.id, content="Updated task", priority="P1")
        self.assertTrue(result)
        self.assertEqual(task.content, "Updated task")
        self.assertEqual(task.priority, "P1")
        self.assertEqual(task.project, "Inbox")  # Unchanged
        
        # Test non-existent task
        self.assertFalse(self.app.edit_task(999, content="Test"))
    
    def test_get_tasks_filtering(self):
        """Test task filtering."""
        # Add test tasks
        self.app.add_task("Work task 1", "Work", "P1")
        self.app.add_task("Work task 2", "Work", "P2") 
        self.app.add_task("Personal task", "Personal", "P1")
        completed_task = self.app.add_task("Completed task", "Work", "P3")
        self.app.complete_task(completed_task.id)
        
        # Test project filtering
        work_tasks = self.app.get_tasks(project="Work")
        self.assertEqual(len(work_tasks), 3)  # 2 pending + 1 completed
        
        # Test completion filtering
        pending_tasks = self.app.get_tasks(completed=False)
        self.assertEqual(len(pending_tasks), 3)
        
        completed_tasks = self.app.get_tasks(completed=True)
        self.assertEqual(len(completed_tasks), 1)
        
        # Test priority filtering
        p1_tasks = self.app.get_tasks(priority="P1")
        self.assertEqual(len(p1_tasks), 2)
        
        # Test search filtering
        search_tasks = self.app.get_tasks(search="Work")
        self.assertEqual(len(search_tasks), 2)  # Only matches content, not project
    
    def test_get_projects(self):
        """Test getting project list."""
        self.app.add_task("Task 1", "Work")
        self.app.add_task("Task 2", "Personal")
        self.app.add_task("Task 3", "Work")
        
        projects = self.app.get_projects()
        self.assertEqual(set(projects), {"Work", "Personal"})
    
    def test_get_stats(self):
        """Test getting statistics."""
        self.app.add_task("Task 1", "Work")
        self.app.add_task("Task 2", "Personal")
        completed_task = self.app.add_task("Task 3", "Work")
        self.app.complete_task(completed_task.id)
        
        stats = self.app.get_stats()
        
        self.assertEqual(stats["total_tasks"], 3)
        self.assertEqual(stats["completed_tasks"], 1)
        self.assertEqual(stats["pending_tasks"], 2)
        
        # Check project stats
        work_stats = stats["projects"]["Work"]
        self.assertEqual(work_stats["total"], 2)
        self.assertEqual(work_stats["completed"], 1)
    
    def test_save_and_load_tasks(self):
        """Test persistence."""
        # Add some tasks
        task1 = self.app.add_task("Task 1", "Work", "P1")
        task2 = self.app.add_task("Task 2", "Personal", "P2")
        self.app.complete_task(task1.id)
        
        # Create new app instance (should load from file)
        new_app = TodoApp()
        
        self.assertEqual(len(new_app.tasks), 2)
        self.assertEqual(new_app.next_id, 3)
        
        # Check that tasks loaded correctly
        loaded_task1 = new_app.get_task(task1.id)
        self.assertIsNotNone(loaded_task1)
        self.assertEqual(loaded_task1.content, "Task 1")
        self.assertTrue(loaded_task1.completed)

if __name__ == '__main__':
    # Run the tests
    unittest.main(verbosity=2)