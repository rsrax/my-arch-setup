#!/bin/bash

source functions.sh

while true; do
    clear
    echo -e "\e[34m
     __  __      _              _
    |  \/  |    | |            | |
    | \  / | ___| |_ __ _ _ __ | |_
    | |\/| |/ _ \ __/ _\` | '_ \| __|
    | |  | |  __/ || (_| | |_) | |_
    |_|  |_|\___|\__\__,_| .__/ \__|
                        | |
                        |_|      \e[0m"
    echo -e "\e[96m
    Welcome to Project Greyrax\e[0m"
    echo -e "\e[33m
    Your Arch Linux Installation Companion
    \e[0m-------------------------------------"

    is_installed_arch=$(detect_installed_arch)

    # Main Menu Options
    if ! $is_installed_arch; then # If in live USB
        display_menu_item 1 "Live USB Setup"
    else
        display_menu_item 1 "Primary Post-Install"
        display_menu_item 2 "Secondary Post-Install"
        display_menu_item 3 "Standalone Scripts"
    fi
    display_menu_item 4 "Exit"

    # Get user input
    read -p "Enter your choice: " choice

    # Execute based on choice
    case $choice in
    1)
        if ! $is_installed_arch; then
            bash ./liveusb-setup.sh
        else
            bash ./post-install.sh primary
        fi
        ;;
    2)
        if $is_installed_arch; then # If installed Arch
            bash ./post-install.sh secondary
        fi
        ;;
    3)
        if $is_installed_arch; then
            display_standalone_scripts_menu
        fi
        ;;
    4) break ;; # Exit
    *) echo "Invalid choice." ;;
    esac
done
