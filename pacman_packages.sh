#!/bin/bash

declare -a programs=("spectacle"
                     "kinfocenter"
                     "codeblocks"
                     "pycharm-community-edition"
                     "keepassxc"
                     "plasma-thunderbolt")

for i in "${programs[@]}"
do
  pacman -S "$i" --noconfirm --needed
done
