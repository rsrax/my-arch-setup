
### liveusb-setup.sh

```bash
#!/bin/bash

# Example of steps to prepare the system for installation (adjust as necessary)

# Update system clock
timedatectl set-ntp true

# Partitioning and formatting (example)
parted /dev/sda mklabel gpt
parted /dev/sda mkpart primary ext4 1MiB 100%
mkfs.ext4 /dev/sda1

# Mount the filesystem
mount /dev/sda1 /mnt

# Install base system
pacstrap /mnt base linux linux-firmware

# Generate fstab
genfstab -U /mnt >> /mnt/etc/fstab

# Chroot into the new system
arch-chroot /mnt

# Instructions to continue in the chrooted environment
echo "Now run './post-install-setup.sh' from the chrooted environment to complete the setup."
