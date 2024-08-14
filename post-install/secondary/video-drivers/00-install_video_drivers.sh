#!/bin/bash

log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1" >>./arch_install.log
}

# Function to install Intel drivers
install_intel_drivers() {
    log "Installing Intel graphics drivers..."
    sudo pacman -S --noconfirm --needed mesa lib32-mesa xorg-server vulkan-intel lib32-vulkan-intel || {
        log "Error installing Intel drivers!"
    }
}

# Function to install Nvidia drivers
install_nvidia_drivers() {
    log "Installing Nvidia drivers and related packages..."
    sudo pacman -S --noconfirm --needed nvidia nvidia-utils lib32-nvidia-utils || {
        log "Error installing Nvidia drivers!"
    }

    log "Installing Nvidia settings..."
    sudo pacman -S --noconfirm nvidia-settings || {
        log "Error installing Nvidia settings!"
    }

    log "Setting kernel parameter for Nvidia DRM..."
    sudo sed -i 's/^GRUB_CMDLINE_LINUX_DEFAULT="/&nvidia-drm.modeset=1 /' /etc/default/grub
    sudo grub-mkconfig -o /boot/grub/grub.cfg

    log "Adding early loading of Nvidia modules..."
    sudo sed -i 's/^MODULES=(/&nvidia nvidia_modeset nvidia_uvm nvidia_drm /' /etc/mkinitcpio.conf
    sudo sed -i 's/ kms / /' /etc/mkinitcpio.conf
    sudo mkinitcpio -P

    # Copy the Nvidia hook to the appropriate directory
    log "Adding Pacman hook for Nvidia..."
    sudo mkdir -p /etc/pacman.d/hooks
    sudo cp ./configs/nvidia.hook /etc/pacman.d/hooks/
}

# Check if the script is running as root
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root"
    exit 1
fi

# Enable the multilib repository (needed for 32-bit libraries for Nvidia)
log "Enabling multilib repository..."
if ! grep -q "^\[multilib\]" /etc/pacman.conf; then
    sudo echo -e "\n[multilib]\nInclude = /etc/pacman.d/mirrorlist" >>/etc/pacman.conf
else
    sudo sed -i '/\[multilib\]/{n;s/^#Include/Include/}' /etc/pacman.conf
fi

# Update the system
log "Updating the system..."
sudo pacman -Syu --noconfirm

# Determine which drivers to install based on the user's choice
driver_choice="$1" # Get the driver choice from the argument

case $driver_choice in
"intel")
    install_intel_drivers
    ;;
"nvidia")
    install_nvidia_drivers
    ;;
"both")
    install_intel_drivers
    install_nvidia_drivers
    ;;
*)
    log "Invalid driver choice. Please choose 'intel', 'nvidia', or 'both'."
    exit 1
    ;;
esac

log "Video driver installation complete."

# Confirm reboot
read -p "The setup is complete. Do you want to reboot now? (y/n): " confirm_reboot

if [[ $confirm_reboot == "y" || $confirm_reboot == "Y" ]]; then
    echo "Rebooting the system..."
    reboot
else
    echo "Reboot canceled. You can manually reboot later."
fi
