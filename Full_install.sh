# WARNING
# This script was neither tested yet in a Virtual Machine nor on a physical computer
#!/bin/bash

echo "------------------------------------------"
echo "--          Installing ArchLinux        --"
echo "------------------------------------------"
echo "--      Make sure your device has a     --"
echo "--      connection to the internet      --"
echo "------------------------------------------"
echo "--If it hasn't yet, you probably need to--"
echo "--reboot after establishing a connection--"
echo "------------------------------------------"
echo ""


echo "------------------------------------------"
echo "--            Syncing clock             --"
echo "------------------------------------------"
timedatectl set-ntp true


echo "------------------------------------------"
echo "--  Downloading fresh package database  --"
echo "------------------------------------------"
pacman -Syy
sleep 5

echo "------------------------------------------"
echo "--             Partitioning             --"
echo "------------------------------------------"
lsblk
echo "Please enter disk to install Arch Linux on: (probably /dev/sda)"
read DISK

echo "------------------------------------------"
echo "--              Preparation             --"
echo "------------------------------------------"
sgdisk -Z ${DISK}           # destroying existing mbr/gpt structures on disk
sgdisk -a 2048 -o ${DISK}   # creating new gpt disk 2048 alignment

echo "------------------------------------------"
echo "--          Creating partitions         --"
echo "------------------------------------------"
sgdisk -n 1:0:+512M ${DISK} # partition 1 (ESP),  default start block, 512MB
sgdisk -n 2:0:+50G ${DISK}  # partition 2 (ROOT), default start,       50GB
sgdisk -n 3:0:0 ${DISK}     # partition 3 (HOME), default start,       remaining space

echo "------------------------------------------"
echo "--        Setting partition types       --"
echo "------------------------------------------"
sgdisk -t 1:ef00 ${DISK}    # EFI System
sgdisk -t 2:8300 ${DISK}    # Linux filesystem
sgdisk -t 3:8300 ${DISK}    # Linux filesystem 

echo "------------------------------------------"
echo "--        Setting up filesystems        --"
echo "------------------------------------------"
mkfs.fat -F32 "${DISK}1"  # Fat32 on first partition 
mkfs.ext4 "${DISK}2"      # ext4 on second partition 
mkfs.ext4 "${DISK}3"      # ext4 on third partition 

echo "------------------------------------------"
echo "--          Mounting partitions         --"
echo "------------------------------------------"
mkdir -p /mnt/boot/efi         #creating mountpoint for first partition (boot)
mkdir /mnt/home               #creating mountpoint for third partition (home)
mount "${DISK}2" /mnt         # mounting second partition
mount "${DISK}1" /mnt/boot/efi # mounting first partition
mount "${DISK}3" /mnt/home    # mounting third partition                             
sleep 10

echo "------------------------------------------"
echo "--         Installing base Arch         --"
echo "------------------------------------------"
pacstrap /mnt base base-devel linux linux-headers linux-lts linux-lts-headers linux-firmware git --noconfirm
genfstab -U /mnt >> /mnt/etc/fstab
sleep 10

echo "------------------------------------------"
echo "--    Changing root directory to /mnt   --"
echo "------------------------------------------"
arch-chroot /mnt


echo "------------------------------------------"
echo "--        Setting up root password      --"
echo "------------------------------------------"
passwd


echo "------------------------------------------"
echo "--            Installing GRUB           --"
echo "------------------------------------------"
pacman -S grub efibootmgr amd-ucode --noconfirm  # that may not be appropriate, depending on your CPU manufacturer
lsblk
echo "Please enter disk to install grub on: (probably /dev/sda)"
read DISK
grub-install "${DISK}"                                                                #ERROR:'grub-install: error: cannot find EFI directory.'
grub-mkconfig -o /boot/grub/grub.cfg


echo "------------------------------------------"
echo "--          Setting up network          --"
echo "------------------------------------------"
pacman -S networkmanager --noconfirm --needed
systemctl enable NetworkManager


echo "------------------------------------------"
echo "--          Setting up firewall         --"
echo "------------------------------------------"
pacman -S ufw --noconfirm --needed
ufw default deny incoming    # setting up sensible ufw default rules 
ufw default allow outgoing
systemctl enable ufw
ufw enable


echo "------------------------------------------"
echo "--      Downloading basic software      --"
echo "------------------------------------------"
pacman -S git nano vim bash-completion --noconfirm --needed


echo "------------------------------------------"
echo "--       Setting up locale things       --"
echo "--       Language: English              --"
echo "--       Keyboard: de-latin1            --"
echo "--       Timezone: Berlin, Germany      --"
echo "------------------------------------------"
echo KEYMAP=de-latin1 > /etc/vconsole.conf  # setting de-latin1 as keyboard layout 
echo ArchLinux >> /etc/hostname             # setting hostname
echo '127.0.0.1   localhost' >> /etc/hosts  # setting loopback address
echo '::1   localhost' >> /etc/hosts
timedatectl set-timezone Europe/Berlin      # setting timezone 
timedatectl set-ntp true                    # enabling NTP
timedatectl status                          # displaying status of the time
nano /etc/locale.gen | sed -e "s/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8"  # setting up language to English 
echo LANG=en_US.UTF-8 > /etc/locale.conf    
locale-gen
sed -e "s/kernel.sysrq = 16/kernel.sysrq = 1/g" /usr/lib/sysctl.d/50-default.conf  # enabling all kernel level shortcuts


echo "------------------------------------------"
echo "--         Preparing first reboot       --"
echo "------------------------------------------"
exit
umount "${DISK}p1"
umount "${DISK}p2"
umount "${DISK}p3"


echo "------------------------------------------"
echo "--               Rebooting              --"
echo "------------------------------------------"
reboot
