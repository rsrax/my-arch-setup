#!/bin/bash

log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1" >>/tmp/arch_install.log
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

# Add the g14 repository key
log "Adding the g14 repository key..."
pacman-key --recv-keys 8F654886F17D497FEFE3DB448B15A6B0E9A3FA35
pacman-key --finger 8F654886F17D497FEFE3DB448B15A6B0E9A3FA35
pacman-key --lsign-key 8F654886F17D497FEFE3DB448B15A6B0E9A3FA35
pacman-key --finger 8F654886F17D497FEFE3DB448B15A6B0E9A3FA35

# Add/Uncomment the g14 repository
if ! grep -q "^\[g14\]" /etc/pacman.conf; then # Check if the repo is already present
    log "Adding the g14 repository to pacman.conf..."
    echo -e "\n[g14]\nServer = https://arch.asus-linux.org" >>/etc/pacman.conf
else
    log "The g14 repository is already added to pacman.conf."
    # Uncomment the g14 repository if it's commented out
    sed -i 's/^#\\{0,1}\[g14]/[g14]/' /etc/pacman.conf                                                                  # Remove leading '#' if present
    sed -i 's/^#\\{0,1}Server = https:\/\/arch.asus-linux.org/Server = https:\/\/arch.asus-linux.org/' /etc/pacman.conf # Remove leading '#' if present
fi

# Update the system with the new repository
log "Updating the system with the new repository..."
pacman -Syu --noconfirm || {
    log "Error updating the system"
    exit 1
}

# Install asusctl, rog-control-center, and supergfxctl from the g14 repository
log "Installing asusctl, rog-control-center, and supergfxctl..."
pacman -S --noconfirm --needed asusctl rog-control-center supergfxctl || {
    log "Error installing ASUS utilities"
    exit 1
}

# Install KDE Plasma and related applications
log "Installing KDE Plasma and related applications..."
pacman -S --noconfirm --needed \
    plasma \
    kde-education \
    kde-games \
    kde-graphics \
    kde-pim \
    kde-utilities \
    kde-system || {
    log "Error installing KDE packages"
    exit 1
}

# Install additional recommended packages from Arch repository
log "Installing additional recommended packages from Arch repository..."
pacman -S --noconfirm --needed \
    baloo-widgets \
    dolphin-plugins \
    ffmpegthumbs \
    kdeconnect-kde \
    kdegraphics-thumbnailers \
    kio-extras \
    phonon-vlc \
    qt-imageformats \
    noto-sans \
    noto-color-emoji \
    power-profiles-daemon \
    switcheroo-control || {
    log "Error installing additional packages"
    exit 1
}

# Install Google Chrome from AUR
log "Installing Google Chrome from AUR..."
sudo -u $SUDO_USER yay -S google-chrome --noconfirm || {
    log "Error installing Google Chrome"
    exit 1
}

# Enable necessary services
log "Enabling necessary services..."
systemctl enable power-profiles-daemon.service || {
    log "Error enabling power-profiles-daemon.service"
    exit 1
}
systemctl enable supergfxd.service || {
    log "Error enabling supergfxd.service"
    exit 1
}
systemctl enable switcheroo-control.service || {
    log "Error enabling switcheroo-control.service"
    exit 1
}

# Install and enable SDDM
log "Installing and enabling SDDM..."
pacman -S --noconfirm --needed sddm sddm-kcm || {
    log "Error installing SDDM"
    exit 1
}
systemctl enable sddm || {
    log "Error enabling SDDM"
    exit 1
}

log "KDE Plasma, additional packages, and SDDM installation complete."

# Confirm reboot
read -p "The setup is complete. Do you want to reboot now? (y/n): " confirm_reboot

if [[ $confirm_reboot == "y" || $confirm_reboot == "Y" ]]; then
    log "Rebooting the system..."
    reboot
else
    log "Reboot canceled. You can manually reboot later."
fi
