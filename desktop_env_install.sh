#!/usr/bin/env bash

# add new user
useradd -m jogi
usermod -aG wheel jogi
passwd jogi
EDITOR=nano visudo | sed -e "s/# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL"

# install graphical utils
pacman -S xorg-server mesa nvidia nvidia-utils nvidia-settings nvidia-lts sddm--noconfirm --needed
systemctl enable sddm

# install audio
pacman -S pulsaudio pulseaudio-alsa --noconfirm --needed

# install bluetooth
pacman -S bluez bluez-utils --noconfirm --needed

# install kde
pacman -S plasma-desktop konsole dolphin firefox gedit --noconfirm --needed

# install kde themes
pacman -S breeze-gtk breeze-kde5 kde-gtk-config --noconfirm --needed

# install kde addons
pacman -S kdeplasman-addons --noconfirm --needed

# install useful kde managers
pacman -S plasma-nm bluedevil plasma-pa cups print-manager system-config-manager powerdevil --noconfirm --needed

# install additional sofware
pacman -S kinfocenter spectacle --noconfirm --needed

reboot
