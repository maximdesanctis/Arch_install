#!/usr/bin/env bash

# add new user
useradd -m jogi
usermod -aG wheel jogi
passwd jogi
EDITOR=nano visudo | sed -e 's/# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL'

# install graphical utils
pacman -S xorg-server
pacman -S mesa nvidia nvidia-utils nvidia-lts --noconfirm --needed

# install audio
pacman -S pulsaudio

#install bluetooth
pacman -S bluez bluez-utils
