#!/usr/bin/env bash
pacstrap -K /mnt base linux linux-firmware terminus-font intel-ucode udisks2 man vim reflector usbutils polkit opendoas apparmor ufw git xdg-user-dirs mold pigz lbzip2 p7zip zram-generator zsh grml-zsh-config
genfstab -U /mnt >> /mnt/etc/fstab
cp -r /etc/systemd/network/ /mnt/etc/systemd/
