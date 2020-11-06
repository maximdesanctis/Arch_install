#!/bin/bash

declare -a programs=(

# terminal utils
"rsync"
"openssh"
"nfs-utils"

# development utils
"pycharm-community-edition"
"virtualbox"

# desktop utils
  "spectacle"
  "kate"
  "gwenview"
  "kinfocenter"
  "keepassxc"
  "dragon"
  
)

for i in "${programs[@]}"
do
  pacman -S "$i" --noconfirm --needed
done

systemctl enable libvirtd
reboot
