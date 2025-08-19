#!/bin/bash
clear
parent_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
cd "$parent_path"
echo -e ""
echo -e "Type the password for your Mac that you use when you log in."
echo -e "The password will not be visible when you type it."
echo -e "Just type it and press the Enter key."
echo -e ""
set -euo pipefail
cd ./CoreInject/NativeInject/
chmod +x ./InjectLib
sudo xattr -c -r ./InjectLib
codesign -fs - ./InjectLib
clear
sudo ./InjectLib