#!/bin/bash

# Confirm reboot
read -p "The setup is complete. Do you want to reboot now? (y/n): " confirm_reboot

if [[ $confirm_reboot == "y" || $confirm_reboot == "Y" ]]; then
    echo "Rebooting the system..."
    reboot
else
    echo "Reboot canceled. You can manually reboot later."
fi
