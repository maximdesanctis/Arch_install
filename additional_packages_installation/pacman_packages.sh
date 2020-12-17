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
  "speedtest-cli"
  "nmap"
  "ettercap"
  "man-db"
  "ethtool"
  "htop"


# development utils
  "python"
  "python-pip"
  "pycharm-community-edition"
  "virtualbox"
  "wireshark-qt"
  "gparted"
  "arduino"
  "arduino-avr-core"

# desktop utils
  "spectacle"
  "kate"
  "gwenview"
  "kinfocenter"
  "keepassxc"
  "dragon"
  "filelight"

# system utils
  "tlp"
  
)

for i in "${programs[@]}"
do
  pacman -S "$i" --noconfirm --needed
done

# configure newly installed services
usermod -aG wireshark jogi
usermod -aG uucp jogi
usermod -aG lock jogi
pip install pyserial        # python import for arduino

reboot
