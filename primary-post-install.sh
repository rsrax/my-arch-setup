#!/bin/bash

# Check if the script is running as root
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root"
    exit 1
fi

# Check if SUDO_USER is set
if [ -z "$SUDO_USER" ]; then
    echo "SUDO_USER is not set. Please run this script using sudo."
    exit 1
fi

# Update the system
echo "Updating the system..."
pacman -Syu --noconfirm

# Enable and start the time synchronization service
echo "Enabling time synchronization service..."
timedatectl set-ntp true

# Edit grub-btrfsd service to enable automatic grub entries update each time a snapshot is created
echo "Configuring grub-btrfsd service..."
sed -i 's|^ExecStart=.*|ExecStart=/usr/bin/grub-btrfsd --syslog --timeshift-auto|' /etc/systemd/system/grub-btrfsd.service

# Enable grub-btrfsd service to run on boot
echo "Enabling grub-btrfsd service..."
sudo systemctl enable grub-btrfsd

# Install yay using the install-yay.sh script
echo "Running install-yay.sh script..."
./scripts/install-yay.sh

# Install timeshift-autosnap
echo "Installing timeshift-autosnap..."
sudo -u $SUDO_USER yay -S timeshift-autosnap --noconfirm

echo "Primary post-installation setup complete."

# Confirm reboot
read -p "The setup is complete. Do you want to reboot now? (y/n): " confirm_reboot

if [[ $confirm_reboot == "y" || $confirm_reboot == "Y" ]]; then
    echo "Rebooting the system..."
    reboot
else
    echo "Reboot canceled. You can manually reboot later."
fi
