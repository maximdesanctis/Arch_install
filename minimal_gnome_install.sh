#!/usr/bin/env bash

# add new user
useradd -m jogi
usermod -aG wheel jogi
passwd jogi
EDITOR=nano visudo | sed "s/# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL"

# install graphical utils
pacman -S xorg-server mesa nvidia nvidia-utils nvidia-settings nvidia-lts gdm --noconfirm --needed
systemctl enable gdm

# install audio
pacman -S pulseaudio pulseaudio-alsa --noconfirm --needed

# install bluetooth
pacman -S bluez bluez-utils --noconfirm --needed

# install minimal gnome
pacman -S gnome-shell gnome-terminal gnome-tweak-tool gnome-control-center xdg-user-dirs gnome-screenshot gnome-bluetooth --noconfirm --needed

# install additional sofware
pacman -S kinfocenter --noconfirm --needed

# install printing sofware
pacman -S hplip cups print-manager
systemctl enable org.cups.cupsd.service

reboot
