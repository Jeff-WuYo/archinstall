#!/usr/bin/env bash
timedatectl set-ntp true
timedatectl set-timezone Asia/Taipei
reflector -c TW -p https --sort rate --save /etc/pacman.d/mirrorlist
pacman -Sy archlinux-keyring --noconfirm --needed
sed -i 's/^#ParallelDownloads/ParallelDownloads/; s/^#Color/Color/' /etc/pacman.conf

# partition disk
unset -v ans1
while true; do
  read -p "Do you want to partition disk now? (yes/no): " ans1
  case $ans1 in
    [Yy]|[Yy]es) break ;;
    [Nn]|[Nn]o) printf "Abort!\n" ; unset -v ans1 ; exit 101 ;;
    exit|quit) printf "Abort!\n" ; unset -v ans1 ; exit 101 ;;
    *) printf "Please answer yes or no, exit to quit.\n" ;;
  esac
done

unset -v ans1 dis ans2
lsblk -o NAME,SIZE,MODEL
disks=( $(lsblk -d -n -o NAME -e 7,11,253) exit )
printf "Which disk do you want to install? (select number)\n"
select dis in "${disks[@]}"; do
  if [[ $REPLY -ge 1 && $REPLY -le ${#disks[@]} ]] &>/dev/null; then
    [ "$dis" = exit ] && exit 102
    while true; do
      read -p $'Is \033[1m'"$dis"$'\033[0m correct? All data will be \033[1mlost\033[0m: \n' ans2
      case $ans2 in
        [Yy]|[Yy]es) break 2 ;;
        [Nn]|[Nn]o) unset -v dis ; break ;;
        exit|quit) printf "Abort!\n" ; unset -v dis ans2 ; exit 103 ;;
        *) printf "Please answer yes or no.\n" ;;
      esac
    done
  else
    printf "Invalid choise, please try again.\n"
  fi
done

sgdisk -Z /dev/$dis && 
sgdisk -og /dev/$dis && 
sgdisk -I -n 1:2048:+260M -n 2:0:+1G -n 3:0:0 -t 1:ef00 -t 2:ea00 -t 3:8300 -c 1:ESP -c 2:BOOT -c 3:LINUX_ROOT /dev/$dis
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
mount -o rw,noatime,subvolid=261 /dev/$rpar /mnt/var/lib/libvirt/images &&
mount -o rw,noatime,compress=zstd,subvolid=262 /dev/$rpar /mnt/var/docker &&
mount /dev/"$par"1 /mnt/efi &&
mount /dev/"$par"2 /mnt/boot
