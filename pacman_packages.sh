#!/bin/bash

declare -a programs=("spectacle"
                     "kinfocenter"
                     "")

for i in "${programs[@]}"
do
  pacman -S "$i" --noconfirm --needed
done
