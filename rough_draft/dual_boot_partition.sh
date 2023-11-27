#!/bin/sh
# It's for 1TB drive.
sgdisk -n 1:2048:+260M -n 2:0:+1G -n 3:0:+16M -n 4:0:+40G -t 1:ef00 -t 2:ea00 -t 3:0c01 -t 4:0700 -c 1:ESP -c 2:BOOT -c 3:"Microsoft reserved partition" -c 4:Windows /dev/$dis
echo "Please proceed with Windows installation, make any required partitions, and then install Linux."
