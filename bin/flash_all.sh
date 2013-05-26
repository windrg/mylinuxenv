#!/bin/bash -f
#su root

BOOTLOADER_DIR=../BootLoader/20130214
KERNEL_DIR=kernel/shannon222ap
PLATFORM_DIR=out/target/product/universal_ss222ap

#fastboot flash fwbl1       $BOOTLOADER_DIR/E4270_S.bl1.bin 
#fastboot flash bl2         $BOOTLOADER_DIR/E4270_S.bl2.bin 
#fastboot flash tzsw        $BOOTLOADER_DIR/E4270_S.tzsw.bin 
#fastboot flash bootloader  $BOOTLOADER_DIR/u-boot.bin 
fastboot flash kernel      $PLATFORM_DIR/zImage
fastboot flash ramdisk     $PLATFORM_DIR/ramdisk.img
fastboot -w
fastboot flash system      $PLATFORM_DIR/system.img
fastboot flash userdata    $PLATFORM_DIR/userdata.img
fastboot reboot
exit
