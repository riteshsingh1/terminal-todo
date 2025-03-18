#!/bin/bash

# Make the script executable
chmod +x ttt

# Check if the script is already installed
if [ -f /usr/local/bin/ttt ]; then
  echo "ttt is already installed. Replacing with new version."
  sudo rm /usr/local/bin/ttt
fi

# Copy the script to a location in the PATH
sudo cp ttt /usr/local/bin/

echo "Installation complete!"
echo "You can now use the 'ttt' command anywhere to manage your tasks." 