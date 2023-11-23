#!/bin/sh
ln -sf /usr/share/zoneinfo/Asia/Taipei /etc/localtime
# locale configuration
sed -i 's/#en_US.UTF-8/en_US.UTF-8/; s/#zh_TW.UTF-8/zh_TW.UTF-8/' /etc/locale.gen && locale-gen
touch /etc/hostname && echo "archmobo" > /etc/hostname
touch /etc/doas.conf && echo "permit persist :wheel" > /etc/doas.conf
systemctl enable systemd-networkd.service
systemctl enable systemd-resolved.service
sed -i 's/#NTP=/NTP=time.stdtime.gov.tw/' /etc/systemd/timesyncd.conf && timedatectl set-ntp true
systemctl enable apparmor.service
systemctl enable ufw.service
systemctl enable systemd-zram-setup@zram0.service
#systemctl enable fstrim.timer
#systemctl enable fstrim.service
# install bootloader, configure systemd-boot
bootctl install &&
cp /usr/share/systemd/bootctl/arch.conf /efi/loader/entries/ &&
sed -i "s/PARTUUID=XXXX/$(blkid | awk '/'"$(awk '/256/ {print $1}' /etc/fstab | tr -d UUID=)"'/ {print$NF}' | tr -d \")/; s/rootfstype=XXXX/rootfstype=btrfs/" /efi/loader/entries/arch.conf
sed -i '/options/s/$/intel_iommu=on iommu=pt lsm=landlock,lockdown,yama,integrity,apparmor,bpf audit=1/' /efi/loader/entries/arch.conf
# adding user will be an maunal process for now.
