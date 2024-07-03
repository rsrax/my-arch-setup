#!/bin/bash

source functions.sh

# Function to log messages with timestamp
log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1" >>/tmp/arch_install.log
}

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

# Get the type of post-install tasks to run (primary or secondary)
task_type="$1"

# Execute primary post-install tasks
if [[ $task_type == "primary" ]]; then
    log "Running primary post-install tasks..."
    for module_script in post-install/primary/*; do
        if [ -x "$module_script" ]; then # Check if the script is executable
            bash "$module_script" || {
                log "Error executing $module_script"
                exit 1
            }
        fi
    done
# Execute secondary post-install tasks
elif [[ $task_type == "secondary" ]]; then
    log "Running secondary post-install tasks..."

    # --- Desktop Environment Installation ---
    while true; do
        echo "Choose a desktop environment to install:"
        display_menu_item 1 "KDE Plasma"
        display_menu_item 2 "Skip (Install manually later)"
        read -p "Enter your choice: " choice_de
        case $choice_de in
        1)
            bash post-install/secondary/desktop-environment/00-install_kde.sh || { log "Error installing KDE Plasma"; }
            break
            ;;
        2) break ;;
        *) echo "Invalid choice." ;;
        esac
    done

    # --- Video Driver Installation ---
    while true; do
        echo "Choose video drivers to install:"
        display_menu_item 1 "Intel"
        display_menu_item 2 "Nvidia"
        display_menu_item 3 "Both"
        display_menu_item 4 "Skip (Install manually later)"
        read -p "Enter your choice: " choice_drivers
        case $choice_drivers in
        1)
            bash post-install/secondary/video-drivers/00-install_video_drivers.sh "intel" || { log "Error installing Intel drivers"; }
            break
            ;;
        2)
            bash post-install/secondary/video-drivers/00-install_video_drivers.sh "nvidia" || { log "Error installing Nvidia drivers"; }
            break
            ;;
        3)
            bash post-install/secondary/video-drivers/00-install_video_drivers.sh "both" || { log "Error installing video drivers"; }
            break
            ;;
        4) break ;;
        *) echo "Invalid choice." ;;
        esac
    done

    # --- Additional Applications Installation ---
    while true; do
        echo "Install additional applications?"
        display_menu_item 1 "Yes"
        display_menu_item 2 "No"
        read -p "Enter your choice: " choice_apps
        case $choice_apps in
        1)
            bash post-install/secondary/additional-applications/00-install_additional_applications.sh || { log "Error installing additional applications"; }
            break
            ;;
        2) break ;;
        *) echo "Invalid choice." ;;
        esac
    done

else
    echo "Invalid task type. Please specify 'primary' or 'secondary'."
    exit 1
fi

# Confirm reboot (reuse from liveusb modules)
./liveusb/08-confirm_reboot.sh
