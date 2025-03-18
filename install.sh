#!/bin/bash

# Make the script executable
chmod +x ttt
chmod +x ttt.sh

echo "===== Installing Terminal Todo Tracker ====="

# Choose installation location
echo "Where would you like to install ttt?"
echo "1. User bin directory (~/.local/bin) - recommended for single user"
echo "2. System bin directory (/usr/local/bin) - requires sudo, available to all users"
read -p "Enter choice [1-2]: " choice

case $choice in
  1)
    # Create ~/.local/bin if it doesn't exist
    if [ ! -d "$HOME/.local/bin" ]; then
      echo "Creating ~/.local/bin directory..."
      mkdir -p "$HOME/.local/bin"
    fi
    
    # Copy the script to ~/.local/bin
    cp ttt "$HOME/.local/bin/"
    
    # Add the directory to PATH if it's not already there
    if ! echo $PATH | grep -q "$HOME/.local/bin"; then
      echo "Adding ~/.local/bin to PATH in your shell profile..."
      
      # Determine which shell is being used
      if [ -f "$HOME/.zshrc" ]; then
        echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.zshrc"
        echo "Added to ~/.zshrc. Please run 'source ~/.zshrc' to update your current session."
      elif [ -f "$HOME/.bashrc" ]; then
        echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"
        echo "Added to ~/.bashrc. Please run 'source ~/.bashrc' to update your current session."
      else
        echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.profile"
        echo "Added to ~/.profile. Please log out and log back in for changes to take effect."
      fi
    fi
    
    echo "ttt has been installed to ~/.local/bin/"
    echo "You can now run 'ttt' from anywhere!"
    ;;
    
  2)
    # Copy the script to /usr/local/bin
    echo "Installing to /usr/local/bin (requires sudo)..."
    sudo cp ttt /usr/local/bin/
    
    echo "ttt has been installed to /usr/local/bin/"
    echo "You can now run 'ttt' from anywhere!"
    ;;
    
  *)
    echo "Invalid choice. Installation aborted."
    exit 1
    ;;
esac

# Additional info
echo ""
echo "===== Installation Complete ====="
echo "Usage:"
echo "  ttt              - Show task list"
echo "  ttt add          - Add a new task"
echo "  ttt clear        - Clear completed tasks"
echo "  ttt help         - Show help"
echo ""
echo "Your tasks are stored in $HOME/.ttt/tasks.txt" 