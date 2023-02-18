#!/bin/bash

echo ""
echo "========================================================"
echo "================== Install Arch Linux =================="
echo "========================================================"
echo ""


echo "=============== Install Arch Linux ==============="
reflector --country China --sort rate --save /etc/pacman.d/mirrorlist
echo "-> Installing tools..."
pacman -S bash-completion vim

echo "-> Configuring locale..."
echo "LANG=en_US.UTF-8" > /etc/locale.conf
sed -i "/#en_US.UTF-8/s/^#//g" /etc/locale.gen
sed -i "/#zh_CN.UTF-8/s/^#//g" /etc/locale.gen

echo "-> Generating locale..."
locale-gen

echo "-> Installing network & build tools..."
pacman -S linux-headers base-devel networkmanager
systemctl enable NetworkManager

echo "-> Installing LVM2..."
pacman -S lvm2
echo "-> Setting up lvm2..."
sed -i "/^HOOKS=(/ s/^\(.*\)\(filesystems\)/\1lvm2 \2/" /etc/mkinitcpio.conf
mkinitcpio -p linux

echo "-> Setting up user..."
echo "Enter the password for root user:"
passwd

echo "Enter the name of default user:"
read user_name
useradd -m -g users -G wheel $user_name

echo "Enter the password for default user:"
passwd $user_name

echo "-> Configuring sudo for wheel group..."
sed -i "/wheel\sALL=(ALL:ALL)\sALL/s/^#//g" /etc/sudoers
sed -i "s/^[ \t]*//" /etc/sudoers

echo "=============== Install Boot Loader ==============="

echo "-> Installing boot-manager..."
echo "Enter yout cpu type: amd or intel ?"
read cpu_type
if [[ ($cpu_type == "amd" || $cpu_type == "AMD") ]]; then
	echo "AMD detected!"
	pacman -S amd-ucode
	cpu_type=amd-ucode.img
else
	echo "Intel detected!"
	pacman -S intel-ucode
	cpu_type=intel-ucode.img
fi

pacman -S refind
echo "-> Configuring boot-manager..."
refind-install
lsblk
echo "Please enter the root partition: ie. sda2"
read root_part
echo "\"Boot with default options\"   \"root=/dev/$root_part rw add_efi_memmap initrd=$cpu_type initrd=initramfs-linux.img\"" > /boot/refind_linux.conf
echo "\"Boot with minimal options\"   \"ro root=/dev/$efi_boot"\" >> /boot/refind_linux.conf

echo "================================"
echo "Finished, please exit and reboot."
