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
sgdisk -Z ${DISK}           # destroy existing mbr or gpt structures on disk
sgdisk -a 2048 -o ${DISK}   # new gpt disk 2048 alignment

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
mkfs.fat -F32 "${DISK}p1"  # Fat32 on first partition 
mkfs.ext4 "${DISK}p2"      # ext4 on second partition 
mkfs.ext4 "${DISK}p3"      # ext4 on third partition 

echo "------------------------------------------"
echo "--          Mounting partitions         --"
echo "------------------------------------------"
mkdir -p /mnt/boot/efi      #creating mountpoint for first partition (boot)
mkdir /mnt/home             #creating mountpoint for third partition (home)
mount "${DISK}p1" /mnt/boot/efi # mounting first partition 
mount "${DISK}p2" /mnt          # mounting second partition  
mount "${DISK}p3" /mnt/home/    # mounting third partition 


echo "--------------------------------------"
echo "--        Arch Base Install         --"
echo "--------------------------------------"
pacstrap /mnt base base-devel linux linux-headers linux-lts linux-lts-headers linux-firmware git --noconfirm
genfstab -U /mnt >> /mnt/etc/fstab


echo "------------------------------------------"
echo "--    Changing root directory to /mnt   --"
echo "------------------------------------------"
arch-chroot /mnt
