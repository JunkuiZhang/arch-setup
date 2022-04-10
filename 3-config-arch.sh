#!/bin/bash

echo "============================"
echo "=== Configure Arch Linux ==="
echo "============================"

echo "\n"
echo "Please make sure you have configured Opencore!"
echo "\n"

sleep 5

cd ~

echo "=== Setup Softwares ==="

echo "-> Installing git..."
sudo pacman -S git
echo "Enter your git email address:"
read git_email
git config --global user.email "$git_email"
echo "Enter your git user name:"
read git_name
git config --global user.name "$git_name"

echo "-> Configuring SSH..."
echo "Please select all to default and no password."
ssh-keygen -t ed25519 -C "$git_email"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
echo "Saving your ssh pub key to desktop..."
cat ~/.ssh/id_ed25519.pub > ~/Desktop/pub_key.txt

echo "-> Installing paru..."
git clone https://aur.archlinux.org/paru-bin.git
cd paru
makepkg -si
cd ~
rm -rf ~/paru

echo "-> Configuring paru..."
sudo sed -i "/Color/s/^#//g" /etc/pacman.conf
sudo sed -i "/BottomUp/s/^#//g" /etc/paru.conf

echo "-> Installing rust..."
paru -S rustup
cp bash_profile.bk ~/.bash_profile
source ~/.bash_profile
rustup default stable

echo "-> Configuring cargo..."
mkdir -p ~/.cargo
cp cargo_config ~/.cargo/config

echo "-> Installing v2rayA..."
paru -S v2ray v2raya-bin
sudo systemctl enable --now v2raya

echo "Please configure v2rayA..."
echo "Input anything to continue after finish configuration."
read void_input

echo "-> Installing neofetch..."
paru -S neofetch

echo "-> Chinese input..."
paru -S fcitx5 fcitx5-configtool fcitx5-gtk fcitx5-qt fcitx5-chinese-addons

echo "Please configure input method..."
echo "Input anything to continue."
read void_input

echo "-> Configuring input enviroment variable..."
sudo cp input_envir_file /etc/environment

echo "-> Configure vscode..."
paru -S visual-studio-code-bin
paru -S libdbusmenu-glib gnome-keyring clang

echo "Please setup vscode..."
echo "Input anything to continue..."
echo "Path to clangd:"
whereis clangd
read void_input

echo "=== Configuring Drivers ==="
echo "-> Vulkan support..."
echo "Using intel? y or n"
read intel_is_used

if [[ $intel_is_used == "y" ]]; then
	paru -S vulkan-intel xf86-video-intel
	sudo sysctl dev.i915.perf_stream_paranoid=0
	echo "Intel done."
else
	paru -S vulkan-radeon xf86-video-amdgpu
	echo "AMD done."
fi

echo "-> NTFS support..."
paru -S ntfs-3g

echo "=> Using touchpad? y or n"
read touchpad_enable

if [[ $touchpad_enable == "y" ]]; then
	echo "-> Touchpad support..."
	paru -S touchegg touche
	sudo systemctl enable touchegg
	mkdir -p ~/.config/touchegg
	cp touchpad_config ~/.config/touchegg/touchegg.conf
	echo "Done."
else
	echo "Skip..."
fi

echo "=== System Theme ==="
paru -S kvantum latte-dock

echo "Please configure latte dock..."
echo "Input anything to continue..."
read void_input

echo "=== Configure Terminal ==="
echo "Please follow blog to configure."

