#!/bin/bash

# Copy chroot-script.sh to the new system
echo "Copying chroot-script.sh to the new system..."
cp chroot-script.sh /mnt/scripts/chroot-script.sh

# Export environment variables for the chroot environment
export ROOT_PASSWORD USER_NAME USER_PASSWORD HOSTNAME

# Chroot into the new system and run the chroot-script.sh script with environment variables
echo "Chrooting into the new system..."
arch-chroot /mnt /bin/bash -c "
export ROOT_PASSWORD='${ROOT_PASSWORD}'
export USER_NAME='${USER_NAME}'
export USER_PASSWORD='${USER_PASSWORD}'
export HOSTNAME='${HOSTNAME}'
/scripts/chroot-script.sh
"
