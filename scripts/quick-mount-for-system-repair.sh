#!/bin/sh
# this script mount the btrfs system as originaly installed.
lsblk
read -p "What disk did os install to?: " dis
if [[ "$dis" =~ "nvme" ]]; then
    par="$dis"p
else
    par="$dis"
fi
rpar="$dis"3
umount -A -R /mnt
mount -o rw,noatime,compress=zstd,subvolid=256 /dev/$rpar /mnt &&
mount -o rw,noatime,compress=zstd,subvolid=257 /dev/$rpar /mnt/home &&
mount -o rw,noatime,compress=zstd,subvolid=258 /dev/$rpar /mnt/var/cache &&
mount -o rw,noatime,compress=zstd,subvolid=259 /dev/$rpar /mnt/var/log &&
mount -o rw,noatime,compress=zstd,subvolid=260 /dev/$rpar /mnt/var/lib/libvirt/images &&
mount /dev/"$par"1 /mnt/efi &&
mount /dev/"$par"2 /mnt/boot &&
echo "Mounting done."
