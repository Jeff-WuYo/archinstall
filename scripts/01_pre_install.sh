#!/usr/bin/env bash
timedatectl set-ntp true
timedatectl set-timezone Asia/Taipei
reflector -c TW -p https --sort rate --save /etc/pacman.d/mirrorlist
pacman -Sy archlinux-keyring --noconfirm --needed
sed -i 's/^#ParallelDownloads/ParallelDownloads/; s/^#Color/Color/' /etc/pacman.conf

# partition disk
unset -v ans1
read -p "Do you want to partiton disk now? (yes/no): " ans1
while [ ! "$ans1" = yes ]; do
    if [ "$ans1" = no ]; then
        echo "Stop partitioning, abort!"
        unset -v ans1
        exit 101
    elif [ "$ans1" = exit ]; then
        echo "Stop partitioning, abort!"
        unset -v ans1
        exit 101
    else
        read -p "Do you want to partiton disk now? Please answer yes or no: " ans1
    fi
done

unset -v ans1 dis ans2
lsblk
read -p "Which disk do you want to install? (/dev/<disk_to_install>): " dis
read -p "Is $dis correct? All the data will be lost (yes/no): " ans2
while [ ! "$ans2" = yes ]; do
    if [ "$ans2" = no ]; then
        lsblk
        read -p "Which disk do you want to install? (/dev/<disk_to_install>): " dis
        read -p "Is $dis correct? All the data will be lost (yes/no): " ans2
    elif [ "$ans2" = exit ]; then
        echo "Abort!"
        unset -v dis ans2
        exit 102
    else
        read -p "Is $dis correct? All the data will be lost, Please answer yes or no: " ans2
    fi
done

sgdisk -Z /dev/$dis && 
sgdisk -og /dev/$dis && 
sgdisk -n 1:2048:+260M -n 2:0:+1G -n 3:0:0 -t 1:ef00 -t 2:ea00 -t 3:8300 -c 1:ESP -c 2:BOOT -c 3:LINUX_ROOT /dev/$dis
sgdisk -p /dev/$dis

# format partiton
[[ "$dis" =~ "nvme" ]] && par="$dis"p || par="$dis"
mkfs.fat -n ESP -F32 /dev/"$par"1
mkfs.ext4 -L BOOT /dev/"$par"2
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
btrfs subv create /mnt/@Steam &&
btrfs subv create /mnt/@Games &&
btrfs subv set-default /mnt/@ &&
umount /mnt &&

# mount partition and subv
mount -o rw,noatime,compress=zstd,subvolid=256 /dev/$rpar /mnt &&
mkdir -p /mnt/{boot,efi,home,var/{log,cache,tmp,docker,lib/libvirt/images}} &&
mount -o rw,noatime,compress=zstd,subvolid=257 /dev/$rpar /mnt/home &&
mount -o rw,noatime,compress=zstd,subvolid=258 /dev/$rpar /mnt/var/cache &&
mount -o rw,noatime,compress=zstd,subvolid=259 /dev/$rpar /mnt/var/log &&
mount -o rw,noatime,compress=zstd,subvolid=260 /dev/$rpar /mnt/var/tmp &&
mount -o rw,noatime,compress=zstd,subvolid=261 /dev/$rpar /mnt/var/lib/libvirt/images &&
mount -o rw,noatime,compress=zstd,subvolid=262 /dev/$rpar /mnt/var/docker &&
mount /dev/"$par"1 /mnt/efi &&
mount /dev/"$par"2 /mnt/boot
