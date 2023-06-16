#!/bin/zsh
pacstrap -K /mnt base linux linux-firmware intel-ucode udisks2 man vim zsh reflector git xdg-user-dirs p7zip usbutils polkit opendoas zsh-autosuggestions zsh-completions zsh-history-substring-search zsh-syntax-highlighting starship
genfstab -U /mnt >> /mnt/etc/fstab
cp -r /etc/systmed/network/ /mnt/etc/systemd/
