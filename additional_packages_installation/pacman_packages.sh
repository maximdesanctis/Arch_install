#!/bin/bash

declare -a programs=("spectacle"
                     "kate"
                     "gwenview"
                     "kinfocenter"
                     "pycharm-community-edition"
                     "keepassxc"
                     "dragon")

for i in "${programs[@]}"
do
  pacman -S "$i" --noconfirm --needed
done
