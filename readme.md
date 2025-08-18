# Parallels Desktop Crack Installation Guide

## Installing Parallels Desktop
1. Open the image `ParallelsDesktop-20.4.1-55996.dmg`.
2. Run the Install installer.
3. When prompted for an update, **decline** by closing the update window, then select **No, install the current version**.
4. Enter your Mac password (the one you use to log in).
5. Accept the license agreement.
6. **Uncheck**: *Help us make Parallels Desktop for Mac better by automatically sending usage statistics to Parallels* (optional, does not affect activation).
7. Click **Accept**.
8. Wait for the installation to complete.
9. Close Parallels Desktop.

## Installing the Patch
1. Copy the `Patch` folder to your desktop.
2. Open the `Patch` folder.
3. Run the `Launch Patch` file.
   - If the file won’t open, confirm the launch in **System Settings → Privacy & Security → Security**.
  - Disabling Gatekeeper may also help (see: [Disabling Gatekeeper (macOS)](#disabling-gatekeeper-macos)).
4. Terminal will open. Follow the instructions and enter your Mac password.
5. After entering the password, a list of applications will appear. Find **Parallels Desktop** in the list, note the number on the left, and enter it.
6. Wait for the patch to complete, then close the terminal.

**Example of successful patch execution:**
```
Done! Enjoy using it!
```

## Troubleshooting
- **Parallels Desktop application crashes unexpectedly?**
  - Add a digital signature. See the guide: *Adding a Digital Signature*.
- **pr|_client_app application crashes?**
  - Go to the Patch folder and run `DisableLibraryValidation`.
  - Follow the instructions in the terminal.
- **Patch shows "Operation not permitted"?**
  - Terminal lacks permissions. Go to **System Settings → Privacy & Security** and add Terminal to:
    - Full Disk Access
    - App Management
  - Terminal is located in: `Applications → Utilities → Terminal`.
- **Patch shows "Read-only"?**
  - The script can’t access files in the DMG. Make sure you copied the Patch folder to the desktop and try again.
- **Parallels Desktop freezes on launch?**
  - Enable a VPN. Create a VM — Parallels will then work without VPN.
- **Black screen when starting a VM?**
  - In the running VM, go to the menu: **Actions → Reset** (equivalent to a PC reboot).
- **Other issues?**
  - See the guide: *Common Mac app installation errors*.
  - For fixes for launching files, applications, and games: Download *Auto Fix*.

## Disabling Gatekeeper (macOS)

Gatekeeper is a macOS security feature that may prevent the patch from running. To disable Gatekeeper:

1. Open the Terminal app (`Applications → Utilities → Terminal`).
2. Enter the following command and press Enter:
  ```sh
  sudo spctl --master-disable
  ```
3. Enter your Mac password if prompted.
4. Gatekeeper will now be disabled, allowing you to run apps from any source.
5. Go to settings app (`Applications → System Preferences → Security & Privacy`).
6. In the "Privacy & Security" tab, select "Allow apps downloaded from: Anywhere".

**To re-enable Gatekeeper after patching:**
```sh
sudo spctl --master-enable
```

> **Note:** Disabling Gatekeeper reduces your Mac's security. Only disable it temporarily and re-enable it after completing the patch process.

## Support
- If you found this guide helpful, consider supporting the project!
- Need installation help (paid service)?
- Need assistance? Contact: **SamFisherSpCell2005**

> **Note:** To open a link, open the document in full—do not use the preview.
