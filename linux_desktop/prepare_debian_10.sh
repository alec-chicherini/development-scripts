#!/bin/bash
#prepare debian 10 to for test
DEBIAN_REPOSYTORY="
deb     http://deb.debian.org/debian $(lsb_release -cs) main contrib non-free
deb-src http://deb.debian.org/debian $(lsb_release -cs) main contrib non-free
#
deb     http://deb.debian.org/debian $(lsb_release -cs)-updates main contrib non-free
deb-src http://deb.debian.org/debian $(lsb_release -cs)-updates main contrib non-free
#
deb     http://security.debian.org/ $(lsb_release -cs)/updates main contrib non-free
deb-src http://security.debian.org/ $(lsb_release -cs)/updates main contrib non-free
#
"
echo "$DEBIAN_REPOSYTORY" | sudo tee /etc/apt/sources.list.d/debian_reposytory.list > /dev/null

apt update && apt install task-lxqt-desktop xrdp locales locale-gen
echo startlxqt > ~/.xsession
systemctl restart xrdp
#passwd #
