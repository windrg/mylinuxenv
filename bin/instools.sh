#!/bin/sh
sudo apt-get install fakeroot build-essential crash kexec-tools makedumpfile kernel-wedge kernel-package
sudo apt-get build-dep linux
sudo apt-get install git-core libncurses5 libncurses5-dev libelf-dev asciidoc binutils-dev
sudo apt-get install distcc distccmon-gnome vim sshfs meld gnome-commander cscope exuberant-ctags
