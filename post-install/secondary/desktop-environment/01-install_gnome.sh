#!/bin/bash

log() {
	echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1" >>./arch_install.log
}

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
log "Updating the system..."
pacman -Syu --noconfirm || {
	log "Error updating the system"
	exit 1
}

# Install GNOME and related packages
log "Installing GNOME and related applications..."
pacman -S --noconfirm --needed \
	gnome \
	gnome-extra || {
	log "Error installing GNOME packages"
	exit 1
}

# Install and enable GDM (GNOME Display Manager)
log "Installing and enabling GDM..."
pacman -S --noconfirm --needed gdm || {
	log "Error installing GDM"
	exit 1
}
systemctl enable gdm || {
	log "Error enabling GDM"
	exit 1
}

log "GNOME and GDM installation complete."

# Confirm reboot
read -p "The setup is complete. Do you want to reboot now? (y/n): " confirm_reboot

if [[ $confirm_reboot == "y" || $confirm_reboot == "Y" ]]; then
	log "Rebooting the system..."
	reboot
else
	log "Reboot canceled. You can manually reboot later."
fi
