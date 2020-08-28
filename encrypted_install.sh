#!/usr/bin/env bash

echo "-------------------------------------------------"
echo "Setting up mirrors for optimal download - Germany Only"
echo "-------------------------------------------------"
echo "--        Creating mirrorlist backup           --"
echo "-------------------------------------------------"
timedatectl set-ntp true
mv /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak
curl -s "https://www.archlinux.org/mirrorlist/?country=DE&protocol=http&protocol=https&ip_version=4&ip_version=6&use_mirror_status=on" | sed -e "s/^#Server/Server/g" > /etc/pacman.d/mirrorlist
pacman -Syy
clear


echo "--------------------------------------"
echo "--          Partitioning            --"
echo "--------------------------------------"
lsblk
echo "Please enter disk to install Arch Linux on: (example /dev/sda)"
read DISK

# disk prep
sgdisk -Z ${DISK} # destroy existing mbr or gpt structures on disk
sgdisk -a 2048 -o ${DISK} # new gpt disk 2048 alignment

# create partitions
sgdisk -n 1:0:+512M ${DISK} # partition 1 (ESP), default start block, 512MB
sgdisk -n 2:0:+30G ${DISK} # partition 2 (ROOT), default start, 30GB
sgdisk -n 3:0:0 ${DISK} # partition 3 (HOME), default start, remaining space

# set partition types
sgdisk -t 1:ef00 ${DISK}
sgdisk -t 2:8300 ${DISK}
cryptsetup luksFormat "${DISK}3"
cryptsetup open "${DISK}3" home

# label partitions
sgdisk -c 1:"ESP" ${DISK}
sgdisk -c 2:"ROOT" ${DISK}
sgdisk -c 3:"HOME" ${DISK}

# make filesystems
mkfs.fat -F32 "${DISK}1"
mkfs.ext4 "${DISK}2"
mkfs.ext4 /dev/mapper/home

# mount partitions
mount "${DISK}2" /mnt
mkdir -p /mnt/boot/efi
mount "${DISK}1" /mnt/boot/efi
mkdir /mnt/home
mount /dev/mapper/home /mnt/home
lsblk
