#!/bin/bash

# Set up locales
echo 'Configuring locales...'
sed -i 's/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
locale-gen
echo 'LANG=en_US.UTF-8' > /etc/locale.conf
echo 'Locales configured.'

# Set up keyboard layout
echo 'KEYMAP=en' > /etc/vconsole.conf
echo 'Keyboard layout configured.'

# Set up hostname
echo 'Setting up hostname...'
echo "${HOSTNAME}" > /etc/hostname

# Set up hosts file
echo 'Configuring /etc/hosts...'
echo '127.0.0.1 localhost' > /etc/hosts
echo '::1 localhost' >> /etc/hosts
echo "127.0.1.1 ${HOSTNAME}" >> /etc/hosts
echo '/etc/hosts configured.'

# Set root password
echo "root:${ROOT_PASSWORD}" | chpasswd

# Add a new user
echo "Adding new user ${USER_NAME}..."
useradd -mG wheel ${USER_NAME}
echo "${USER_NAME}:${USER_PASSWORD}" | chpasswd

# Allow wheel group to execute any command
echo 'Configuring sudoers...'
sed -i 's/^# %wheel ALL=(ALL:ALL) ALL$/%wheel ALL=(ALL:ALL) ALL/' /etc/sudoers

# Install and configure GRUB
echo 'Installing and configuring GRUB...'
grub-install --target=x86_64-efi --efi-directory=/efi --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg
echo 'GRUB installed and configured.'

# Enable NetworkManager
echo 'Enabling NetworkManager...'
systemctl enable NetworkManager
echo 'NetworkManager enabled.'

echo 'Post-install setup complete! Exiting chroot...'
