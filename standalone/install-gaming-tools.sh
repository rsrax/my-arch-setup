#!/bin/bash

log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1" >>/tmp/arch_install.log
}

# Check if the script is running as root
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root"
    exit 1
fi

# Update the system
log "Updating the system..."
pacman -Syu --noconfirm || {
    log "Error updating the system"
    exit 1
}

# Install gaming tools and applications
log "Installing gaming tools and applications..."
pacman -S --noconfirm --needed \
    steam \
    lutris \
    wine \
    mangohud \
    goverlay \
    gamemode \
    moonlight-qt \
    sunshine || {
    log "Error installing gaming tools and applications"
    exit 1
}

# Install Proton GE Custom and asf from AUR
log "Installing Proton GE Custom and asf from AUR..."
sudo -u $SUDO_USER yay -S proton-ge-custom asf asf-ui-git --noconfirm || {
    log "Error installing Proton GE Custom or asf"
    exit 1
}

log "Gaming tools installation complete."
