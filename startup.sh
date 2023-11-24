#!/bin/sh
# Checking if is running in Repo Folder
if [ "$(basename "$(pwd)")" = archinstall ]; then
    echo "Starting installation..."
    chmod +x ./scripts/*.sh &&
    exec ./scripts/01_pre_install.sh &&
    exec ./scripts/02_pacstrap.sh &&
    cp -r ./configs/etc/ /mnt/
    mkdir -p /mnt/root/archinstall/scripts &&
    cp --parents ./scripts/03_configure_system.sh ./scripts/04_desktop_gui.sh /mnt/root/archinstall/scripts/ &&
    arch-chroot /mnt /root/archinstall/scripts/03_configure_system.sh
else
    echo "Please run ./startup.sh at archinstall directory."
    exit
fi