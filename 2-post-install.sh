#!/bin/bash

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

echo "-> Installing gpu driver..."
pacman -S mesa

echo "Enter the gpu you use: amd or intel?"
read gpu_type
if [[ ($gpu_type == "amd" || $gpu_type == "AMD") ]]; then
	echo "AMD gpu is used."
	pacman -S xf86-video-amdgpu vulkan-radeon libva-mesa-driver mesa-vdpau
else
	echo "Intel gpu is used."
	pacman -S xf86-video-intel vulkan-intel intel-media-driver
	sysctl dev.i915.perf_stream_paranoid=0
fi

echo "-> Installing sound driver..."
pacman -S alsa-utils pulseaudio pulseaudio-bluetooth cups

echo "-> Installing bluetooth driver..."
pacman -S bluez bluez-utils
systemctl enable bluetooth

echo "=== Setup Desktop Enviroment ==="
echo "-> Install Xorg or Wayland?"

wayland_pkg=""
echo "Type xorg or wayland..."
read wayland_enable
if [[ ($wayland_enable == "wayland" || $wayland_enable == "w") ]]; then
	echo "-> Installing wayland..."
	pacman -S wayland wayland-prorocols wayland-utils
	wayland_pkg="plasma-wayland-session"
else
	echo "-> Installing xorg..."
	pacman -S xorg-server
fi

echo "-> Enabling freetype rendering..."
sed -i "/REETYPE_PROPERTIES/s/^#//g" /etc/profile.d/freetype2.sh
sed -i "s/^[ \t]*//" /etc/profile.d/freetype2.sh

echo "-> Installing KDE..."
pacman -S plasma-meta plasma-desktop sddm $wayland_pkg kscreen plasma-pa ffmpegthumbs dolphin konsole ark vlc kate

systemctl enable sddm

echo "================================="
echo "Finished, please reboot."


