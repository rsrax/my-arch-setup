#!/bin/bash

# Check if the script is running as root
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root"
    exit 1
fi

# Update the system
echo "Updating the system..."
pacman -Syu --noconfirm

# Install gaming tools and applications
echo "Installing gaming tools and applications..."
pacman -S --noconfirm --needed \
    steam \
    lutris \
    wine \
    mangohud \
    goverlay \
    gamemode

# Install Proton GE Custom from AUR
echo "Installing Proton GE Custom from AUR..."
sudo -u $SUDO_USER yay -S proton-ge-custom --noconfirm

echo "Gaming tools installation complete."
