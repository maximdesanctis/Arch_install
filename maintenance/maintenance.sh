# update mirrorlist
sudo mv /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak
sudo curl -s "https://www.archlinux.org/mirrorlist/?country=DE&protocol=http&protocol=https&ip_version=4&ip_version=6&use_mirror_status=on" | sed -e "s/^#Server/Server/g" > /etc/pacman.d/mirrorlist

# update system
sudo pacman -Syu
yay -Syu

# clean cached pacman and AUR files
sudo pacman -S pacman-contrib --noconfirm --needed
sudo paccache -r
sudo pacman -Sc
sudo pacman -Rns $(pacman -Qtdq)
yay -Yc

# clean chached files and logs
sudo rm -rf .cache/*
sudo journalctl --vacuum-time=2weeks
