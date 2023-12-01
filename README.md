## archinstall
Archlinux install script \
This script will do a minimal archlinux installation whith main line kernel, systemd-boot, and create boot entries. It **won't** create any user, **nor** set any password. Make sure setup password manually. It will detect all 5 officially supported kernel, and create proper boot entry. Please adjust the scripts to suit your needs. The btrfs layout isn't fully compatible with timeshift nor snapper. For timeshift, subvolid needs to be set to 5, and maunal set rootflags=subvolid=*your_root_subvol_id*; for snapper, manually setup is required. If you want to use snapper with rollback, you can mimic how openSUSE do it's subvol layout (not tested), or use [snapper-rollback](https://aur.archlinux.org/packages/snapper-rollback).

### To do list
- [x] Write down most command.(Basiclly what you do during maunal arch installation.)
- [x] Make them into script.
