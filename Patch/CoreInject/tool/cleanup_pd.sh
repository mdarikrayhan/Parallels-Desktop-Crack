#!/bin/bash
set -e

echo "[*] 开始清理 Parallels Desktop..."

if pgrep -x "prl_client_app" &>/dev/null; then
    pkill -f "prl_client_app" 2>/dev/null || true
fi

if pgrep -x "prl_disp_service" &>/dev/null; then
    pkill -f "prl_disp_service" 2>/dev/null || true
    
    if [ -f "/Library/LaunchDaemons/com.parallels.desktop.launchdaemon.plist" ]; then
        launchctl stop /Library/LaunchDaemons/com.parallels.desktop.launchdaemon.plist 2>/dev/null || true
    fi
    
    echo "[*] 清理 /var/run 目录下的 prl_ 文件..."
    if ls /var/run/prl_* 1>/dev/null 2>&1; then
        rm -f /var/run/prl_*
    fi
fi

echo "[*] Parallels Desktop 主程序已停止"

license_file="/Library/Preferences/Parallels/licenses.json"
if [ -f "$license_file" ]; then
    echo "[*] 清理许可证文件..."
    chflags -R 0 "$license_file" 2>/dev/null || true
    rm -f "$license_file"
    echo "[*] 许可证文件已删除"
fi

exit 0