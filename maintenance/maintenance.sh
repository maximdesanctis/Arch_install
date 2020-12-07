# update mirrorlist
mv /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak
curl -s "https://www.archlinux.org/mirrorlist/?country=DE&protocol=http&protocol=https&ip_version=4&ip_version=6&use_mirror_status=on" | sed -e "s/^#Server/Server/g" > /etc/pacman.d/mirrorlist

# update system
pacman -Syu
yay -Syu

# clean cached pacman and AUR files
pacman -S pacman-contrib --noconfirm --needed
paccache -r
pacman -Sc
pacman -Rns $(pacman -Qtdq)
yay -Yc

# clean chached files and logs
rm -rf .cache/*
journalctl --vacuum-time=2weeks
