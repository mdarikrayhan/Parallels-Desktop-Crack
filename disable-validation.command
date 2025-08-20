#!/bin/bash

clear
echo "==============================================="
echo "    Disable Library Validation for macOS"
echo "==============================================="
echo ""
echo "This will disable macOS library validation to allow"
echo "the Parallels Desktop crack to work properly."
echo ""
echo "Enter your Mac password when prompted:"
echo ""

sudo spctl --master-disable

if [ $? -eq 0 ]; then
    echo ""
    echo "✓ Library validation disabled successfully!"
    echo ""
    echo "You can now run the crack. After cracking,"
    echo "you can re-enable validation with:"
    echo "sudo spctl --master-enable"
else
    echo ""
    echo "✗ Failed to disable library validation"
    echo "Please check your password and try again"
fi

echo ""
echo "Press any key to exit..."
read -n 1
