#!/usr/bin/env bash

echo "--------------------------------------"
echo "--  Bootloader Grub Installation    --"
echo "--------------------------------------"
pacman -S grub efibootmgr efivar --noconfirm
lsblk
echo "Please enter disk to install grub on: (example /dev/sda)"
read DISK
grub-install "${DISK}"
grub-mkconfig -o /boot/grub/grub.cfg


echo "--------------------------------------"
echo "--          Network Setup           --"
echo "--------------------------------------"
pacman -S networkmanager wpa_supplicant wireless_tools --noconfirm --needed
systemctl enable NetworkManager
