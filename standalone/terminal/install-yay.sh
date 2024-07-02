#!/bin/bash

log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1" >>/tmp/arch_install.log
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
        exit 1
    }
    sudo -u $SUDO_USER git clone https://aur.archlinux.org/yay.git || {
        log "Error cloning Yay repository"
        exit 1
    }
    cd yay || {
        log "Error navigating to Yay directory"
        exit 1
    }
    sudo -u $SUDO_USER makepkg -si || {
        log "Error building and installing Yay"
        exit 1
    }
    cd ..
    rm -rf yay
else
    log "Yay is already installed. Skipping installation."
fi
