#!/bin/bash
#install latest cmake from kitware repo Ubuntu 24.04 22.04 20.04

apt-get remove cmake -y
rm -rf /etc/apt/sources.list.d/kitware.list
apt-get update
apt-get install ca-certificates gpg wget lsb-release -y

test -f /usr/share/doc/kitware-archive-keyring/copyright ||
wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | gpg --dearmor - | tee /usr/share/keyrings/kitware-archive-keyring.gpg >/dev/null

UBUNTU_VERSION=$(lsb_release -cs)
echo "deb [signed-by=/usr/share/keyrings/kitware-archive-keyring.gpg] https://apt.kitware.com/ubuntu/ ""$UBUNTU_VERSION"" main" | tee /etc/apt/sources.list.d/kitware.list >/dev/null
apt-get update

test -f /usr/share/doc/kitware-archive-keyring/copyright ||
rm /usr/share/keyrings/kitware-archive-keyring.gpg
apt-get install kitware-archive-keyring -y
apt-get install cmake -y
