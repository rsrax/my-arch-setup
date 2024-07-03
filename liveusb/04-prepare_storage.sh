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
read -rp "Enter the primary disk (e.g., /dev/nvme0n1): " primary_disk
primary_disk=$(echo "$primary_disk" | tr -d ' \t\r\n') # Trim whitespace

# Validate primary disk input
while true; do
    # Validate primary disk input
    if lsblk -dpno NAME | grep -q "^$primary_disk$"; then
        break
    else
        echo "Invalid input. Please enter a valid disk name (e.g., /dev/nvme0n1 or /dev/sda)."
    fi

    read -rp "Enter the primary disk (e.g., /dev/nvme0n1): " primary_disk
    primary_disk=$(echo "$primary_disk" | tr -d ' \t\r\n') # Trim whitespace
done

# Partition and format primary disk (using the chosen $primary_disk variable)
log "Partitioning the disk..."
parted "$primary_disk" --script mklabel gpt mkpart ESP fat32 1MiB 1GiB set 1 esp on mkpart primary linux-swap 1GiB 17GiB mkpart primary btrfs 17GiB 100% || {
    log "Error partitioning disk!"
    exit 1
}
log "Partitioning complete."

log "Formatting partitions..."
mkfs.fat -F32 "${primary_disk}p1" || {
    log "Error formatting EFI partition!"
    exit 1
}
mkswap "${primary_disk}p2" || {
    log "Error formatting swap partition!"
    exit 1
}
mkfs.btrfs "${primary_disk}p3" || {
    log "Error formatting root partition!"
    exit 1
}
log "Formatting complete."

# Mounting filesystems
log "Mounting filesystems..."
mount "${primary_disk}p3" /mnt || {
    log "Error mounting root filesystem!"
    exit 1
}
mkdir -p /mnt/{home,efi}
mount -o compress=zstd,subvol=@ "${primary_disk}p3" /mnt || {
    log "Error mounting root subvolume!"
    exit 1
}
mount -o compress=zstd,subvol=@home "${primary_disk}p3" /mnt/home || {
    log "Error mounting home subvolume!"
    exit 1
}
mount "${primary_disk}p1" /mnt/efi || {
    log "Error mounting EFI partition!"
    exit 1
}
swapon "${primary_disk}p2" || {
    log "Error enabling swap!"
    exit 1
}
log "Mounting complete."

# Select secondary disk (optional)
read -p "Do you want to mount a secondary disk? (y/n): " mount_secondary

if [[ $mount_secondary == "y" || $mount_secondary == "Y" ]]; then
    log "Available disks:"
    list_disks
    read -rp "Enter the secondary disk (e.g., /dev/sda1): " secondary_disk
    secondary_disk=$(echo "$secondary_disk" | tr -d ' \t\r\n') # Trim whitespace

    # Validate secondary disk input
    while true; do
        read -rp "Enter the secondary disk (e.g., /dev/sda1): " secondary_disk
        secondary_disk=$(echo "$secondary_disk" | tr -d ' \t\r\n') # Trim whitespace

        # Validate secondary disk input
        if lsblk -dpno NAME | grep -q "^$secondary_disk$"; then
            break
        else
            echo "Invalid input. Please enter a valid disk name (e.g., /dev/sda1)."
        fi
    done

    # Mount secondary disk (using the chosen $secondary_disk variable)
    log "Mounting secondary disk..."
    mkdir -p /mnt/mnt/pdata
    mount "$secondary_disk" /mnt/mnt/pdata || {
        log "Error mounting secondary disk!"
        exit 1
    }
    log "Secondary disk mounted."
fi

log "Partitioning and mounting complete."
