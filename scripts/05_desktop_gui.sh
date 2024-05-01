#!/bin/sh
# install xorg and pipewire
pacman -Sy sx xorg-xhost xorg-xrandr xorg-xkill alsa-utils pipewire pipewire-alsa pipewire-pulse wireplumber --needed --noconfirm
# install utils
pacman -S udisks2 wget usbutils playerctl duf yt-dlp flameshot ffmpeg perl-rename polikt-gnome --needed --noconfirm
# install qtile and GUI apps
pacman -S alacritty qtile python-xlib python-psutil lm_sensors nitrogen picom lxappearance-gtk3 gpicview libheif pcmanfm galculator atril mpv chezmoi --needed --noconfirm
# install input method, theme, icon, fonts
pacman -S fcitx5-chewing fcitx5-im breeze-icons noto-fonts noto-fonts-cjk noto-fonts-emoji noto-fonts-extra ttf-noto-nerd --needed --noconfirm
