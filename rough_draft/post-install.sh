#!/bin/zsh
ln -sf /usr/share/zoneinfo/Asia/Taipei /etc/localtime
# edit /locale.gen
# locale-gen
touch /etc/hostname && echo "archmobo" > /etc/hostname
touch /etc/doas.conf && echo "permit persist :wheel"
systemctl enable systemd-networkd.service
systemctl enable systemd-resolved.service
systemctl enable fstrim.service
systemctl enable apparmor.service
systemctl enable ufw.service
# install bootloader, configure systemd-boot
# adding user will be an maunal process for now.
