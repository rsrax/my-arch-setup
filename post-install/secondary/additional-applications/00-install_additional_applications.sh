#!/bin/bash

log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1" >>/tmp/arch_install.log
}

# Check if the script is running as root
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root"
    exit 1
fi

# Check if SUDO_USER is set
if [ -z "$SUDO_USER" ]; then
    echo "SUDO_USER is not set. Please run this script using sudo."
    exit 1
fi

# Update the system
log "Updating the system..."
sudo pacman -Syu --noconfirm || {
    log "Error updating the system"
}

# Enable Flatpak support
log "Enabling Flatpak support..."
./standalone/enable-flatpak.sh || { log "Error enabling Flatpak"; }

# Install terminal tools
./standalone/terminal/install-terminal-tools.sh || { log "Error installing terminal tools"; }

# Install productivity tools
./standalone/install-productivity-tools.sh || { log "Error installing productivity tools"; }

# Install gaming tools
./standalone/install-gaming-tools.sh || { log "Error installing gaming tools"; }

log "Additional applications installation complete."
