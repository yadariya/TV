#!/bin/bash

set -xe

DATA="$(mktemp -d)"
MNT_DIR="$DATA/mnt"

dd if=/dev/zero of="$DATA"/disk.img bs=512 count=4194304

LOOP="$(losetup -f "$DATA"/disk.img --show)"


mkfs -t ext4 "$LOOP"


mkdir "$MNT_DIR"
mount "$LOOP" "$MNT_DIR"


CID=$(docker run -d alpine apk add sysbench)
docker logs -f "$CID"
docker export "$CID" | tar -C "$MNT_DIR" -xf-
docker rm "$CID"

unshare --mount --net --pid --fork bash ./run.sh "$MNT_DIR" || true

umount -R "$MNT_DIR"

losetup -d "$LOOP"


rm -rf -- "$DATA"
