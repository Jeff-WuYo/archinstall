#!/bin/sh
ln -sf /usr/share/zoneinfo/Asia/Taipei /etc/localtime
# locale configuration
sed -i 's/#en_US.UTF-8/en_US.UTF-8/; s/#zh_TW.UTF-8/zh_TW.UTF-8/' /etc/locale.gen && locale-gen
echo "archmobo" > /etc/hostname
echo "permit persist :wheel" > /etc/doas.conf
systemctl enable systemd-networkd.service
systemctl enable systemd-resolved.service
sed -i 's/#NTP=/NTP=time.stdtime.gov.tw/' /etc/systemd/timesyncd.conf && timedatectl set-ntp true
sed -i 's/^#ParallelDownloads/ParallelDownloads/; s/^#Color/Color/' /etc/pacman.conf
systemctl enable apparmor.service
systemctl enable ufw.service
#systemctl enable systemd-zram-setup@zram0.service
#systemctl enable fstrim.timer
#systemctl enable fstrim.service
# install bootloader, configure systemd-boot
bootctl --esp-path=/efi --boot-path=/boot install &&
cp /usr/share/systemd/bootctl/arch.conf /boot/loader/entries/ &&
sed -i "s/PARTUUID=XXXX/$(blkid | awk '/'"$(awk '/256/ {print $1}' /etc/fstab | tr -d UUID=)"'/ {print$NF}' | tr -d \")/; s/rootfstype=XXXX/rootfstype=btrfs/" /boot/loader/entries/arch.conf
sed -i '/options/s/$/ intel_iommu=on iommu=pt lsm=landlock,lockdown,yama,integrity,apparmor,bpf audit=1/' /boot/loader/entries/arch.conf
[ -f /boot/intel-ucode.img ] && sed -i '6i initrd  /intel-ucode.img' /boot/loader/entries/arch.conf
[ -f /boot/amd-ucode.img ] && sed -i '6i initrd  /amd-ucode.img' /boot/loader/entries/arch.conf
# configure boot entries
[ -f /boot/initramfs-linux-lts.img ] && cp /boot/loader/entries/arch.conf /boot/loader/entries/arch-lts.conf && sed -i 's/Linux/Linux LTS/; s/-linux/-linux-lts/g' /boot/loader/entries/arch-lts.conf
[ -f /boot/initramfs-linux-zen.img ] && cp /boot/loader/entries/arch.conf /boot/loader/entries/arch-zen.conf && sed -i 's/Linux/Linux Zen/; s/-linux/-linux-zen/g' /boot/loader/entries/arch-zen.conf
[ -f /boot/initramfs-linux-hardened.img ] && cp /boot/loader/entries/arch.conf /boot/loader/entries/arch-hardened.conf && sed -i 's/Linux/Linux Hardened/; s/-linux/-linux-hardened/g' /boot/loader/entries/arch-hardened.conf
[ -f /boot/initramfs-linux-rt.img ] && cp /boot/loader/entries/arch.conf /boot/loader/entries/arch-rt.conf && sed -i 's/Linux/Linux Realtime/; s/-linux/-linux-rt/g' /boot/loader/entries/arch-rt.conf
[ -f /boot/initramfs-linux-rt-lts.img ] && cp /boot/loader/entries/arch.conf /boot/loader/entries/arch-rt-lts.conf && sed -i 's/Linux/Linux Realtime LTS/; s/-linux/-linux-rt-lts/g' /boot/loader/entries/arch-rt-lts.conf
echo "Please add user maunally, and setup password."
