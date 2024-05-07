#!/usr/bin/env bash
#original command
echo "↓↓↓↓↓original command↓↓↓↓↓"
time blkid | awk '/'"$(awk '/256/ {print $1}' /etc/fstab | tr -d UUID=)"'/ {print$NF}' | tr -d \"
echo "↓↓↓↓↓new comand↓↓↓↓↓"
time cut -d' ' -f 3 <(grep $(cut -c 6-41 <(grep "256" /etc/fstab)) <(blkid -s UUID -s PARTUUID)) | tr -d \"
echo "↓↓↓↓↓new new command, which only gets UUID↓↓↓↓↓"
time cut -f1 <(grep "256" /etc/fstab)
echo "↓↓↓↓↓new new command, but with awk↓↓↓↓↓"
time awk '/256/ {print $1}' /etc/fstab
