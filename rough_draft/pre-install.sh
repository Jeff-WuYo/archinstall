#!/bin/zsh
timedatectl set-ntp true
timedatectl set-timezone Asia/Taipei
reflector -c TW -p https --sort rate --save /etc/pacman.d/mirrorlist
pacman -Sy archlinux-keyring --needed
