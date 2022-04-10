#!/bin/bash

echo "=== TESTING ==="

# sed -i "/BottomUp/s/^#//g" temp_file
# sed -i "s/^[ \t]*//" temp_file
# cat ~/.ssh/id_ed25519.pub > ~/Desktop/pub_key.txt
# echo "GTK_IM_MODULE=fcitx" >> temp_file
# sed -i '/bashrc/i export RUSTUP_UPDATE_ROOT=https://mirrors.ustc.edu.cn/rust-static/rustup\nexport RUSTUP_DIST_SERVER=https://mirrors.ustc.edu.cn/rust-static\n' temp_file
# echo -e "[source.crates-io]\nregistry = \"https://github.com/rust-lang/crates.io-index\"\nreplace-with = 'sjtu'\n\n[source.sjtu]\nregistry = \"https://mirrors.sjtug.sjtu.edu.cn/git/crates.io-index/\"" > temp_file
echo -e "GTK_IM_MODULE=fcitx
QT_IM_MODULE=fcitx
XMODIFIERS=@im=fcitx

INPUT_METHOD=fcitx
SDL_IM_MODULE=fcitx
GLFW_IM_MODULE=ibus" >> temp_file
