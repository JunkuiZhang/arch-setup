#!/bin/bash

config_file="variable"

source $config_file
echo "wayland enable: $wayland_enable"

if [[ $wayland_enable == "true" ]]; then
	echo "Wayland detected!"
else
	echo "Xorg detected!"
fi

