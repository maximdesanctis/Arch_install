#!/bin/env bash

# yay installation
cd /opt
sudo git clone https://aur.archlinux.org/yay.git
cd /opt/yay
makepkg -si

declare -a programs=(

# development utils
  "visual-studio-code-bin"
  "android-studio"
  
)

for i in "${programs[@]}"
do
  yay -S "$i" --noconfirm --needed
done

reboot
