#!/bin/bash

# Edit grub-btrfsd service to enable automatic grub entries update each time a snapshot is created
echo "Configuring grub-btrfsd service..."
sudo sed -i 's|^ExecStart=.*|ExecStart=/usr/bin/grub-btrfsd --syslog --timeshift-auto|' /etc/systemd/system/grub-btrfsd.service

# Enable grub-btrfsd service to run on boot
echo "Enabling grub-btrfsd service..."
sudo systemctl enable grub-btrfsd
