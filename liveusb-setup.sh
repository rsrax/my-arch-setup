#!/bin/bash

# Load Helper Functions
source functions.sh

# Call each module script in order
./liveusb/01-set_keyboard.sh
./liveusb/02-check_boot_mode.sh
./liveusb/03-check_internet.sh
./liveusb/04-prepare_storage.sh
./liveusb/05-install_base_system.sh
./liveusb/06-generate_fstab.sh
./liveusb/07-chroot_and_configure.sh
./liveusb/08-confirm_reboot.sh

# Handle potential errors
if [ $? -ne 0 ]; then
    echo "An error occurred during the installation process."
    read -p "Press Enter to continue..."
fi
