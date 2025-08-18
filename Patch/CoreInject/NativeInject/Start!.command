set -euo pipefail
cd "$(dirname "$0")" || exit 1

chmod +x ./InjectLib
xattr -cr ./InjectLib
codesign -fs - ./InjectLib
sudo ./InjectLib