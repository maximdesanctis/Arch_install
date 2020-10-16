#!/bin/bash

declare -a programs=("spectacle"
                     "kate"
                     "gwenview"
                     "kinfocenter"
                     "codeblocks"
                     "xterm"
                     "pycharm-community-edition"
                     "keepassxc")

for i in "${programs[@]}"
do
  pacman -S "$i" --noconfirm --needed
done
