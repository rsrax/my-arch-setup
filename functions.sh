#!/bin/bash

# Function to detect if running on an installed Arch Linux system
detect_installed_arch() {
    root_device=$(findmnt -n -o SOURCE /) # Get the source device of the root filesystem

    # Check if the root device is a block device (e.g., /dev/sda, /dev/nvme0n1)
    if [[ $root_device == /dev/* ]]; then
        return 0 # True (0) if installed Arch (root is on a block device)
    else
        return 1 # False (1) if not installed Arch (likely a live USB)
    fi
}

# Function to display a formatted menu item
display_menu_item() {
    local index=$1
    local description=$2
    echo "$index)$description" # Display menu item with index and description
}

# Function to display a menu for standalone scripts
display_standalone_scripts_menu() {
    while true; do
        clear
        echo "Standalone Scripts Menu"
        echo "-----------------------"

        # List standalone scripts (you'll need to update this based on your actual scripts)
        display_menu_item 1 "Install Yay"
        display_menu_item 2 "Install Terminal Tools"
        display_menu_item 3 "Enable Flatpak"
        display_menu_item 4 "Install Gaming Tools"
        display_menu_item 5 "Install Productivity Tools"
        display_menu_item 6 "Back to Main Menu"

        read -p "Enter your choice: " choice

        case $choice in
        1) bash standalone/terminal/install-yay.sh || { log "Error installing Yay"; } ;;
        2) bash standalone/terminal/install-terminal-tools.sh || { log "Error installing Terminal Tools"; } ;;
        3) bash standalone/enable-flatpak.sh || { log "Error enabling Flatpak"; } ;;
        4) bash standalone/install-gaming-tools.sh || { log "Error installing Gaming Tools"; } ;;
        5) bash standalone/install-productivity-tools.sh || { log "Error installing Productivity Tools"; } ;;
        6) break ;;
        *) echo "Invalid choice." ;;
        esac
        read -p "Press Enter to continue..."
    done
}
