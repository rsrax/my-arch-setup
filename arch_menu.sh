#!/bin/bash

# Get the directory of the arch_menu.sh script
SCRIPT_DIR=$(realpath "${0%/*}")

# Change the current working directory to the script's directory
cd "$SCRIPT_DIR"

source functions.sh

# Check if .env file exists and is valid
if [ ! -f .env ]; then
    echo "Error: .env file not found! Please create it in the project root directory."
    exit 1
fi

source .env

# Check if .env values have been changed from defaults
if [[ "$ROOT_PASSWORD" == "changeme_root_password" || "$USER_NAME" == "changeme_user_name" || "$USER_PASSWORD" == "changeme_user_password" || "$HOSTNAME" == "changeme_hostname" ]]; then
    echo "Error: One or more environment variables in .env are using default values. Please update the .env file with your specific values."
    exit 1
fi

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    echo "Please run this script as root"
    exit 1
fi

# Check if SUDO_USER is set
if [ -z "$SUDO_USER" ]; then
    echo "SUDO_USER is not set. Please run this script using sudo."
    exit 1
fi

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

    is_live_usb=$(detect_live_usb)

    # Main Menu Options
    if $is_live_usb; then # If in live USB
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
        if $is_live_usb; then
            ./liveusb-setup.sh
        else
            ./post-install.sh primary
        fi
        ;;
    2)
        if ! $is_live_usb; then
            ./post-install.sh secondary
        fi
        ;;
    3)
        if ! $is_live_usb; then
            display_standalone_scripts_menu
        fi
        ;;
    4) break ;; # Exit
    *) echo "Invalid choice." ;;
    esac
done
