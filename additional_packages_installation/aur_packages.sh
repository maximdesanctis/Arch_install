#!/bin/env bash

# yay installation
cd /opt
sudo git clone https://aur.archlinux.org/yay.git
cd /opt/yay
makepkg -si

declare -a programs=(
                    "visual-studio-code-bin"
                    "spotify")

for i in "${programs[@]}"
do
  yay -S "$i" --noconfirm --needed
done

reboot
