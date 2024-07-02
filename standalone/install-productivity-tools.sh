#!/bin/bash

# Check if the script is running as root
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root"
    exit 1
fi

# Update the system
echo "Updating the system..."
pacman -Syu --noconfirm

# Install productivity tools
echo "Installing productivity tools..."
pacman -S --noconfirm --needed \
    vlc \
    gimp \
    libreoffice-fresh \
    firefox \
    keepassxc \
    thunderbird

# Install Vesktop (instead of Discord) via Flatpak
echo "Installing Vesktop via Flatpak..."
flatpak install flathub dev.vencord.Vesktop -y

echo "Productivity tools installation complete."
