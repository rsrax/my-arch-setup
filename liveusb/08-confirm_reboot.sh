#!/bin/bash

# Confirm reboot
read -p "The installation is complete. Do you want to reboot now? (y/n): " confirm_reboot

if [[ $confirm_reboot == "y" || $confirm_reboot == "Y" ]]; then
    # Unmount everything
    echo "Unmounting all partitions..."
    umount -R /mnt

    # Reboot the system
    echo "Rebooting the system..."
    reboot
else
    echo "Reboot canceled. You can manually reboot later."
fi
