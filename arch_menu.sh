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
    if ! $is_installed_arch; then  # If NOT installed Arch (i.e., it's a live USB)
        display_menu_item 1 "Live USB Setup"
    else
        display_menu_item 1 "Primary Post-Install"
        display_menu_item 2 "Secondary Post-Install"
    fi
    display_menu_item 3 "Standalone Scripts"
    display_menu_item 4 "Exit"

    # Get user input
    read -p "Enter your choice: " choice

    # Execute based on choice
    case $choice in
        1)  if $is_live_usb; then
                ./liveusb-setup.sh
            else
                ./primary-post-install.sh
            fi
            ;;
        2)  if ! $is_live_usb; then
                ./secondary-post-install/install-de-and-dm.sh
            fi
            ;;
        3) # Display standalone scripts menu
            ;;
        4) break ;;  # Exit
        *) echo "Invalid choice." ;;
    esac
done
