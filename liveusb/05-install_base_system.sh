#!/bin/bash

log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1" >>./arch_install.log
}

# Pacstrap to install base system
log "Installing base system with pacstrap..."
pacstrap -K /mnt base base-devel linux linux-firmware intel-ucode git btrfs-progs grub efibootmgr grub-btrfs inotify-tools timeshift vim nano networkmanager pipewire pipewire-alsa pipewire-pulse pipewire-jack wireplumber reflector openssh man sudo || {
    log "Error installing base system!"
    exit 1
}

log "Base system installation complete."
