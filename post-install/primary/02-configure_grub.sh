#!/bin/bash

# Edit grub-btrfsd service
echo "Configuring grub-btrfsd service..."
sudo sed -i 's/^ExecStart=\s*/ExecStart=\/usr/bin\/grub-btrfsd --syslog --timeshift-auto/' /etc/systemd/system/grub-btrfsd.service

# Reload systemd daemon to apply changes
sudo systemctl daemon-reload

# Enable grub-btrfsd service to run on boot
echo "Enabling grub-btrfsd service..."
sudo systemctl enable grub-btrfsd
