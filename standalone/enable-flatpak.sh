#!/bin/bash

log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1" >>/tmp/arch_install.log
}

# Check if flatpak is already installed
if ! command -v flatpak &>/dev/null; then
    # Enable Flatpak support
    log "Enabling Flatpak support..."
    pacman -S --noconfirm flatpak || {
        log "Error installing Flatpak"
        exit 1
    }
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo || {
        log "Error adding Flathub remote"
        exit 1
    }
    log "Flatpak support enabled."
else
    log "Flatpak is already installed. Skipping."
fi
