#!/bin/bash

# Pacstrap to install base system
echo "Installing base system with pacstrap..."
pacstrap -K /mnt base base-devel linux linux-firmware intel-ucode git btrfs-progs grub efibootmgr grub-btrfs inotify-tools timeshift vim nano networkmanager pipewire pipewire-alsa pipewire-pulse pipewire-jack wireplumber reflector openssh man sudo

echo "Base system installation complete."
