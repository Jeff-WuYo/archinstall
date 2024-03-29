#!/bin/sh
# install xorg and pipewire
pacman -Sy xorg-server xorg-xhost xorg-xinit xorg-xrandr xorg-xkill alsa-utils pipewire pipewire-alsa pipewire-pulse wireplumber --needed --noconfirm
# install utils
pacman -S udisks2 wget usbutils playerctl duf yt-dlp flameshot ffmpeg perl-rename polikt-gnome --needed --noconfirm
# install qtile and GUI apps
pacman -S alacritty qtile python-xlib python-psutil lm_sensors nitrogen picom lxappearance-gtk3 gpicview libheif pcmanfm libheif galculator atril mpv chezmoi --needed --noconfirm
# install input method, theme, icon, fonts
pacman -S ibus-chewing breeze-icons noto-fonts noto-fonts-cjk noto-fonts-emoji noto-fonts-extra ttf-noto-nerd --needed --noconfirm
