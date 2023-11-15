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
systemctl enable fstrim.timer
# install bootloader, configure systemd-boot
bootctl install &&
cp /usr/share/systemd/bootctl/arch.conf /boot/loader/entries/
# adding user will be an maunal process for now.
