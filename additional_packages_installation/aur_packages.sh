#!/bin/env bash

# you need to have yay installed

declare -a programs=(
                    "visual-studio-code-bin"
                    "spotify")

for i in "${programs[@]}"
do
  yay -S "$i" --noconfirm --needed
done

reboot
