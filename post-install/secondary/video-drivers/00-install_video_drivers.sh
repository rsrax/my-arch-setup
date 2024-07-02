#!/bin/bash

log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1" >>/tmp/arch_install.log
}

# Function to install Intel drivers
install_intel_drivers() {
    log "Installing Intel graphics drivers..."
    pacman -S --noconfirm --needed mesa lib32-mesa xorg-server vulkan-intel lib32-vulkan-intel || {
        log "Error installing Intel drivers!"
        return 1
    }
}

# Function to install Nvidia drivers
install_nvidia_drivers() {
    log "Installing Nvidia drivers and related packages..."
    pacman -S --noconfirm --needed nvidia nvidia-utils lib32-nvidia-utils || {
        log "Error installing Nvidia drivers!"
        return 1
    }

    log "Installing Nvidia settings..."
    pacman -S --noconfirm nvidia-settings || {
        log "Error installing Nvidia settings!"
        return 1
    }

    log "Setting kernel parameter for Nvidia DRM..."
    sed -i 's/^GRUB_CMDLINE_LINUX_DEFAULT="/&nvidia-drm.modeset=1 /' /etc/default/grub
    grub-mkconfig -o /boot/grub/grub.cfg

    log "Adding early loading of Nvidia modules..."
    sed -i 's/^MODULES=(/&nvidia nvidia_modeset nvidia_uvm nvidia_drm /' /etc/mkinitcpio.conf
    sed -i 's/ kms / /' /etc/mkinitcpio.conf
    mkinitcpio -P

    # Copy the Nvidia hook to the appropriate directory
    log "Adding Pacman hook for Nvidia..."
    mkdir -p /etc/pacman.d/hooks
    cp ./configs/nvidia.hook /etc/pacman.d/hooks/
}

# Check if the script is running as root
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root"
    exit 1
fi

# Enable the multilib repository (needed for 32-bit libraries for Nvidia)
log "Enabling multilib repository..."
if ! grep -q "^\[multilib\]" /etc/pacman.conf; then
    echo -e "\n[multilib]\nInclude = /etc/pacman.d/mirrorlist" >>/etc/pacman.conf
else
    sed -i '/\[multilib\]/{n;s/^#Include/Include/}' /etc/pacman.conf
fi

# Update the system
log "Updating the system..."
pacman -Syu --noconfirm

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
