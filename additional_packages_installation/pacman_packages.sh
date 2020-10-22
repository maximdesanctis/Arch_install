#!/bin/bash

declare -a programs=("spectacle"
                     "kate"
                     "gwenview"
                     "kinfocenter"
                     "pycharm-community-edition"
                     "keepassxc"
                     "dragon"
                     "virtualbox"
                     "nfs-utils"
                     "openssh")

for i in "${programs[@]}"
do
  pacman -S "$i" --noconfirm --needed
done

systemctl enable libvirtd
reboot
