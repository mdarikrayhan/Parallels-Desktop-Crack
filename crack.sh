#!/bin/bash


COLOR_INFO='\e[0;34m'
COLOR_ERR='\e[0;35m'
COLOR_VERSION='\e[0;36m'
COLOR_TITLE='\e[0;33m'
COLOR_SUCCESS='\e[0;32m'
NOCOLOR='\e[0m'
PDFM_VER="20.4.0-55980"

printf "${COLOR_TITLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NOCOLOR}\n"
printf "${COLOR_VERSION}Developer: QiuChenly / QiuChengLuoYe${NOCOLOR}\n"
printf "${COLOR_VERSION}Telegram: https://t.me/qiuchenlymac${NOCOLOR}\n"
printf "${COLOR_VERSION}TG Chat Channel: https://t.me/+VvqTr-2EFaZhYzA1${NOCOLOR}\n"
printf "${COLOR_VERSION}This is the official Parallels Desktop full-link domestic self-developed HarmonyOS: Hongmeng Xinghe Edition VM for Huawei. If anyone criticizes Huawei again, try it? Is Apple the only one in the PC market? Look at the lithography technology abandoned by Americans, it all falls on Huawei's face! Sorry, brother! I'll secretly ask ASML to sell you two more EUVs for your Kirin! It's okay, since you call me brother, I'll use 20nm EUV a few more times to reach 3nm international leading level and achieve overtaking on a curve, isn't that great? Isn't this ridiculous?${NOCOLOR}\n"
printf "${COLOR_TITLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NOCOLOR}\n"

printf "${COLOR_INFO}[*] The currently recommended version to install is: https://download.parallels.com/desktop/v20/${PDFM_VER}/ParallelsDesktop-${PDFM_VER}.dmg${NOCOLOR}\n"

ParaHome='/Applications/Parallels Desktop.app'
DYLIB="./CoreInject.dylib"

[ ! -f "$DYLIB" ] && {
    printf "${COLOR_ERR}[x] Cannot find $DYLIB file${NOCOLOR}\n"
    exit 1
}
[ ! -f "./GenShineImpactStarter" ] && {
    printf "${COLOR_ERR}[x] Cannot find GenShineImpactStarter tool${NOCOLOR}\n"
    exit 1
}
[ ! -d "$ParaHome" ] && {
    printf "${COLOR_ERR}[x] Cannot find Parallels Desktop application${NOCOLOR}\n"
    exit 1
}

if pgrep -x "prl_disp_service" &>/dev/null; then
    printf "${COLOR_INFO}[*] Stopping Parallels Desktop main program...${NOCOLOR}\n"
    pkill -9 prl_client_app &>/dev/null
    "${ParaHome}/Contents/MacOS/Parallels Service" service_stop &>/dev/null
    sleep 1
    launchctl stop /Library/LaunchDaemons/com.parallels.desktop.launchdaemon.plist &>/dev/null
    sleep 1
    pkill -9 prl_disp_service &>/dev/null
    sleep 1
    rm -f "/var/run/prl_*"
fi

xattr -cr "$DYLIB" ./* &>/dev/null

sudo codesign -f -s - --timestamp=none --all-architectures "$DYLIB"
sudo cp "$DYLIB" "${ParaHome}/Contents/Frameworks/CoreInject.dylib"

chmod +x ./GenShineImpactStarter

patch_file() {
    local file="$1"
    printf "${COLOR_INFO}[*] Processing file: $(basename "$file")${NOCOLOR}\n"

    # Check if file exists
    if [ ! -f "$file" ]; then
        printf "${COLOR_ERR}[x] File does not exist: $file${NOCOLOR}\n"
        return 1
    fi

    # Create backup file
    if [ ! -f "${file}_backup" ]; then
        if ! cp "$file" "${file}_backup"; then
            printf "${COLOR_ERR}[x] Failed to create backup file: ${file}_backup${NOCOLOR}\n"
            return 1
        fi
    fi

    # Restore original file
    if ! cp "${file}_backup" "$file"; then
        printf "${COLOR_ERR}[x] Failed to restore original file: $file${NOCOLOR}\n"
        return 1
    fi

    # Perform injection
    if ! ./GenShineImpactStarter insert "@rpath/CoreInject.dylib" "${file}_backup" "$file" &>/dev/null; then
        printf "${COLOR_ERR}[x] Injection failed: $(basename "$file")${NOCOLOR}\n"
        return 1
    fi

    # Re-sign
    if ! sudo codesign -fs - --entitlements './VM.entitlements' "$file"; then
        printf "${COLOR_ERR}[x] Code signing failed: $(basename "$file")${NOCOLOR}\n"
        return 1
    fi

    printf "${COLOR_SUCCESS}[✓] File processed successfully: $(basename "$file")${NOCOLOR}\n"
    return 0
}

# Process each file
if ! patch_file "$ParaHome/Contents/MacOS/Parallels Service.app/Contents/MacOS/prl_disp_service"; then
    printf "${COLOR_ERR}[x] Failed to process prl_disp_service, exiting script${NOCOLOR}\n"
    exit 1
fi

if ! patch_file "$ParaHome/Contents/MacOS/Parallels VM.app/Contents/MacOS/prl_vm_app"; then
    printf "${COLOR_ERR}[x] Failed to process prl_vm_app, exiting script${NOCOLOR}\n"
    exit 1
fi

if ! patch_file "$ParaHome/Contents/MacOS/prl_client_app"; then
    printf "${COLOR_ERR}[x] Failed to process prl_client_app, exiting script${NOCOLOR}\n"
    exit 1
fi

license_file="/Library/Preferences/Parallels/licenses.json"
[ -f "$license_file" ] && {
    chflags -R 0 "$license_file"
    rm -f "$license_file"
}

if ! pgrep -x "prl_disp_service" &>/dev/null; then
    printf "${COLOR_INFO}[*] Starting Parallels Service ...${NOCOLOR}\n"
    "$ParaHome/Contents/MacOS/Parallels Service" service_start &>/dev/null
    for ((i = 0; i < 10; ++i)); do
        pgrep -x "prl_disp_service" &>/dev/null && break
        sleep 2
    done
    ! pgrep -x "prl_disp_service" &>/dev/null && printf "${COLOR_ERR}[x] Failed to start Service.${NOCOLOR}\n"
fi

"$ParaHome/Contents/MacOS/prlsrvctl" web-portal signout &>/dev/null
"$ParaHome/Contents/MacOS/prlsrvctl" set --cep off &>/dev/null
"$ParaHome/Contents/MacOS/prlsrvctl" set --allow-attach-screenshots off &>/dev/null

printf "${COLOR_SUCCESS}[*] Crack completed!${NOCOLOR}\n"
