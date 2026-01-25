#!/bin/bash
#this script create multiboot bios and uefi usb flash drive at DEVICE
set -x
SCRIPT_PATH=$(dirname "$0")

#DEVICE=
DEVICE="/dev/sdb"

if [[ -z "$DEVICE" ]]; then
  echo "ERROR: Var DEVICE is empty. Set the usb flash drive device to work with"
  exit 1
fi

echo "Do you want to remove all data from device ""$DEVICE"" ?"
select yes_answer in "yes"; do
  case $yes_answer in
    yes ) break;;
    *) echo "ERROR: not yes" ; exit 1;;
  esac
done

echo "SCRIPT BEGIN"

apt install grub2 grub2-common

sfdisk --delete $DEVICE
echo -e 'size=1G, type=uefi\n size=1G, type=b\n size=+ type=L\n' | sfdisk $DEVICE
mkfs.fat -F 32 -n Multiboot "$DEVICE""1"
mkfs.vfat -F 32 -n Multiboot "$DEVICE""2"
mkfs.ext4 -F -E lazy_itable_init "$DEVICE""3"
sfdisk --activate $DEVICE 1 2

mkdir /tmp/usb{1,2,3}
mount "$DEVICE""1" /tmp/usb1/
mount "$DEVICE""2" /tmp/usb2/
mount "$DEVICE""3" /tmp/usb3/
grub-install --force --removable --target=x86_64-efi --boot-directory=/tmp/usb1/boot --efi-directory=/tmp/usb1/ $DEVICE
grub-install --force --removable --target=i386-pc --boot-directory=/tmp/usb2/ /dev/sdb

mkdir /tmp/iso_files
wget releases.ubuntu.com/24.04/ubuntu-24.04.3-desktop-amd64.iso -P /tmp/iso_files/
wget releases.ubuntu.com/24.04/ubuntu-24.04.3-live-server-amd64.iso -P /tmp/iso_files/
wget download.mikrotik.com/routeros/7.20.7/mikrotik-7.20.7.iso -P /tmp/iso_files/
wget tinycorelinux.net/16.x/x86/release/TinyCore-current.iso -P /tmp/iso_files/
rsync -ah --progress /tmp/iso_files/*.iso /tmp/usb3/

UUID_EFI_DISK=$(blkid "$DEVICE""1" --output value -s UUID)
UUID_BIOS_DISK=$(blkid "$DEVICE""2" --output value -s UUID)
UUID_ISO_DISK=$(blkid "$DEVICE""3" --output value -s UUID)
sed "s/REPLACE_ME_BOOT_DISK_UUID/$UUID_EFI_DISK/g" "$SCRIPT_PATH""/grub.cfg" |  sed -e "s/REPLACE_ME_ISO_DISK_UUID/$UUID_ISO_DISK/g" > /tmp/usb1/boot/grub/grub.cfg
sed "s/REPLACE_ME_BOOT_DISK_UUID/$UUID_BIOS_DISK/g" "$SCRIPT_PATH""/grub.cfg" |  sed -e "s/REPLACE_ME_ISO_DISK_UUID/$UUID_ISO_DISK/g" > /tmp/usb2/grub/grub.cfg

umount /tmp/usb1/
umount /tmp/usb2/
umount /tmp/usb3/

echo "SCRIPT END"
