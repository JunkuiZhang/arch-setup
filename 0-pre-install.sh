#!/bin/bash

echo ""
echo "=================================================="
echo "================= Stating to install system ================="
echo "=================================================="
echo ""
echo "Make sure you have connect to the internet and disk partition is completed!"
echo "No need to monut the disks."

sleep 5

echo "=============== Configuring pacman mirrorlist ==============="

reflector --country China --age 24 --sort rate --protocol https --save /etc/pacman.d/mirrorlist

echo "-> Completed..."

echo "================== Mount the disk  =================="

lsblk
echo "Enter your root partition name: (i.e. nvme0n1p2)"
read root_partition

lsblk
echo "Enter your EFI partition name: (i.e. nvme0n1p1)"
read efi_partition

echo "-> Mounting..."
mount /dev/$root_partition /mnt
mkdir -p /mnt/boot
mount /dev/$efi_partition /mnt/boot

lsblk
echo "-> Mounting finished, input anything to continue:"
read void_input

echo "=== Prepare to install linux ==="
echo "-> Preparing..."
pacstrap /mnt base linux linux-firmware
echo "-> Generating file system table..."
genfstab -U /mnt >> /mnt/etc/fstab

echo "=== Entering New System ==="
sleep 3

arch-chroot /mnt

