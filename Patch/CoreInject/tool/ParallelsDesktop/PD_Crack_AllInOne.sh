#!/bin/bash

COLOR_INFO='\e[0;34m'
COLOR_ERR='\e[0;35m'
COLOR_VERSION='\e[0;36m'
COLOR_TITLE='\e[0;33m'
COLOR_SUCCESS='\e[0;32m'
NOCOLOR='\e[0m'
PDFM_VER="20.4.0-55980"

printf "${COLOR_TITLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NOCOLOR}\n"
printf "${COLOR_VERSION}Developer: QiuChenly / 秋城落叶${NOCOLOR}\n"
printf "${COLOR_VERSION}Telegram: https://t.me/qiuchenlymac${NOCOLOR}\n"
printf "${COLOR_VERSION}TG聊天频道: https://t.me/+VvqTr-2EFaZhYzA1${NOCOLOR}\n"
printf "${COLOR_VERSION}这是PD官方为华为专门开发的全链路国产自研 HarmonyOS : 鸿蒙星河版 虚拟机, 再有人黑我华为试试？这PC市场就你苹果一个人做奥？你看你美国人淘汰的那个光刻机技术都崩华为脸上了😡! 哎哟兄弟，真对不住奥！我让ASML偷偷多卖两台EUV给你刻麒麟！没事你都叫我兄弟了，我拿20nm EUV多刻几次达到3nm国际领先水平实现弯道超车不就完了？你说这扯不扯。${NOCOLOR}\n"
printf "${COLOR_TITLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NOCOLOR}\n"

printf "${COLOR_INFO}[*] 当前推荐安装的版本是: https://download.parallels.com/desktop/v20/${PDFM_VER}/ParallelsDesktop-${PDFM_VER}.dmg${NOCOLOR}\n"

ParaHome='/Applications/Parallels Desktop.app'
DYLIB="../CoreInject.dylib"

[ ! -f "./$DYLIB" ] && {
    printf "${COLOR_ERR}[x] 找不到 $DYLIB 文件${NOCOLOR}\n"
    exit 1
}
[ ! -f "../GenShineImpactStarter" ] && {
    printf "${COLOR_ERR}[x] 找不到 GenShineImpactStarter 工具${NOCOLOR}\n"
    exit 1
}
[ ! -d "$ParaHome" ] && {
    printf "${COLOR_ERR}[x] 找不到 Parallels Desktop 应用${NOCOLOR}\n"
    exit 1
}

if pgrep -x "prl_disp_service" &>/dev/null; then
    printf "${COLOR_INFO}[*] 正在停止 Parallels Desktop 主程序...${NOCOLOR}\n"
    pkill -9 prl_client_app &>/dev/null
    "${ParaHome}/Contents/MacOS/Parallels Service" service_stop &>/dev/null
    sleep 1
    launchctl stop /Library/LaunchDaemons/com.parallels.desktop.launchdaemon.plist &>/dev/null
    sleep 1
    pkill -9 prl_disp_service &>/dev/null
    sleep 1
    rm -f "/var/run/prl_*"
fi

xattr -cr "./$DYLIB" ./* &>/dev/null

sudo codesign -f -s - --timestamp=none --all-architectures "./$DYLIB"
sudo cp "./$DYLIB" "${ParaHome}/Contents/Frameworks/$DYLIB"

chmod +x ../GenShineImpactStarter

patch_file() {
    local file="$1"
    printf "${COLOR_INFO}[*] 处理文件: $(basename "$file")${NOCOLOR}\n"

    # 检查文件是否存在
    if [ ! -f "$file" ]; then
        printf "${COLOR_ERR}[x] 文件不存在: $file${NOCOLOR}\n"
        return 1
    fi

    # 创建备份文件
    if [ ! -f "${file}_backup" ]; then
        if ! cp "$file" "${file}_backup"; then
            printf "${COLOR_ERR}[x] 创建备份文件失败: ${file}_backup${NOCOLOR}\n"
            return 1
        fi
    fi

    # 恢复原文件
    if ! cp "${file}_backup" "$file"; then
        printf "${COLOR_ERR}[x] 恢复原文件失败: $file${NOCOLOR}\n"
        return 1
    fi

    # 执行注入操作
    if ! ../GenShineImpactStarter insert "@rpath/$DYLIB" "${file}_backup" "$file" &>/dev/null; then
        printf "${COLOR_ERR}[x] 注入操作失败: $(basename "$file")${NOCOLOR}\n"
        return 1
    fi

    # 重新签名
    if ! sudo codesign -fs - --entitlements './VM.entitlements' "$file"; then
        printf "${COLOR_ERR}[x] 代码签名失败: $(basename "$file")${NOCOLOR}\n"
        return 1
    fi

    printf "${COLOR_SUCCESS}[✓] 文件处理成功: $(basename "$file")${NOCOLOR}\n"
    return 0
}

# 处理各个文件
if ! patch_file "$ParaHome/Contents/MacOS/Parallels Service.app/Contents/MacOS/prl_disp_service"; then
    printf "${COLOR_ERR}[x] 处理 prl_disp_service 失败，脚本退出${NOCOLOR}\n"
    exit 1
fi

if ! patch_file "$ParaHome/Contents/MacOS/Parallels VM.app/Contents/MacOS/prl_vm_app"; then
    printf "${COLOR_ERR}[x] 处理 prl_vm_app 失败，脚本退出${NOCOLOR}\n"
    exit 1
fi

if ! patch_file "$ParaHome/Contents/MacOS/prl_client_app"; then
    printf "${COLOR_ERR}[x] 处理 prl_client_app 失败，脚本退出${NOCOLOR}\n"
    exit 1
fi

license_file="/Library/Preferences/Parallels/licenses.json"
[ -f "$license_file" ] && {
    chflags -R 0 "$license_file"
    rm -f "$license_file"
}

if ! pgrep -x "prl_disp_service" &>/dev/null; then
    printf "${COLOR_INFO}[*] 正在启动 Parallels Service ...${NOCOLOR}\n"
    "$ParaHome/Contents/MacOS/Parallels Service" service_start &>/dev/null
    for ((i = 0; i < 10; ++i)); do
        pgrep -x "prl_disp_service" &>/dev/null && break
        sleep 2
    done
    ! pgrep -x "prl_disp_service" &>/dev/null && printf "${COLOR_ERR}[x] 启动 Service 失败.${NOCOLOR}\n"
fi

"$ParaHome/Contents/MacOS/prlsrvctl" web-portal signout &>/dev/null
"$ParaHome/Contents/MacOS/prlsrvctl" set --cep off &>/dev/null
"$ParaHome/Contents/MacOS/prlsrvctl" set --allow-attach-screenshots off &>/dev/null

printf "${COLOR_SUCCESS}[*] 破解完成！${NOCOLOR}\n"
