#!/bin/sh
# show distcc stat
distccmon-gnome &

start_time_string=$(date '+%m-%d-%y_%H:%M:%S')
start_time=$(date '+%s')
logfile=build_$start_time_string.log


# main build command
#KBUILD_VERBOSE=1 MAKEFLAGS="CC=distcc gcc" fakeroot make-kpkg --initrd --stem linux --revision=20121119cykernel kernel_image kernel_headers 2>&1 | tee $logfile
KBUILD_VERBOSE=1 MAKEFLAGS="HOSTCC=/usr/bin/gcc CCACHE_PREFIX=distcc" fakeroot make-kpkg --initrd --stem linux --revision=20121119cykernel kernel_image kernel_headers 2>&1 | tee $logfile
#KBUILD_VERBOSE=1 fakeroot make-kpkg --initrd --stem linux --revision=20121119cykernel kernel_image kernel_headers 2>&1 | tee $logfile
#KBUILD_VERBOSE=1 MAKEFLAGS="CC=distcc gcc" fakeroot make-kpkg --initrd --stem linux --revision=20121119cykernel kernel_image kernel_headers 2>&1 | tee $logfile

end_time_string=$(date '+%m-%d-%y_%H:%M:%S')
end_time=$(date '+%s')
build_time=$(echo "$end_time-$start_time" | bc)

hr=$(echo "$build_time/3600" | bc)
min=$(echo "($build_time/60)-($hr*60)" | bc)
sec=$(echo "$build_time -(($build_time/60)*60)" | bc)

echo "" | tee -a $logfile
echo "" | tee -a $logfile

echo "***************************************************" | tee -a $logfile
echo "" | tee -a $logfile
echo " 		Build Summary " | tee -a $logfile
echo "- Start Time 	: $start_time_string" | tee -a $logfile
echo "- End Time 	: $end_time_string" | tee -a $logfile
echo "- Elapsed Time 	: $hr:$min:$sec" | tee -a $logfile
echo "" | tee -a $logfile
echo "***************************************************" | tee -a $logfile

exit
