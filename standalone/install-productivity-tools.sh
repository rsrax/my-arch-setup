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

# Install productivity tools
log "Installing productivity tools..."
pacman -S --noconfirm --needed \
    vlc \
    gimp \
    libreoffice-fresh \
    firefox \
    keepassxc \
    thunderbird \
    github-cli || {
    log "Error installing productivity tools"
    exit 1
}

# Install Visual Studio Code Insiders from AUR
log "Installing Visual Studio Code Insiders from AUR..."
sudo -u $SUDO_USER yay -S visual-studio-code-bin --noconfirm || {
    log "Error installing Visual Studio Code Insiders"
    exit 1
}

# Install Vesktop (instead of Discord) via Flatpak
log "Installing Vesktop via Flatpak..."
flatpak install flathub dev.vencord.Vesktop -y || {
    log "Error installing Vesktop"
    exit 1
}

log "Productivity tools installation complete."
