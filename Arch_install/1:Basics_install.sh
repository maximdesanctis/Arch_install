# WARNING
# This script was neither tested yet in a Virtual Machine nor on a physical computer

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
mkdir -p /mnt/boot/efi         # creating mountpoint for first partition (boot)
mkdir /mnt/home               # creating mountpoint for third partition (home)
sleep 2
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
echo ""
echo "Now enter: $curl -O https://raw.githubusercontent.com/maxobaerchen/Arch_install/master/Arch_install/Setup%20(Step%202).sh"
arch-chroot /mnt
