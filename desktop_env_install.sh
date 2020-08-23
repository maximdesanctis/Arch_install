#!/usr/bin/env bash

# add new user
useradd -m jogi
usermod -aG wheel jogi
passwd jogi
EDITOR=nano visudo | sed -e 's/# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL'

# install graphical utils
pacman -S xorg-server mesa nvidia nvidia-utils nvidia-settings nvidia-lts --noconfirm --needed

# install audio
pacman -S pulsaudio --noconfirm --needed

#install bluetooth
pacman -S bluez bluez-utils --noconfirm --needed
