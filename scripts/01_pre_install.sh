#!/bin/sh
timedatectl set-ntp true
timedatectl set-timezone Asia/Taipei
reflector -c TW -p https --sort rate --save /etc/pacman.d/mirrorlist
pacman -Sy archlinux-keyring --noconfirm --needed
sed -i 's/^#ParallelDownloads/ParallelDownloads/; s/^#Color/Color/' /etc/pacman.conf
# partition disk
read -p "Do you want to partiton disk now? (yes/no): " ans1
if [ $ans1 = "yes" ]; then
    lsblk
    echo "Which disk do you want to install?"
    read -p "(/dev/<disk_to_install>): " dis
    read -p "Is $dis correct? All the data will be lost (yes/no): " ans2
    if [ $ans2 = "yes" ]; then
        sgdisk -Z /dev/$dis && 
        sgdisk -og /dev/$dis && 
        sgdisk -n 1:2048:+260M -n 2:0:+1G -n 3:0:0 -t 1:ef00 -t 2:ea00 -t 3:8300 -c 1:ESP -c 2:BOOT -c 3:LINUX_ROOT /dev/$dis
    sgdisk -p /dev/$dis
    else
        echo "partition disk failed, abort!"
        exit 102
    fi
else
    echo "partition disk failed, abort!"
    exit 101
fi
# format partiton
[[ "$dis" =~ "nvme" ]] && par="$dis"p || par="$dis"
mkfs.fat -n ESP -F32 /dev/"$par"1
mkfs.fat -n BOOT -F32 /dev/"$par"2
mkfs.btrfs -f -L LINUX_ROOT /dev/"$par"3
rpar="$par"3

# create btrfs subv
umount -A -R /mnt
mount /dev/$rpar /mnt &&
btrfs subv create /mnt/@ &&
btrfs subv create /mnt/@home &&
btrfs subv create /mnt/@cache &&
btrfs subv create /mnt/@log &&
btrfs subv create /mnt/@tmp &&
btrfs subv create /mnt/@images &&
btrfs subv create /mnt/@docker &&
btrfs subv set-default /mnt/@ &&
umount /mnt &&

# mount partition and subv
mount -o rw,noatime,compress=zstd,subvolid=256 /dev/$rpar /mnt &&
mkdir -p /mnt/{boot,efi,home,tmp,docker,var/{log,cache,lib/libvirt/images}} &&
mount -o rw,noatime,compress=zstd,subvolid=257 /dev/$rpar /mnt/home &&
mount -o rw,noatime,compress=zstd,subvolid=258 /dev/$rpar /mnt/var/cache &&
mount -o rw,noatime,compress=zstd,subvolid=259 /dev/$rpar /mnt/var/log &&
mount -o rw,noatime,compress=zstd,subvolid=260 /dev/$rpar /mnt/var/tmp &&
mount -o rw,noatime,compress=zstd,subvolid=261 /dev/$rpar /mnt/var/lib/libvirt/images &&
mount -o rw,noatime,compress=zstd,subvolid=262 /dev/$rpar /mnt/var/docker &&
mount /dev/"$par"1 /mnt/efi &&
mount /dev/"$par"2 /mnt/boot
