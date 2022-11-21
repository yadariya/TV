#!/bin/bash

set -xe

MNT_DIR="$1"

mkdir "$MNT_DIR/oldroot"
pivot_root "$MNT_DIR" "$MNT_DIR/oldroot"

mount -t proc proc /proc

umount -l /oldroot
rmdir /oldroot

cd /
exec chroot / sh
