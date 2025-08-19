import os
import plistlib

def getAppMainExecutable(app_base):
    """Read CFBundleExecutable from Contents/Info.plist"""
    with open(f"{app_base}/Contents/Info.plist", "rb") as f:
        app_info = plistlib.load(f)
        return app_info["CFBundleExecutable"]


def getBundleID(app_base):
    """Get BundleID"""
    with open(f"{app_base}/Contents/Info.plist", "rb") as f:
        app_info = plistlib.load(f)
        return app_info["CFBundleIdentifier"]
