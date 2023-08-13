#!/bin/zsh
# install xorg and pipewire
pacman -Sy xorg-server xorg-xhost xorg-xinit xorg-xrandr xorg-xkill alsa-utils pipewire pipewire-alsa pipewire-pulse wireplumber --needed --noconfirm
# install utils
pacman -S udisks2 wget usbutils playerctl duf yt-dlp flameshot ffmpeg perl-rename --needed --noconfirm
# install qtile and GUI apps
pacman -S alacritty qtile python-xlib python-psutil lm_sensors nitrogen picom lxappearance-gtk3 gpicview pcmanfm libheif galculator atril mpv --needed --noconfirm
# install input method, theme, icon
pacman -S ibus-chewing breeze-icons --needed --noconfirm
