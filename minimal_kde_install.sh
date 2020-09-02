#!/usr/bin/env bash

# add new user
useradd -m jogi
usermod -aG wheel jogi
echo "Please enter password for jogi:"
passwd jogi
EDITOR=nano visudo | sed -e "s/# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL"
pacman -S xdg-user-dirs --noconfirm --needed
xdg-user-dirs-update

# install graphical utils
pacman -S xorg-server mesa nvidia nvidia-utils nvidia-settings nvidia-lts sddm --noconfirm --needed
systemctl enable sddm

# install audio
pacman -S pulseaudio --noconfirm --needed

# install bluetooth
pacman -S bluez --noconfirm --needed

# install kde
pacman -S plasma-desktop konsole dolphin firefox gedit --noconfirm --needed

# install latte-dock
pacman -S latte-dock --noconfirm --needed

# install useful kde managers
pacman -S plasma-nm bluedevil plasma-pa powerdevil --noconfirm --needed

# install additional sofware
pacman -S kinfocenter spectacle --noconfirm --needed

# install printing sofware
pacman -S hplip cups print-manager --noconfirm --needed
systemctl enable org.cups.cupsd.service

reboot
