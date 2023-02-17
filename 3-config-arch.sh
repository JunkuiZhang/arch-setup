#!/bin/bash

config_file="config"
source $config_file

echo "============================================"
echo "=============== Configure Arch Linux ==============="
echo "============================================"

echo ""
echo "=============== Setup Softwares =================="

echo "-> Configurig terminal..."
mkdir -p ~/.config/wezterm
cp ./wezterm ~/.config/wezterm/

echo "-> Installing git..."
sudo pacman -S git openssh
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
cd ~
git clone https://aur.archlinux.org/paru-bin.git
cd paru-bin
makepkg -si
cd ~
rm -rf paru-bin

echo "-> Configuring paru..."
sudo sed -i "/Color/s/^#//g" /etc/pacman.conf
sudo sed -i "/BottomUp/s/^#//g" /etc/paru.conf

echo "-> Installing rust..."
paru -S rustup
sed -i '/bashrc/i export RUSTUP_UPDATE_ROOT=https://mirrors.ustc.edu.cn/rust-static/rustup\nexport RUSTUP_DIST_SERVER=https://mirrors.ustc.edu.cn/rust-static\n' ~/.bash_profile
source ~/.bash_profile
rustup default stable

echo "-> Configuring cargo..."
mkdir -p ~/.cargo
echo -e "[source.crates-io]
registry = \"https://github.com/rust-lang/crates.io-index\"
replace-with = 'sjtu'

[source.sjtu]
registry = \"https://mirrors.sjtug.sjtu.edu.cn/git/crates.io-index/\"" > ~/.cargo/config

echo "-> Installing chrome..."
paru -S google-chrome

echo "-> Configuring chrome..."
mkdir -p ~/.config
echo -e "--disable-features=UseChromeOSDirectVideoDecoder --enable-features=VaapiVideoDecoder --ignore-gpu-blocklist --use-gl=desktop\n" > ~/.config/chrome-flags.conf

echo "-> Installing v2rayA..."
paru -S v2ray v2raya-bin
sudo systemctl enable --now v2raya

echo "Please configure v2rayA..."
echo "http://localhost:2017"
echo "Input anything to continue after finish configuration."
read void_input

echo "-> Installing neofetch..."
paru -S neofetch

echo "-> Chinese input..."
paru -S fcitx5 fcitx5-configtool fcitx5-gtk fcitx5-qt fcitx5-chinese-addons

echo "Please configure input method..."
echo "Input anything to continue."
read void_input

# echo "-> Configuring input enviroment variable..."
# sudo cp /etc/environment temp_file
# sudo echo -e "GTK_IM_MODULE=fcitx
# QT_IM_MODULE=fcitx
# XMODIFIERS=@im=fcitx
# INPUT_METHOD=fcitx
# SDL_IM_MODULE=fcitx
# GLFW_IM_MODULE=ibus" >> temp_file
# sudo cp temp_file /etc/environment
# sudo rm temp_file

echo "-> Configure vscode..."
paru -S visual-studio-code-bin
paru -S libdbusmenu-glib gnome-keyring clang
git clone https://github.com/JunkuiZhang/LightGreen.git
mkdir -p ~/.vscode/extensions
mv LightGreen ~/.vscode/extensions

echo "Please setup Clangd for vscode..."
echo "Input anything to continue..."
echo "Path to clangd:"
whereis clangd
read void_input

echo "=============== Configuring Drivers ==============="

echo "-> NTFS support..."
paru -S ntfsprogs-ntfs3

echo "=> Using touchpad? y or n"
read touchpad_enable

if [[ ($touchpad_enable == "y" && $wayland == "false") ]]; then
	echo "-> Touchpad support..."
	paru -S touchegg touche
	sudo systemctl enable touchegg
	mkdir -p ~/.config/touchegg
	cp touchpad_config ~/.config/touchegg/touchegg.conf
	echo "Done."
else
	echo "Skip..."
fi

echo "=============== System Theme ==============="

echo "-> Copying wallpapers into Pictures folder..."
cp -r ./wallpapers/. ~/Pictures

echo "Input anything to continue..."
read void_input

echo "\n"
echo "========================"
echo "=== Finished Install ==="
echo "========================"
