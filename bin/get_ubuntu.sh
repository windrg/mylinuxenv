#!/bin/sh
sudo apt-get build-dep --no-install-recommends linux-image-$(uname -r)
apt-get source linux-image-$(uname -r)
