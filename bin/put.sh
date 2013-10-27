#!/bin/sh
#echo BlackBooks.zip
#adb push BlackBooks.zip /storage/sdcard0
#echo Game.of.Thrones.S03E05.PROPER.HDTV.XviD-AFG.avi 
#adb push Game.of.Thrones.S03E05.PROPER.HDTV.XviD-AFG.avi /storage/sdcard0
#echo Game.of.Thrones.S03E05.PROPER.HDTV.XviD-AFG.smi
#adb push Game.of.Thrones.S03E05.PROPER.HDTV.XviD-AFG.smi /storage/sdcard0
#echo Game.of.Thrones.S03E05.PROPER.HDTV.XviD-AFG_k.smi
#adb push Game.of.Thrones.S03E05.PROPER.HDTV.XviD-AFG_k.smi /storage/sdcard0
#echo Spartacus.S03E09.720p.HDTV.x264-EVOLVE.mkv
#adb push Spartacus.S03E09.720p.HDTV.x264-EVOLVE.mkv /storage/sdcard0
#echo Spartacus.S03E09.720p.HDTV.x264-EVOLVE.smi
#adb push Spartacus.S03E09.720p.HDTV.x264-EVOLVE.smi /storage/sdcard0
#echo Spartacus.S03E09.720p.HDTV.x264-EVOLVE_e.smi
#adb push Spartacus.S03E09.720p.HDTV.x264-EVOLVE_e.smi /storage/sdcard0
#echo Spartacus.S03E09.720p.HDTV.x264-EVOLVE_k.smi
#adb push Spartacus.S03E09.720p.HDTV.x264-EVOLVE_k.smi /storage/sdcard0
for i in *
do
	echo "$i"
	adb push $i /storage/sdcard0
done
