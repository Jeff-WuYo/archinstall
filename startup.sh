#!/usr/bin/env bash
set -euo pipefail
setfont ter-132n

# Checking if is running in Repo Folder
if [ "$(basename "$(pwd)")" = archinstall ]; then
    echo "Starting installation..."
    pacman -S efifs --needed --noconfirm
    chmod u+x ./scripts/0*.sh &&
    source ./scripts/01_pre_install.sh &&
    source ./scripts/02_pacstrap.sh &&
    cp -r ./configs/etc/ /mnt/
    mkdir -p /mnt/efi/EFI/systemd/drivers/ &&
    cp -r /usr/lib/efifs-x64/ext2_x64.efi /usr/lib/efifs-x64/btrfs_x64.efi /usr/lib/efifs-x64/xfs_x64.efi /mnt/efi/EFI/systemd/drivers/
    mkdir -p /mnt/root/archinstall/scripts &&
    cp ./scripts/03_configure_system.sh ./scripts/04_user_setup.sh ./scripts/05_desktop_gui.sh /mnt/root/archinstall/scripts/ &&
    arch-chroot /mnt /usr/bin/bash /root/archinstall/scripts/03_configure_system.sh
else
    echo "Please run ./startup.sh at archinstall directory."
    exit
fi
