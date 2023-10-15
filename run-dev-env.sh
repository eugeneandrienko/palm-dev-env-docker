#!/usr/bin/env bash

xhost +local:docker

# Create SD card image if not exists:
if [ ! -f sdcard.bin ]; then
    echo "SD card image not found. Creating new image ..."
    fallocate -l 50M sdcard.bin
    sudo mkfs.fat ./sdcard.bin
fi

# Mount SD card image if not mounted:
mount | grep -q sdcard.bin
if [ "$?" -ne 0 ]; then
    sudo mount -o loop ./sdcard.bin ./sdcard/
fi

# Start container if not started:
docker ps | grep -q palm-dev-env
if [ "$?" -ne 0 ]; then
    docker compose up --detach
fi

# Go to container
docker exec -it palm-dev-env /bin/bash

