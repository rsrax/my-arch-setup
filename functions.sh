#!/bin/bash

# Function to detect if running on an installed Arch Linux system
detect_installed_arch() {
    root_device=$(findmnt -n -o SOURCE /)  # Get the source device of the root filesystem

    # Check if the root device is a block device (e.g., /dev/sda, /dev/nvme0n1)
    if [[ $root_device == /dev/* ]]; then
        return 0  # True (0) if installed Arch (root is on a block device)
    else
        return 1  # False (1) if not installed Arch (likely a live USB)
    fi
}

# Function to display a formatted menu item
display_menu_item() {
    local index=$1
    local description=$2
    echo "$index)$description"  # Display menu item with index and description
}

# Function to display a menu for standalone scripts (to be implemented later)
display_standalone_scripts_menu() {
    # ... (Implementation will be added in a later step)
}
