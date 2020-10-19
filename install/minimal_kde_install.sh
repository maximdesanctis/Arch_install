#!/usr/bin/env bash

# add new user
useradd -m jogi
usermod -aG wheel jogi
echo "Please enter password for jogi:"
passwd jogi
sed -i "s/# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/g" /etc/sudoers
pacman -S xdg-user-dirs --noconfirm --needed
xdg-user-dirs-update

# install graphical utils
pacman -S xorg-server xorg-xrandr mesa nvidia nvidia-utils nvidia-settings nvidia-lts nvidia-prime sddm --noconfirm --needed
systemctl enable sddm

# install audio
pacman -S pulseaudio pulseaudio-alsa --noconfirm --needed

# install bluetooth
pacman -S bluez bluez-utils pulseaudio-bluetooth --noconfirm --needed
systemctl enable bluetooth

# install kde
pacman -S plasma-desktop konsole dolphin firefox --noconfirm --needed

# install latte-dock
pacman -S latte-dock --noconfirm --needed

# install useful kde managers
pacman -S plasma-nm bluedevil plasma-pa powerdevil plasma-thunderbolt --noconfirm --needed

# install printing sofware
pacman -S hplip cups print-manager --noconfirm --needed
systemctl enable org.cups.cupsd.service
cp /etc/cups/cupsd.conf /etc/cups/cupsd.conf.bak

reboot
