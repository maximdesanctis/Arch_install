#!/bin/bash

declare -a programs=("spectacle"
                     "kate"
                     "gwenview"
                     "kinfocenter"
                     "pycharm-community-edition"
                     "keepassxc"
                     "dragon"
                     "virt-manager"
                     "qemu"
                     "qemu-arch-extra"
                     "ovmf"
                     "vde2"
                     "ebtables"
                     "dnsmasq"
                     "openbsd-netcat")

for i in "${programs[@]}"
do
  pacman -S "$i" --noconfirm --needed
done

systemctl enable libvirtd
