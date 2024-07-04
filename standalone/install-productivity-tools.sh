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
sudo pacman -Syu --noconfirm || {
    log "Error updating the system"
}

# Install productivity tools
log "Installing productivity tools..."
sudo pacman -S --noconfirm --needed \
    vlc \
    gimp \
    libreoffice-fresh \
    firefox \
    keepassxc \
    thunderbird \
    github-cli \
    qbittorrent \
    weechat \
    spotify-launcher || {
    log "Error installing productivity tools"
}

# Install Visual Studio Code Insiders from AUR
log "Installing Visual Studio Code Insiders from AUR..."
sudo -u $SUDO_USER yay -S visual-studio-code-insiders-bin spicetify-cli --noconfirm || {
    log "Error installing Visual Studio Code Insiders"
}

log "Productivity tools installation complete."
