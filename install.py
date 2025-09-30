#!/usr/bin/env python3
"""
Installation script for TTD - Terminal Todo Application
"""

import os
import sys
import subprocess
from pathlib import Path

def run_command(command, check=True):
    """Run a shell command."""
    print(f"Running: {command}")
    result = subprocess.run(command, shell=True, capture_output=True, text=True)
    if check and result.returncode != 0:
        print(f"Error: {result.stderr}")
        sys.exit(1)
    return result

def main():
    print("🚀 Installing TTD - Terminal Todo Application")
    print("=" * 50)
    
    # Check Python version
    if sys.version_info < (3, 7):
        print("❌ Python 3.7 or higher is required")
        sys.exit(1)
    
    print(f"✅ Python {sys.version.split()[0]} detected")
    
    # Install dependencies
    print("\n📦 Installing dependencies...")
    try:
        run_command("pip install -r requirements.txt")
        print("✅ Dependencies installed successfully")
    except:
        print("❌ Failed to install dependencies. Please run: pip install -r requirements.txt")
        sys.exit(1)
    
    # Make script executable
    script_path = Path(__file__).parent / "ttd.py"
    script_path.chmod(script_path.stat().st_mode | 0o111)
    print("✅ Made ttd.py executable")
    
    # Check if we can create symlink
    try:
        bin_path = Path("/usr/local/bin")
        if bin_path.exists() and os.access(bin_path, os.W_OK):
            symlink_path = bin_path / "ttd"
            if symlink_path.exists():
                symlink_path.unlink()
            symlink_path.symlink_to(script_path.resolve())
            print(f"✅ Created symlink: {symlink_path} -> {script_path}")
            print("   You can now run 'ttd' from anywhere!")
        else:
            print("⚠️  Could not create global symlink (no write access to /usr/local/bin)")
            print(f"   You can run the app with: {script_path}")
            print("   Or manually create a symlink:")
            print(f"   sudo ln -sf {script_path.resolve()} /usr/local/bin/ttd")
    except Exception as e:
        print(f"⚠️  Could not create symlink: {e}")
        print(f"   You can run the app with: {script_path}")
    
    print("\n🎉 Installation complete!")
    print("\nQuick start:")
    print("  ttd                    # Start interactive mode")
    print("  ttd add 'Buy milk'     # Add a task")
    print("  ttd list               # List tasks")
    print("  ttd --help             # Show all commands")
    
if __name__ == "__main__":
    main()