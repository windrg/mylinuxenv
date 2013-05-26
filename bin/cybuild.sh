#!/bin/sh
start_time_string=$(date '+%m-%d-%y_%H:%M:%S')
start_time=$(date '+%s')
logfile=build_$start_time_string.log

#ccache
./prebuilts/misc/linux-x86/ccache/ccache -M 50G

# main build command
./build.sh universal_ss222ap all 2>&1 | tee $logfile

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
rm ./kernel/samsung/shannon222ap-tn/vmlinux.c
aobjdump -Sdlx ./kernel/samsung/shannon222ap-tn/vmlinux > ./kernel/samsung/shannon222ap-tn/vmlinux.c &
ls -al ./out/target/product/universal_ss222ap/
echo "***************************************************" | tee -a $logfile

exit
