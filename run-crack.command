#!/bin/bash

# Parallels Desktop Crack
# Simple one-click crack script

clear
echo "==============================================="
echo "        Parallels Desktop Crack Tool"
echo "==============================================="
echo ""
echo "This will crack your Parallels Desktop installation."
echo "Please enter your Mac password when prompted."
echo ""

# Change to script directory
cd "$(dirname "$0")"

# Make sure all tools are executable
chmod +x ./GenShineImpactStarter
chmod +x ./crack.sh

# Run the crack script
sudo ./crack.sh

echo ""
echo "==============================================="
echo "         Crack process completed!"
echo "==============================================="
echo ""
echo "If successful, you can now use Parallels Desktop."
echo "Press any key to exit..."
read -n 1
