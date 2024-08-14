#!/bin/bash

log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1" >>./arch_install.log
}

# Check if the script is running as root
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root"
    exit 1
fi

# Update the system
log "Updating the system..."
sudo pacman -Syu --noconfirm || {
    log "Error updating the system"
}

# Install gaming tools and applications
log "Installing gaming tools and applications..."
sudo pacman -S --noconfirm --needed \
    steam \
    lutris \
    wine \
    mangohud \
    goverlay \
    gamemode || {
    log "Error installing gaming tools and applications"
}

# Install Proton GE Custom and asf from AUR
log "Installing Proton GE Custom and asf from AUR..."
sudo -u $SUDO_USER yay -S vesktop-bin heroic-games-launcher-bin proton-ge-custom asf asf-ui-git moonlight-qt sunshine --noconfirm --needed || {
    log "Error installing Proton GE Custom, asf, moonlight-qt, and sunshine"
}

log "Gaming tools installation complete."
