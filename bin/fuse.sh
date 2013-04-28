#!/bin/sh
su root
fastboot devices
fastboot flash kernel zImage
fastboot flash ramdisk ./ramdisk.img
fastboot flash system ./system.img
fastboot flash -w
fastboot flash userdata ./userdata.img
fastboot reboot
