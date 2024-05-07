#!/usr/bin/env bash
pacstrap -K /mnt base linux linux-firmware intel-ucode udisks2 man vim zsh reflector git xdg-user-dirs p7zip usbutils polkit opendoas zsh-autosuggestions zsh-completions zsh-history-substring-search zsh-syntax-highlighting starship apparmor ufw
genfstab -U /mnt >> /mnt/etc/fstab
cp -r /etc/systemd/network/ /mnt/etc/systemd/
