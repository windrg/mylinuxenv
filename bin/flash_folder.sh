#!/bin/bash
sudo ls $1/*.img

echo "***** Flash "

sudo /home/pe/bin/fastboot flash system $1/system.img
sudo /home/pe/bin/fastboot flash boot $1/boot.img
sudo /home/pe/bin/fastboot reboot