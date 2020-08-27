#!/usr/bin/env bash


echo "--------------------------------------"
echo "--       Root Password Setup        --"
echo "--------------------------------------"
passwd
clear


echo "--------------------------------------"
echo "--  Bootloader Grub Installation    --"
echo "--------------------------------------"
pacman -S grub efibootmgr intel-ucode --noconfirm
clear
lsblk
echo "Please enter disk to install grub on: (example /dev/sda)"
read DISK
grub-install "${DISK}"
grub-mkconfig -o /boot/grub/grub.cfg
clear


echo "--------------------------------------"
echo "--          Network Setup           --"
echo "--------------------------------------"
pacman -S networkmanager --noconfirm --needed
systemctl enable NetworkManager
clear


echo "--------------------------------------"
echo "--         Firewall Setup           --"
echo "--------------------------------------"
pacman -S ufw --noconfirm --needed
ufw default deny incoming
ufw default allow outgoing
systemctl enable ufw
clear


echo "--------------------------------------"
echo "--       Basic Software Setup       --"
echo "--------------------------------------"
pacman -S git nano vim bash-completion --noconfirm --needed
clear


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

# set language
nano /etc/locale.gen | sed -e 's/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8'
echo LANG=en_US.UTF-8 > /etc/locale.conf
locale-gen
clear


echo "After exiting arch-chroot and then umounting all partitions from /mnt, you're system is ready for the first reboot"
