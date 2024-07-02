#!/bin/bash

log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1" >>/tmp/arch_install.log
}

# Function to list available disks
list_disks() {
    lsblk -dpno NAME | grep -E '/dev/nvme[0-9]+|/dev/sd[a-z]' # Filter for NVMe and SATA drives
}

# Select primary disk
log "Available disks:"
list_disks
read -p "Enter the primary disk (e.g., /dev/nvme0n1): " primary_disk

# Validate primary disk input
while [[ ! $primary_disk =~ ^/dev/(nvme[0-9]+|sd[a-z])$ ]]; do # Regex for valid disk names
    echo "Invalid input. Please enter a valid disk name (e.g., /dev/nvme0n1 or /dev/sda)."
    read -p "Enter the primary disk: " primary_disk
done

# Partition and format primary disk (using the chosen $primary_disk variable)
log "Partitioning the NVMe SSD..."
# Create a GPT partition table
parted "$primary_disk" --script mklabel gpt || {
    log "Error partitioning disk!"
    exit 1
}

# Create an EFI system partition (ESP) with FAT32 format from 1MiB to 1GiB
parted "$primary_disk" --script mkpart primary fat32 1MiB 1GiB || {
    log "Error creating EFI partition!"
    exit 1
}
parted "$primary_disk" --script set 1 esp on || {
    log "Error setting ESP flag!"
    exit 1
}

# Create a swap partition from 1GiB to 17GiB (16GiB in size)
parted "$primary_disk" --script mkpart primary linux-swap 1GiB 17GiB || {
    log "Error creating swap partition!"
    exit 1
}

# Create a Btrfs partition from 17GiB to the end of the disk
parted "$primary_disk" --script mkpart primary btrfs 17GiB 100% || {
    log "Error creating root partition!"
    exit 1
}

# Formatting partitions
log "Formatting the EFI partition..."
mkfs.fat -F 32 "${primary_disk}p1" || {
    log "Error formatting EFI partition!"
    exit 1
}

log "Formatting the swap partition..."
mkswap "${primary_disk}p2" || {
    log "Error formatting swap partition!"
    exit 1
}

log "Formatting the root partition..."
mkfs.btrfs "${primary_disk}p3" || {
    log "Error formatting root partition!"
    exit 1
}

# Mounting root filesystem
log "Mounting the root filesystem..."
mount "${primary_disk}p3" /mnt || {
    log "Error mounting root filesystem!"
    exit 1
}

# Creating Btrfs subvolumes
log "Creating Btrfs subvolumes..."
btrfs subvolume create /mnt/@ || {
    log "Error creating root subvolume!"
    exit 1
}
btrfs subvolume create /mnt/@home || {
    log "Error creating home subvolume!"
    exit 1
}

# Unmounting root filesystem
log "Unmounting the root filesystem..."
umount /mnt || {
    log "Error unmounting root filesystem!"
    exit 1
}

# Mounting subvolumes
log "Mounting root subvolume..."
mount -o compress=zstd,subvol=@ "${primary_disk}p3" /mnt || {
    log "Error mounting root subvolume!"
    exit 1
}

log "Mounting home subvolume..."
mkdir -p /mnt/home
mount -o compress=zstd,subvol=@home "${primary_disk}p3" /mnt/home || {
    log "Error mounting home subvolume!"
    exit 1
}

log "Mounting EFI partition..."
mkdir -p /mnt/efi
mount "${primary_disk}p1" /mnt/efi || {
    log "Error mounting EFI partition!"
    exit 1
}

log "Enabling swap..."
swapon "${primary_disk}p2" || {
    log "Error enabling swap!"
    exit 1
}

# Select secondary disk (optional)
read -p "Do you want to mount a secondary disk? (y/n): " mount_secondary

if [[ $mount_secondary == "y" || $mount_secondary == "Y" ]]; then
    log "Available disks:"
    list_disks
    read -p "Enter the secondary disk (e.g., /dev/sda1): " secondary_disk

    # Validate secondary disk input
    while [[ ! $secondary_disk =~ ^/dev/(nvme[0-9]+p[0-9]+|sd[a-z][0-9]+)$ ]]; do # Regex for valid partition names
        echo "Invalid input. Please enter a valid disk or partition name (e.g., /dev/nvme0n1p1 or /dev/sda1)."
        read -p "Enter the secondary disk: " secondary_disk
    done

    # Mount secondary disk (using the chosen $secondary_disk variable)
    log "Mounting secondary hard disk for personal data..."
    mkdir -p /mnt/mnt/pdata
    mount "$secondary_disk" /mnt/mnt/pdata
fi

log "Partitioning and mounting complete."
