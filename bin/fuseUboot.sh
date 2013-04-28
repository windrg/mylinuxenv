su root
fastboot reboot
fastboot devices
fastboot flash fwbl1 ./E4270_S.bl1.bin 
fastboot flash fwbl2 ./E4270_S.bl2.bin 
fastboot flash bootloader ./u-boot.bin 
fastboot flash tzsw ./E4270_S.tzsw.bin 
