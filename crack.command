#!/bin/bash

# Parallels Desktop Crack - All-in-One Script
# Usage: Just double-click this file

clear
echo "=============================================="
echo "       Parallels Desktop Crack Tool"
echo "=============================================="
echo ""

# Check if running as root (if so, skip sudo prompts)
if [[ $EUID -ne 0 ]]; then
    echo "This will crack your Parallels Desktop installation."
    echo "Enter your Mac password when prompted."
    echo ""
    
    # Option to disable validation first
    read -p "Disable macOS validation first? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "Disabling macOS library validation..."
        sudo spctl --master-disable
        echo "✓ Validation disabled"
        echo ""
    fi
fi

# Change to script directory
cd "$(dirname "$0")"

# Parallels paths and files
ParaHome='/Applications/Parallels Desktop.app'
DYLIB="./inject.dylib"

# Check requirements
[ ! -f "$DYLIB" ] && { echo "✗ inject.dylib not found!"; exit 1; }
[ ! -f "./patcher" ] && { echo "✗ patcher not found!"; exit 1; }
[ ! -d "$ParaHome" ] && { echo "✗ Parallels Desktop not installed!"; exit 1; }

echo "✓ All files found. Starting crack process..."

# Stop Parallels if running
if pgrep -x "prl_disp_service" &>/dev/null; then
    echo "• Stopping Parallels Desktop..."
    pkill -9 prl_client_app &>/dev/null
    "$ParaHome/Contents/MacOS/Parallels Service" service_stop &>/dev/null
    sleep 1
    sudo launchctl stop /Library/LaunchDaemons/com.parallels.desktop.launchdaemon.plist &>/dev/null
    pkill -9 prl_disp_service &>/dev/null
    sudo rm -f "/var/run/prl_*" &>/dev/null
fi

# Prepare injection library
echo "• Preparing injection library..."
xattr -cr "$DYLIB" ./* &>/dev/null
chmod +x ./patcher
sudo codesign -f -s - --timestamp=none --all-architectures "$DYLIB" &>/dev/null
sudo cp "$DYLIB" "$ParaHome/Contents/Frameworks/inject.dylib"

# Function to patch files
patch_file() {
    local file="$1"
    echo "• Processing $(basename "$file")..."
    
    # Create backup if needed
    [ ! -f "${file}_backup" ] && sudo cp "$file" "${file}_backup"
    
    # Restore and inject
    sudo cp "${file}_backup" "$file"
    ./patcher insert "@rpath/inject.dylib" "${file}_backup" "$file" &>/dev/null
    sudo codesign -fs - --entitlements './entitlements.plist' "$file" &>/dev/null
}

# Patch main files
patch_file "$ParaHome/Contents/MacOS/Parallels Service.app/Contents/MacOS/prl_disp_service"
patch_file "$ParaHome/Contents/MacOS/Parallels VM.app/Contents/MacOS/prl_vm_app"
patch_file "$ParaHome/Contents/MacOS/prl_client_app"

# Remove license file
sudo rm -f "/Library/Preferences/Parallels/licenses.json" &>/dev/null

# Start Parallels service
echo "• Starting Parallels service..."
"$ParaHome/Contents/MacOS/Parallels Service" service_start &>/dev/null

# Configure Parallels
"$ParaHome/Contents/MacOS/prlsrvctl" web-portal signout &>/dev/null
"$ParaHome/Contents/MacOS/prlsrvctl" set --cep off &>/dev/null
"$ParaHome/Contents/MacOS/prlsrvctl" set --allow-attach-screenshots off &>/dev/null

echo ""
echo "=============================================="
echo "           🎉 CRACK COMPLETED! 🎉"
echo "=============================================="
echo ""
echo "Parallels Desktop is now ready to use!"
echo ""
echo "Press any key to exit..."
read -n 1
