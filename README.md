# DISCLAIMER
This script is not perfect, if you don't understand the scripts, don't use it.\
Adding user to exisiting group is not supported by default, the script **force** you to create new user and group. You can change the line in `scripts/03_configure_system.sh` to use `adduser` from slackware, or edit `scripts/04_user_setup.sh` to suit your needs.

## Archinstall
Archlinux install script \
This script will do a minimal archlinux installation with main line kernel, systemd-boot, and create boot entries. It will **force** user to create an user and a group. If you want to setup user maunaly, please comment out last 3 line in `scripts/03_configure_system.sh` before starting any scirpt. It will detect all 5 officially supported kernel, and create proper boot entry. Please adjust the scripts to suit your needs. The btrfs layout isn't fully compatible with timeshift nor snapper. For timeshift, subvolid needs to be set to 5, and maunal set rootflags=subvolid=*your_root_subvol_id*; for snapper, manually setup is required. If you want to use snapper with rollback, you can mimic how openSUSE do it's subvol layout (not tested), or use [snapper-rollback](https://aur.archlinux.org/packages/snapper-rollback).

### To do list
- [x] Write down most command.(Basiclly what you do during maunal arch installation.)
- [x] Make them into script.
- [ ] Improve UID and GID detection.
- [ ] Install AUR helper.
