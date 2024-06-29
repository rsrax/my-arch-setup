#!/bin/bash

# Check if the script is running as root
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root"
    exit 1
fi

# Enable the multilib repository
echo "Enabling multilib repository..."
if ! grep -q "^\[multilib\]" /etc/pacman.conf; then
    echo -e "\n[multilib]\nInclude = /etc/pacman.d/mirrorlist" >> /etc/pacman.conf
else
    sed -i '/\[multilib\]/{n;s/^#Include/Include/}' /etc/pacman.conf
fi

# Update the system
echo "Updating the system..."
pacman -Syu --noconfirm

# Install Intel graphics drivers
echo "Installing Intel graphics drivers..."
pacman -S --noconfirm --needed \
    mesa \
    lib32-mesa \
    xorg-server \
    vulkan-intel \
    lib32-vulkan-intel

# Install Nvidia drivers and related packages
echo "Installing Nvidia drivers and related packages..."
pacman -S --noconfirm --needed \
    nvidia-dkms \
    nvidia-utils \
    lib32-nvidia-utils

# Install Nvidia settings
echo "Installing Nvidia settings..."
pacman -S --noconfirm nvidia-settings

# Set kernel parameter for Nvidia DRM
echo "Setting kernel parameter for Nvidia DRM..."
sed -i 's/^GRUB_CMDLINE_LINUX_DEFAULT="/&nvidia-drm.modeset=1 /' /etc/default/grub
grub-mkconfig -o /boot/grub/grub.cfg

# Add early loading of Nvidia modules
echo "Adding early loading of Nvidia modules..."
sed -i 's/^MODULES=(/&nvidia nvidia_modeset nvidia_uvm nvidia_drm /' /etc/mkinitcpio.conf
sed -i 's/ kms / /' /etc/mkinitcpio.conf
mkinitcpio -P

# Copy the Nvidia hook to the appropriate directory
echo "Adding Pacman hook for Nvidia..."
mkdir -p /etc/pacman.d/hooks
cp ./configs/nvidia.hook /etc/pacman.d/hooks/

echo "Intel and Nvidia drivers installation complete."

# Confirm reboot
read -p "The setup is complete. Do you want to reboot now? (y/n): " confirm_reboot

if [[ $confirm_reboot == "y" || $confirm_reboot == "Y" ]]; then
    echo "Rebooting the system..."
    reboot
else
    echo "Reboot canceled. You can manually reboot later."
fi
