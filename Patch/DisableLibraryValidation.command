#!/bin/bash
clear
BLUE="\033[0;34m"  
RED="\033[0;31m"  
clear
echo -e ""
echo -e "Введите пароль от вашего Mac, который вы используете при входе в систему."
echo -e "При вводе пароль не будет отображаться."
echo -e "Просто введите его и нажмите клавишу Enter."
echo -e ""
echo -e "Type the password for your Mac that you use when you log in."
echo -e "The password will not be visible when you type it."
echo -e "Just type it and press the Enter key."
echo -e ""
sudo defaults write /Library/Preferences/com.apple.security.libraryvalidation.plist DisableLibraryValidation -bool true
echo -e "${BLUE}This window can be closed!"
echo -e ""
echo -e "${RED}Данное окно можно закрыть!"
echo -e ""