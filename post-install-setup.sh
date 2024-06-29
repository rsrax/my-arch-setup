#!/bin/bash

# Set up time zone (example)
ln -sf /usr/share/zoneinfo/Region/City /etc/localtime
hwclock --systohc

# Localization (example)
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf

# Network configuration (example)
echo "myhostname" > /etc/hostname
cat <<EOF > /etc/hosts
127.0.0.1   localhost
::1         localhost
127.0.1.1   myhostname.localdomain myhostname
EOF

# Install essential packages
pacman -S --noconfirm \
    base-devel \
    linux-headers \
    networkmanager \
    network-manager-applet \
    dialog \
    wpa_supplicant \
    mtools \
    dosfstools \
    reflector \
    acpi \
    acpi_call \
    os-prober \
    ntfs-3g

# Enable essential services
systemctl enable NetworkManager
systemctl enable acpid

# Set root password (example)
echo "Set root password:"
passwd

# Exit chroot
echo "Setup complete! Exit chroot and reboot your system."
