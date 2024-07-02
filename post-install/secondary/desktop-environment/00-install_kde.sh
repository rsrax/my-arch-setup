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

# Add the g14 repository key
echo "Adding the g14 repository key..."
pacman-key --recv-keys 8F654886F17D497FEFE3DB448B15A6B0E9A3FA35
pacman-key --finger 8F654886F17D497FEFE3DB448B15A6B0E9A3FA35
pacman-key --lsign-key 8F654886F17D497FEFE3DB448B15A6B0E9A3FA35
pacman-key --finger 8F654886F17D497FEFE3DB448B15A6B0E9A3FA35

# Uncomment the g14 repository if it's commented out
if grep -q "#\[g14\]" /etc/pacman.conf; then
    echo "Uncommenting the g14 repository in pacman.conf..."
    sed -i 's/#\[g14\]/\[g14\]/' /etc/pacman.conf
    sed -i 's/#Server = https:\/\/arch.asus-linux.org/Server = https:\/\/arch.asus-linux.org/' /etc/pacman.conf
fi

# Check if the g14 repository is already added to pacman.conf
if ! grep -q "\[g14\]" /etc/pacman.conf; then
    echo "Adding the g14 repository to pacman.conf..."
    echo -e "\n[g14]\nServer = https://arch.asus-linux.org" >>/etc/pacman.conf
else
    echo "The g14 repository is already added to pacman.conf."
fi

# Update the system with the new repository
echo "Updating the system with the new repository..."
pacman -Syu --noconfirm

# Install asusctl, rog-control-center, and supergfxctl from the g14 repository
echo "Installing asusctl, rog-control-center, and supergfxctl..."
pacman -S --noconfirm --needed asusctl rog-control-center supergfxctl

# Install KDE Plasma and related applications
echo "Installing KDE Plasma and related applications..."
pacman -S --noconfirm --needed \
    plasma

# Install additional recommended packages from Arch repository
echo "Installing additional recommended packages from Arch repository..."
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
    switcheroo-control

# Install Google Chrome from AUR
echo "Installing Google Chrome from AUR..."
sudo -u $SUDO_USER yay -S google-chrome --noconfirm

# Enable necessary services
echo "Enabling necessary services..."
systemctl enable power-profiles-daemon.service
systemctl enable supergfxd.service
systemctl enable switcheroo-control.service

# Install and enable SDDM
echo "Installing and enabling SDDM..."
pacman -S --noconfirm --needed sddm sddm-kcm
systemctl enable sddm

echo "KDE Plasma, additional packages, and SDDM installation complete."

# Confirm reboot
read -p "The setup is complete. Do you want to reboot now? (y/n): " confirm_reboot

if [[ $confirm_reboot == "y" || $confirm_reboot == "Y" ]]; then
    echo "Rebooting the system..."
    reboot
else
    echo "Reboot canceled. You can manually reboot later."
fi
