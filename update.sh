#!/bin/bash

echo "=== Updating Wezterm ==="
mkdir -p temp
git clone https://github.com/catppuccin/wezterm.git temp/
mkdir -p ~/.config/wezterm/colors
cp ./temp/Catppuccin.toml ~/.config/wezterm/colors/

echo "Cleaning..."
rm -rf ./temp/

echo "=== Finshed ==="
rm -rf ./temp

