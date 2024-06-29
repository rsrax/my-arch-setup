#!/bin/bash

# Source the .env file
if [ -f .env ]; then
    echo "Loading environment variables from .env file..."
    source .env
else
    echo ".env file not found! Please ensure the .env file exists with the required variables."
    exit 1
fi

# Check if .env values have been changed from defaults
if [[ "$ROOT_PASSWORD" == "changeme_root_password" || "$USER_NAME" == "changeme_user_name" || "$USER_PASSWORD" == "changeme_user_password" || "$HOSTNAME" == "changeme_hostname" ]]; then
    echo "Error: One or more environment variables in .env are using default values. Please update the .env file with your specific values."
    exit 1
fi

# Load keyboard layout
echo "Loading English keyboard layout..."
loadkeys en
echo "Keyboard layout set to English."

# Check if in UEFI mode
echo "Checking if the system is in UEFI mode..."
if [ -d /sys/firmware/efi ]; then
    if [ $(cat /sys/firmware/efi/fw_platform_size) -eq 64 ]; then
        echo "UEFI mode detected (64-bit)"
    elif [ $(cat /sys/firmware/efi/fw_platform_size) -eq 32 ]; then
        echo "UEFI mode detected (32-bit)"
    else
        echo "Unknown UEFI mode"
    fi
else
    echo "BIOS mode detected"
fi

# Check internet connection
echo "Checking internet connection..."
if ping -c 5 archlinux.org &> /dev/null; then
    echo "Internet connection is working."
else
    echo "Internet connection is not working. Please check your network settings."
    exit 1
fi

# Partitioning the NVMe SSD
echo "Partitioning the NVMe SSD..."
# Create a GPT partition table
parted /dev/nvme0n1 --script mklabel gpt

# Create an EFI system partition (ESP) with FAT32 format from 1MiB to 1GiB
parted /dev/nvme0n1 --script mkpart primary fat32 1MiB 1GiB
parted /dev/nvme0n1 --script set 1 esp on

# Create a swap partition from 1GiB to 17GiB (16GiB in size)
parted /dev/nvme0n1 --script mkpart primary linux-swap 1GiB 17GiB

# Create a Btrfs partition from 17GiB to the end of the disk
parted /dev/nvme0n1 --script mkpart primary btrfs 17GiB 100%

# Formatting partitions
echo "Formatting the EFI partition..."
mkfs.fat -F 32 /dev/nvme0n1p1

echo "Formatting the swap partition..."
mkswap /dev/nvme0n1p2

echo "Formatting the root partition..."
mkfs.btrfs /dev/nvme0n1p3

# Mounting root filesystem
echo "Mounting the root filesystem..."
mount /dev/nvme0n1p3 /mnt

# Creating Btrfs subvolumes
echo "Creating Btrfs subvolumes..."
btrfs subvolume create /mnt/@
btrfs subvolume create /mnt/@home

# Unmounting root filesystem
echo "Unmounting the root filesystem..."
umount /mnt

# Mounting subvolumes
echo "Mounting root subvolume..."
mount -o compress=zstd,subvol=@ /dev/nvme0n1p3 /mnt

echo "Mounting home subvolume..."
mkdir -p /mnt/home
mount -o compress=zstd,subvol=@home /dev/nvme0n1p3 /mnt/home

echo "Mounting EFI partition..."
mkdir -p /mnt/efi
mount /dev/nvme0n1p1 /mnt/efi

echo "Enabling swap..."
swapon /dev/nvme0n1p2

# Mounting secondary hard disk for personal data
echo "Mounting secondary hard disk for personal data..."
mkdir -p /mnt/mnt/pdata
mount /dev/sda1 /mnt/mnt/pdata

echo "Partitioning and mounting complete."

# Pacstrap to install base system
echo "Installing base system with pacstrap..."
pacstrap -K /mnt base base-devel linux linux-firmware intel-ucode git btrfs-progs grub efibootmgr grub-btrfs inotify-tools timeshift vim nano networkmanager pipewire pipewire-alsa pipewire-pulse pipewire-jack wireplumber reflector openssh man sudo

echo "Base system installation complete."

# Generate fstab
echo "Generating fstab..."
genfstab -U /mnt >> /mnt/etc/fstab

echo "fstab generated."

# Copy chroot-setup.sh to the new system
echo "Copying chroot-setup.sh to the new system..."
cp chroot-setup.sh /mnt/scripts/chroot-setup.sh

# Export environment variables for the chroot environment
export ROOT_PASSWORD USER_NAME USER_PASSWORD HOSTNAME

# Chroot into the new system and run the chroot-setup.sh script with environment variables
echo "Chrooting into the new system..."
arch-chroot /mnt /bin/bash -c "
export ROOT_PASSWORD='${ROOT_PASSWORD}'
export USER_NAME='${USER_NAME}'
export USER_PASSWORD='${USER_PASSWORD}'
export HOSTNAME='${HOSTNAME}'
/scripts/chroot-setup.sh
"

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
