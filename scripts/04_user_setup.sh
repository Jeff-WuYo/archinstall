#!/bin/sh
set -euo pipefail
unset -v username uid fullname groupname gid shell ans4 sudogroup
passwduid=$(cut -f 3 -d: /etc/passwd | sort -n | tail -2 | head -1)
[ "$passwduid" -lt 1000 ] && defaultuid=1000 || defaultuid=$(( $passwduid + 1 ))
groupgid=$(cut -f 3 -d: /etc/group | sort -n | tail -2 | head -1)
[ "$groupgid" -lt 1000 ] && defaultgid=1000 || defaultgid=$(( $groupgid + 1 ))

read -p "What's your username: " username
while [ -z "$username" ]; do
  read -p "Please enter your username: " username
done

read -ep "What's your uid? [$defaultuid]: " -i "$defaultuid" uid
while [[ ! "$uid" =~ ^[0-9]+$ || "$uid" -lt "$passwduid" ]]; do
  read -ep "Please enter uid with number at least or greater than [$defaultuid]: " -i "$defaultuid" uid
done

read -p "What's your fullname: " fullname
[ -z "$fullname" ] && unset -v setfullname || setfullname="-c $fullname"

read -ep "What's your groupname [$username]: " -i "$username" groupname
while [ -z "$groupname" ]; do
  read -ep "Please enter your groupname: " -i "$username" groupname
done

read -ep "What's your gid [$uid]: " -i "$uid" gid
while [[ ! "$gid" =~ ^[0-9]+$ || "$gid" -lt "$defaultgid" ]]; do
  read -ep "Please enter gid with number at least or greater than $defaultgid. [$uid]: " -i "$uid" gid
done

read -ep "What shell do you want to use? (zsh or [bash]): " -i "bash" shell
while [ ! "$shell" = "bash" || ! "$shell" = "zsh" ]; do
  read -ep "Please enter zsh or [bash]: " -i "bash" shell
done

read -p "Do you want to add $username to wheel group? " ans4
[ "$ans4" = yes ] && sudogroup="-G wheel" || unset -v sudogroup

groupadd -g "$gid" "$groupname" &&
useradd -m -u "$uid" -g "$gid" "$sudogroup" "$setfullname" -s "/usr/bin/$shell" "$username"
passwd "$username" ||;
while [ $? -ne 0 ]; do
  echo "Please enter password again"
  passwd "$username"
done
