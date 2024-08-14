#!/bin/bash

log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1" >>./arch_install.log
}

# Check if the script is running as root
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root"
    exit 1
fi

# Check if yay is already installed
if ! command -v yay &>/dev/null; then
    # Install yay
    log "Yay not found. Installing yay..."
    sudo pacman -S --needed git base-devel || {
        log "Error installing dependencies for Yay"
    }
    sudo -u $SUDO_USER git clone https://aur.archlinux.org/yay.git || {
        log "Error cloning Yay repository"
    }
    sudo chmod -R 777 yay || {
        log "Error changing permissions for Yay directory"
    }
    cd yay || {
        log "Error navigating to Yay directory"
    }
    sudo -u $SUDO_USER makepkg -si || {
        log "Error building and installing Yay"
    }
    cd ..
    sudo rm -rf yay
else
    log "Yay is already installed. Skipping installation."
fi
