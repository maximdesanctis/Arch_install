#!/usr/bin/env bash

echo "--------------------------------------"
echo "--  Bootloader Grub Installation    --"
echo "--------------------------------------"
pacman -S grub efibootmgr efivar intel-ucode --noconfirm
lsblk
echo "Please enter disk to install grub on: (example /dev/sda)"
read DISK
grub-install "${DISK}"
grub-mkconfig -o /boot/grub/grub.cfg


echo "--------------------------------------"
echo "--          Network Setup           --"
echo "--------------------------------------"
pacman -S networkmanager wpa_supplicant wireless_tools dialog --noconfirm --needed
systemctl enable NetworkManager



echo "--------------------------------------"
echo "--         Firewall Setup           --"
echo "--------------------------------------"
pacman -S ufw
ufw default deny incoming
ufw default allow outgoing
systemctl enable ufw
sleep 5


echo "--------------------------------------"
echo "--       Basic Software Setup       --"
echo "--------------------------------------"
pacman -S git nano vim bash-completion --noconfirm --needed


echo "--------------------------------------"
echo "--          Locale Setup            --"
echo "--------------------------------------"
# set german keyboard layout
echo KEYMAP=de-latin1 > /etc/vconsole.conf

# set hostname and loopback address
echo ArchLinuxTest > /etc/hostname
echo '127.0.0.1   localhost' > /etc/hosts
echo '::1   localhost' > /etc/hosts

# set timezone and enable ntp
timedatectl set-timezone Europe/Berlin
timedatectl set-ntp true
timedatectl status
sleep 5

# set language
nano /etc/locale.gen | sed -e 's/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8'
echo LANG=en_US.UTF-8 > /etc/locale.conf
locale-gen


echo "--------------------------------------"
echo "--       Root Password Setup        --"
echo "--------------------------------------"
passwd

echo 'After umounting all partitions from "/mnt", you're system is ready for the first reboot'
exit
