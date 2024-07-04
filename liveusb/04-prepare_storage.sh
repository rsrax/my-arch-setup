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

# Ensure the user enters a valid primary disk
while true; do
    read -rp "Enter the primary disk (e.g., /dev/nvme0n1): " primary_disk
    primary_disk=$(echo "$primary_disk" | tr -d ' \t\r\n') # Trim whitespace

    # Validate primary disk input
    if lsblk -dpno NAME | grep -q "^$primary_disk$"; then
        break
    else
        echo "Invalid input. Please enter a valid disk name (e.g., /dev/nvme0n1 or /dev/sda)."
    fi
done

# Forcefully unmount any existing mounts on the primary disk
log "Unmounting any existing mounts on $primary_disk..."
umount -R "$primary_disk" || log "Warning: Failed to unmount some partitions. Proceeding anyway."

# Wipe existing data and create new partition table
log "Wiping existing data and creating new partition table on $primary_disk..."
dd if=/dev/zero of="$primary_disk" bs=512 count=1 oflag=direct,dsync # Wipe the first sector
wipefs -a "$primary_disk"                                            # Wipe all signatures
sgdisk -Zo "$primary_disk"                                           # Create a new GPT partition table
log "Wiping and partitioning complete."

# Partition and format primary disk
log "Partitioning the disk..."
parted "$primary_disk" --script \
    mklabel gpt \
    mkpart ESP fat32 1MiB 1GiB set 1 esp on \
    mkpart primary linux-swap 1GiB 17GiB \
    mkpart primary btrfs 17GiB 100%

log "Formatting partitions..."
mkfs.fat -F32 "${primary_disk}p1"
mkswap "${primary_disk}p2"
mkfs.btrfs -f "${primary_disk}p3"

# Mount filesystems
log "Mounting filesystems..."
mount "${primary_disk}p3" /mnt

# Create and mount Btrfs subvolumes
log "Creating and mounting Btrfs subvolumes..."
btrfs subvolume create /mnt/@
btrfs subvolume create /mnt/@home
umount /mnt

mount -o compress=zstd,subvol=@ "${primary_disk}p3" /mnt
mkdir -p /mnt/home
mount -o compress=zstd,subvol=@home "${primary_disk}p3" /mnt/home
mkdir -p /mnt/efi
mount "${primary_disk}p1" /mnt/efi
swapon "${primary_disk}p2"

log "Mounting complete."

# Select secondary disk (optional)
while true; do
    read -rp "Do you want to mount a secondary disk? (y/n): " mount_secondary
    case $mount_secondary in
    [Yy]*)
        log "Available disks:"
        list_disks

        # Ensure the user enters a valid secondary disk
        while true; do
            read -rp "Enter the secondary disk (e.g., /dev/sda): " secondary_disk
            secondary_disk=$(echo "$secondary_disk" | tr -d ' \t\r\n') # Trim whitespace

            # Validate secondary disk input
            if lsblk -dpno NAME | grep -q "^$secondary_disk$"; then
                break
            else
                echo "Invalid input. Please enter a valid disk name (e.g., /dev/nvme0n1 or /dev/sda)."
            fi
        done

        # Forcefully unmount any existing mounts on the secondary disk (if applicable)
        log "Unmounting any existing mounts on $secondary_disk..."
        umount -R "$secondary_disk" || log "Warning: Failed to unmount some partitions. Proceeding anyway."

        # Mount secondary disk (using the chosen $secondary_disk variable)
        log "Mounting secondary disk..."
        mkdir -p /mnt/mnt/pdata
        mount "${secondary_disk}1" /mnt/mnt/pdata || {
            log "Error mounting secondary disk!"
        }
        log "Secondary disk mounted."
        break
        ;;
    [Nn]*) break ;;
    *) echo "Please answer yes or no." ;;
    esac
done

log "Partitioning and mounting complete."
