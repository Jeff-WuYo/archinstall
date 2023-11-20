#!/bin/sh
ln -sf /usr/share/zoneinfo/Asia/Taipei /etc/localtime
# locale configuration
sed -i.bkp 's/#en_US.UTF-8/en_US.UTF-8/; s/#zh_TW.UTF-8/zh_TW.UTF-8/' /etc/locale.gen && locale-gen
touch /etc/hostname && echo "archmobo" > /etc/hostname
touch /etc/doas.conf && echo "permit persist :wheel" > /etc/doas.conf
systemctl enable systemd-networkd.service
systemctl enable systemd-resolved.service
sed -i.bkp 's/#NTP=/NTP=time.stdtime.gov.tw/' /etc/systemd/timesyncd.conf && timedatectl set-ntp true
systemctl enable apparmor.service
systemctl enable ufw.service
#systemctl enable fstrim.timer
#systemctl enable fstrim.service
# install bootloader, configure systemd-boot
bootctl install &&
cp /usr/share/systemd/bootctl/arch.conf /boot/loader/entries/ &&
sed -i "s/PARTUUID=XXXX/$(blkid | awk '/btrfs/ {print $NF}' | tr -d \")/; s/rootfstype=XXXX/rootfstype=btrfs/" /boot/loader/entries/arch.conf
# adding user will be an maunal process for now.
