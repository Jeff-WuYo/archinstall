#!/bin/sh
pacstrap -K /mnt base linux linux-firmware intel-ucode udisks2 man vim reflector usbutils polkit opendoas apparmor ufw git xdg-user-dirs mold pigz lbzip2 p7zip zram-generator zsh zsh-autosuggestions zsh-completions zsh-history-substring-search zsh-syntax-highlighting starship
genfstab -U /mnt >> /mnt/etc/fstab
cp -r /etc/systemd/network/ /mnt/etc/systemd/
