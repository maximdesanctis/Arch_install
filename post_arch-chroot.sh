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



echo "--------------------------------------"
echo "--         Firewall Setup           --"
echo "--------------------------------------"
pacman -S ufw
ufw default deny incoming
ufw default allow outgoing
systemctl ufw enable
sleep 5


echo "--------------------------------------"
echo "--         Software Setup           --"
echo "--------------------------------------"
pacman -S git nano vim bash-completion
