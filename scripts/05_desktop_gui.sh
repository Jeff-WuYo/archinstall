#!/usr/bin/env bash
qtile_xorg() {
  pacman -S sx xorg-xhost xorg-xkill picom qtile flameshot xorg-xrandr --needed --noconfirm
  pacman -S --asdeps alsa-utils libpulse lm_sensors python-dbus-next python-psutil python-setproctitle python-xdg --needed --noconfirm
}

qtile_wayland() {
  pacman -S qtile grim swayidle wlr-randr --needed --noconfirm
  pacman -S --asdeps alsa-utils libinput libpulse lm_sensors python-dbus-next python-psutil python-pywayland python-pywlroots python-setproctitle python-xdg python-xkbcommon xorg-xwayland xdg-desktop-portal xdg-desktop-portal-gtk xdg-desktop-portal-wlr slurp wl-clipboard --needed --noconfirm
}

river() {
  pacman -S river grim swayidle wlr-randr --needed --noconfirm
  pacman -S --asdeps xdg-desktop-portal xdg-desktop-portal-gtk xdg-desktop-portal-wlr slurp wl-clipboard --needed --noconfirm
}

utils() {
  pacman -S alacritty udisks2 wget usbutils playerctl perl-rename polikt-gnome zsh-autosuggestions zsh-completions zsh-history-substring-search zsh-syntax-highlighting zoxide neovim chezmoi starship --needed --noconfirm
}

others() {
  pacman -S fcitx5-chewing fcitx5-im papirus-icon-theme noto-fonts noto-fonts-cjk noto-fonts-emoji noto-fonts-extra ttf-noto-nerd yt-dlp mpv galculator atril pcmanfm-qt nwg-look --needed --noconfirm
  pacman -S --asdeps lxqt-archiver gvfs-mtp fzf --needed --noconfirm
}

wm_list=( qtile_xorg qtile_wayland none )

printf "Which WM do you want to install?\n"
select wm in "${wm_list[@]}"; do
  case $wm in
    qtile_xorg) qtile_xorg ; utils ; others ; break ;;
    qtile_wayland) qtile_wayland ; utils ; others ; break ;;
    none) printf "Done!\n" ; exit 0 ;;
    *) printf "Invalid choise, please try again. \n"
  esac
done
