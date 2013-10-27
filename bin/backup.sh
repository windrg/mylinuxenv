#!/bin/sh 
timestamp=$(date '+%m%d%y_%H%M%S')

echo "Copying home...!!!"
cp /etc/hosts ~/bin/
mkdir ~/ws/backup
cp -rvf ~/bin ~/ws/backup
cp -rvf ~/.vim ~/ws/backup
cp ~/.bashrc ~/ws/backup
cp ~/.vimrc ~/ws/backup
cp ~/.vimrc ~/ws/backup
cp -rvf ~/ws/mytools/ ~/ws/backup/

#echo "Copying mail...!!!"
#if test -f /tmp/sharewithq330/mail.zip 
#then
	#cp /tmp/sharewithq330/mail.zip ~/ws/backup
#else
	#echo "Couldn't get mail!!"
	#exit 1
#fi

echo "Archiving....!!!"
cd ~/ws/
tar cvf backup_$timestamp.tar ~/ws/backup 
echo "done"
