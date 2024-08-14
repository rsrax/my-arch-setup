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

# Install productivity tools
log "Installing productivity tools..."
yay -Sy --noconfirm --needed \
    vlc \
    gimp \
    libreoffice-fresh \
    firefox \
    keepassxc \
    thunderbird \
    github-cli \
    qbittorrent \
    hexchat \
    spotify-launcher \
    visual-studio-code-insiders-bin \
    spicetify-cli || {
    log "Error installing productivity tools"
}

log "Productivity tools installation complete."
