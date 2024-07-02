#!/bin/bash

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
