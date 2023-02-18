#!/bin/bash

# echo '"Boot with default options"   "root=/dev/sda1"' > temp.conf
echo "Input something.."
read variable
if [[ ($variable == "y") ]]; then
	echo "type yes"
	variable=no
else
	echo "type no"
	variable=yes
fi

echo $variable

