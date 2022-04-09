#!/bin/bash

echo "\n"
echo "Please make sure you have ROOT access & connected to the internet!"
sleep 5

echo "\n"
echo "=================================="
echo "=== Post Install Configuration ==="
echo "=================================="
echo "\n"

echo "Please make sure you have ROOT access & connected to net!"

sleep 5

echo "\n"
echo "=== Configuring System Fonts ==="
echo "-> Installing english fonts..."
pacman -S ttf-dejavu ttf-font-awesome otf-font-awesome ttf-lato ttf-liberation ttf-linux-libertine ttf-opensans ttf-roboto ttf-hack

echo "-> Installing chinese fonts..."
pacman -S noto-fonts noto-fonts-extra noto-fonts-emoji adobe-source-han-sans-cn-fonts adobe-source-han-sans-hk-fonts wqy-microhei

echo "=== Configuring Paging ==="
echo "Enter the size you want in MB:"
read page_size
echo "-> Initializing page file..."
dd if=/dev/zero of=/swapfile bs=1M count=$page_size status=progress
chmod 600 /swapfile
mkswap /swapfile
echo '/swapfile none swap sw 0 0' | tee -a /etc/fstab

echo "-> Turning swap on..."
swapon -a

echo "=== Setup Timezone ==="
timedatectl set-timezone Asia/Shanghai
systemctl enable systemd-timesyncd

echo "=== Setup Host ==="

echo "Enter the hostname you want:"
read host_name
hostnamectl set-hostname $host_name

echo "-> Configuring hosts file..."
echo "127.0.0.1   localhost" > /etc/hosts
echo "127.0.1.1   $host_name" >> /etc/hosts

echo "=== Setup Some Drivers ==="
echo "-> Installing cpu ucode..."
echo "Enter your cpu type: amd or intel?"
read cpu_type

if [[ ($cpu_type == "amd" || $cpu_type == "AMD") ]]; then
echo "AMD detected!"
pacman -S amd-ucode
else
echo "Intel detected!"
pacman -S intel-ucode
fi

echo "-> Installing gpu driver..."
pacman -S mesa

echo "-> Installing sound driver..."
pacman -S alsa-utils pulseaudio pulseaudio-bluetooth cups

echo "-> Installing bluetooth driver..."
pacman -S bluez bluez-utils
systemctl enable bluetooth

echo "=== Setup Desktop Enviroment ==="
echo "-> Installing xorg..."
pacman -S xorg-server
echo "-> Enabling freetype rendering..."
sed -i "/REETYPE_PROPERTIES/s/^#//g" /etc/profile.d/freetype2.sh
sed -i "s/^[ \t]*//" /etc/profile.d/freetype2.sh

echo "-> Installing KDE..."
pacman -S plasma-meta plasma-desktop sddm kscreen plasma-pa ffmpegthumbs dolphin konsole ark vlc kate
systemctl enable sddm

echo "================================="
echo "Finished, please reboot."


