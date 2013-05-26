#!/bin/sh
mkdir /tmp/sharewithq330
sudo mount -t cifs -o user='Administrator',password='tka123tjd',uid='1000',gid='1000' //10.254.220.185/sharewithq330 /tmp/sharewithq330
df -h
