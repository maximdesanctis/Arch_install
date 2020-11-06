#!/bin/bash

declare -a programs=(

# terminal utils
  "rsync"
  "openssh"
  "nfs-utils"
  "usbutils"
  "cronie"
  "curl"
  "wget"
  "bash-completion"
  "vim"
  "nano"
  "git"


# development utils
  "pycharm-community-edition"
  "virtualbox"
  "wireshark-qt"
  "gparted"

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

# configure newly installed services
usermod -aG wireshark jogi

reboot
