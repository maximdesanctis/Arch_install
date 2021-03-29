# WARNING
# This script was neither tested yet in a Virtual Machine nor on a physical computer


echo "------------------------------------------"
echo "--         Preparing first reboot        --"
echo "------------------------------------------"
sudo exit

umount "${DISK}p1"
umount "${DISK}p2"
umount "${DISK}p3"


echo "------------------------------------------"
echo "--               Rebooting              --"
echo "------------------------------------------"
sudo reboot


echo "------------------------------------------"
echo "--         Installing Essentials        --"
echo "------------------------------------------"
echo "--      Make sure your device has a     --"
echo "--      connection to the internet      --"
echo "------------------------------------------"
echo "--If it hasn't yet, you probably need to--"
echo "--reboot after establishing a connection--"
echo "------------------------------------------"
echo ""


echo "Please enter a username:"            # adding a new user
read USER
useradd -m $USER
usermod -aG wheel $USER
echo "Please enter password for the user:" # assigning a password to it 
passwd $USER
sed -i "s/# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/g" /etc/sudoers  # giving root privileges to the group wheel
pacman -S xdg-user-dirs xorg-server xorg-xrandr mesa amd amd-utils amd-settings amd-lts amd-prime sddm sddm-kcm pulseaudio --noconfirm --needed
pacman -S pulseaudio-alsa bluez bluez-utils pulseaudio-bluetooth plasma-desktop konsole dolphin firefox latte-dock plasma-nm --noconfirm --needed
pacman -S bluedevil plasma-pa powerdevil plasma-thunderbolt hplip cups print-manager
xdg-user-dirs-update
systemctl enable sddm
systemctl enable bluetooth
systemctl enable cups
cp /etc/cups/cupsd.conf /etc/cups/cupsd.conf.bak
gpg --full-gen-key

reboot
