#!/usr/bin/env bash
set -euo pipefail
unset -v username uid fullname groupname gid shell ans4
passwduid=$(cut -f 3 -d: /etc/passwd | sort -n | tail -2 | head -1)
[ "$passwduid" -lt 1000 ] && defaultuid=1000 || defaultuid=$(( $passwduid + 1 ))
groupgid=$(cut -f 3 -d: /etc/group | sort -n | tail -2 | head -1)
[ "$groupgid" -lt 1000 ] && defaultgid=1000 || defaultgid=$(( $groupgid + 1 ))
function passwd_check {
  echo "Please enter your password again"
  passwd "$username" || passwd_check
}

read -p "What's your username: " username
while [ -z "$username" ]; do
  read -p "Please enter your username: " username
done

read -ep "What's your uid? [$defaultuid]: " -i "$defaultuid" uid
while [[ ! "$uid" =~ ^[0-9]+$ || "$uid" -lt "$passwduid" ]]; do
  read -ep "Please enter uid with number at least or greater than [$defaultuid]: " -i "$defaultuid" uid
done

read -ep "What's your groupname [$username]: " -i "$username" groupname
while [ -z "$groupname" ]; do
  read -ep "Please enter your groupname: " -i "$username" groupname
done

read -ep "What's your gid [$uid]: " -i "$uid" gid
while [[ ! "$gid" =~ ^[0-9]+$ || "$gid" -lt "$defaultgid" ]]; do
  read -ep "Please enter gid with number at least or greater than $defaultgid. [$uid]: " -i "$uid" gid
done

read -ep "What shell do you want to use? (bash or [zsh]): " -i "zsh" shell
while [[ ! "$shell" = "bash" && ! "$shell" = "zsh" ]]; do
  read -ep "Please enter bash or [zsh]: " -i "zsh" shell
done

read -p "Do you want to add $username to wheel group? " ans4

groupadd -g "$gid" "$groupname" &&
if [ "$ans4" = yes ]; then
  useradd -m -u "$uid" -g "$gid" -G wheel -s "/usr/bin/$shell" "$username"
else
  useradd -m -u "$uid" -g "$gid" -s "/usr/bin/$shell" "$username"
fi

passwd "$username" || passwd_check
