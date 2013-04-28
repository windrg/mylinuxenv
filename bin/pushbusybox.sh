#!/bin/sh 
adb shell mkdir /data/busybox
adb push ~/bin/busybox /data/busybox/busybox
