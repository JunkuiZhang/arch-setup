#!/bin/bash

echo "=== TESTING ==="

# sed -i "/BottomUp/s/^#//g" temp_file
# sed -i "s/^[ \t]*//" temp_file
# cat ~/.ssh/id_ed25519.pub > ~/Desktop/pub_key.txt
# echo "GTK_IM_MODULE=fcitx" >> temp_file
# echo -e "GTK_IM_MODULE=fcitx
# QT_IM_MODULE=fcitx
# XMODIFIERS=@im=fcitx
#
# INPUT_METHOD=fcitx
# SDL_IM_MODULE=fcitx
# GLFW_IM_MODULE=ibus" >> temp_file
# sed -i "/^HOOKS=(/ s/^\(.*\)\(filesystems\)/\1lvm2 \2/" temp_file
# echo -e "--disable-features=UseChromeOSDirectVideoDecoder --enable-features=VaapiVideoDecoder --ignore-gpu-blocklist --use-gl=desktop\n" > temp_file

config_file="variable"
wayland_pkg=""
echo "wayland?"
read wayland_enable

if [[ ($wayland_enable == "wayland" || $wayland_enable == "w") ]]; then
	echo "Wayland enable!"
	wayland_pkg="plasma-wayland-session"
	echo "wayland_enable=\"true\"" > $config_file
else
	echo "Xorg enable!"
	echo "wayland_enable=\"false\"" > $config_file
fi

