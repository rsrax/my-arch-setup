#!/bin/bash

# Load Helper Functions
source functions.sh

# Call each module script in order
bash ./liveusb/00-load_env.sh
bash ./liveusb/01-set_keyboard.sh
bash ./liveusb/02-check_boot_mode.sh
bash ./liveusb/03-check_internet.sh
bash ./liveusb/04-prepare_storage.sh
bash ./liveusb/05-install_base_system.sh
bash ./liveusb/06-generate_fstab.sh
bash ./liveusb/07-chroot_and_configure.sh
bash ./liveusb/08-confirm_reboot.sh

# Handle potential errors
if [ $? -ne 0 ]; then
    echo "An error occurred during the installation process."
    read -p "Press Enter to continue..."
fi
