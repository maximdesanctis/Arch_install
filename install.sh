#!/usr/bin/env bash

echo "-------------------------------------------------"
echo "Setting up mirrors for optimal download - Germany Only"
echo "-------------------------------------------------"
echo "--        Creating mirrorlist backup           --"
echo "-------------------------------------------------"
timedatectl set-ntp true
mv /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak
curl -s "https://www.archlinux.org/mirrorlist/?country=DE&protocol=http&protocol=https&ip_version=4&ip_version=6&use_mirror_status=on" | sed -e 's/^#Server/Server/' -e '/^#/d' | rankmirrors -n 5 - > /etc/pacman.d/mirrorlist
pacman -Syy



echo -e "\nInstalling prereqs...\n$HR"

echo "-------------------------------------------------"
echo "--          select your disk to format         --"
echo "-------------------------------------------------"
lsblk
echo "Please enter disk: (example /dev/sda)"
read DISK
echo "--------------------------------------"
echo -e "\nFormatting disk...\n$HR"
echo "--------------------------------------"

# disk prep
sgdisk -Z ${DISK} # destroy existing mbr or gpt structures on disk
sgdisk -a 2048 -o ${DISK} # new gpt disk 2048 alignment

# create partitions
sgdisk -n 1:0:+1000M ${DISK} # partition 1 (ESP), default start block, 1GB
sgdisk -n 2:0:+30G ${DISK} # partition 2 (ROOT), default start, 30GB
sgdisk -n 3:0:0 ${DISK} # partition 3 (HOME), default start, remaining space

# set partition types
sgdisk -t 1:ef00 ${DISK}
sgdisk -t 2:8300 ${DISK}
sgdisk -t 3:8300 ${DISK}

# label partitions
sgdisk -c 1:"ESP" ${DISK}
sgdisk -c 2:"ROOT" ${DISK}
sgdisk -c 3:"HOME" ${DISK}

# make filesystems
echo -e "\nCreating Filesystems...\n$HR"

mkfs.vfat -F32 "${DISK}1"
mkfs.ext4 "${DISK}2"
mkfs.ext4 "${DISK}3"

# mount partitions
mkdir /mnt
mount "${DISK}2" /mnt
mkdir /mnt/boot
mkdir /mnt/boot/efi
mount "${DISK}1" /mnt/boot/
mkdir /mnt/home
mount "${DISK}3" /mnt/home/

echo "--------------------------------------"
echo "--   Arch Install on Main Drive     --"
echo "--------------------------------------"
pacstrap /mnt base base-devel linux linux-headers linux-firmware linux-lts linux-lts-headers vim nano bash-completion --noconfirm
genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt

echo "--------------------------------------"
echo "--  Bootloader Grub Installation    --"
echo "--------------------------------------"
pacman -S grub efibootmgr efivar intel-ucode --noconfirm
grub-install "${DISK}"
grub-mkconfig -o /boot/grub/grub.cfg

echo "--------------------------------------"
echo "--          Network Setup           --"
echo "--------------------------------------"
pacman -S networkmanager wpa_supplicant wireless_tools --noconfirm
systemctl enable NetworkManager

echo "--------------------------------------"
echo "--      Set Password for Root       --"
echo "--------------------------------------"
echo "Enter password for root user: "
passwd root

exit
umount -R /mnt

echo "--------------------------------------"
echo "--   SYSTEM READY FOR FIRST BOOT    --"
echo "--------------------------------------"
