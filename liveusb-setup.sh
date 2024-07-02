#!/bin/bash

# Load Helper Functions (assuming you have a 'functions.sh' script)
source functions.sh

# Call each module script in order
./modules/00-load_env.sh
./modules/01-set_keyboard.sh
./modules/02-check_boot_mode.sh
./modules/03-check_internet.sh
./modules/04-prepare_storage.sh
./modules/05-install_base_system.sh
./modules/06-generate_fstab.sh
./modules/07-chroot_and_configure.sh
./modules/08-confirm_reboot.sh

# Handle potential errors
if [ $? -ne 0 ]; then
    echo "An error occurred during the installation process."
    read -p "Press Enter to continue..."
fi
