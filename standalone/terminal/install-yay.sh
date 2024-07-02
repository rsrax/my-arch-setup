#!/bin/bash

# Check if the script is running as root
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root"
    exit 1
fi

# Install yay
echo "Installing yay..."
sudo pacman -S --needed git base-devel
sudo -u $SUDO_USER git clone https://aur.archlinux.org/yay.git
cd yay
sudo -u $SUDO_USER makepkg -si
cd ..
rm -rf yay

echo "yay installation complete."
