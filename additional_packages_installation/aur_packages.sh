#!/bin/env bash

# you need to have yay installed

declare -a programs=()

for i in "${programs[@]}"
do
  yay -S "$i" --noconfirm --needed
done

reboot
