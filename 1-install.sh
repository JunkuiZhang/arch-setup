#!/bin/bash

echo "\n"
echo "=========================="
echo "=== Install Arch Linux ==="
echo "=========================="
echo "\n"


echo "=== Install Arch Linux ==="
echo "-> Installing tools..."
pacman -S bash-completion vim

echo "-> Configuring locale..."
echo "LANG=en_US.UTF-8" > /etc/locale.conf
sed -i "/#en_US.UTF-8/s/^#//g" /etc/locale.gen
sed -i "/#zh_CN.UTF-8/s/^#//g" /etc/locale.gen
# echo "en_US.UTF-8 UTF-8  " >> /etc/locale.gen
# echo "zh_CN.UTF-8 UTF-8  " >> /etc/locale.gen

echo "-> Generating locale..."
locale-gen

echo "-> Installing network & build tools..."
pacman -S linux-headers base-devel networkmanager
systemctl enable NetworkManager

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

echo "=== Install Grub ==="

echo "-> Installing tools..."
pacman -S grub efibootmgr mtools
echo "-> Configuring grub..."
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=grub_uefi --recheck
sed -i "/GRUB_TIMEOUT/s/^/#/g" /etc/default/grub
sed -i "/GRUB_TIMEOUT_STYLE/s/^/#/g" /etc/default/grub
echo "GRUB_TIMEOUT=0" >> /etc/default/grub
echo "GRUB_TIMEOUT_STYLE=hidden" >> /etc/default/grub
echo "GRUB_HIDDEN_TIMEOUT=0" >> /etc/default/grub
echo "GRUB_HIDDEN_TIMEOUT_QUIET=true" >> /etc/default/grub

echo "-> Generating grub config file..."
grub-mkconfig -o /boot/grub/grub.cfg

echo "================================"
echo "Finished, please exit and reboot."

