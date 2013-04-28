#!/bin/sh
#sudo mount -t cifs -o user='Administrator',password='tka123tjd',uid='1001',gid='1001' //10.90.5.84/source source
#mkdir /tmp/sharewithq330
#sudo mount -t cifs -o user='Administrator',password='tka123tjd',uid='1000',gid='1000' //cyp510/Sharewithq330 /tmp/sharewithq330
mkdir /home/cy13shin/sharewithq330
#sudo mount -t cifs -o user='Administrator',password='tka123tjd',uid='1000',gid='1000' //cyp510/Sharewithq330 ~/sharewithq330
#sudo mount -t cifs -o user='Administrator',password='tka123tjd',uid='1000',gid='1000' //10.90.5.74/Sharewithq330 ~/sharewithq330
sudo mount -t cifs -o user='Administrator',password='tka123tjd',uid='1000',gid='1000' //10.90.5.74/sharewithq330 /home/cy13shin/sharewithq330
df -h

