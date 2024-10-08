# WARNING
# This script hasn't been tested yet
# Error in line 58

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
grub-install "${DISK}"                                                                
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
nano /etc/locale.gen | sed -e "s/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/g"  # setting up language to English 
echo LANG=en_US.UTF-8 > /etc/locale.conf    
locale-gen
sed -e "s/kernel.sysrq = 16/kernel.sysrq = 1/g" /usr/lib/sysctl.d/50-default.conf  # enabling all kernel level shortcuts


echo "------------------------------------------"
echo "--         Preparing first reboot        --"
echo "------------------------------------------"
echo "Now enter: exit"
echo "And: curl -o Step3 https://raw.githubusercontent.com/maxobaerchen/Arch_install/master/Arch_install/3%3AEssentials_install.sh"
