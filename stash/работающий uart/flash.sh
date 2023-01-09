#!/bin/sh

dirname=${PWD##*/}          # to assign to a variable

result="${dirname%"${dirname##*[!/]}"}" # extglob-free multi-trailing-/ trimm
PROJ="${result##*/}" # remove everything before the last /
echo "$PROJ"
dd if=/dev/zero bs=2M count=1 | tr '\0' '\377' > "$PROJ.img"
dd if="$PROJ.bin" conv=notrunc of="$PROJ.img"
echo out > /sys/class/gpio/gpio24/direction
sleep 2
flashrom -p linux_spi:dev=/dev/spidev0.0,spispeed=20000 -w "$PROJ.img"
sleep 2
echo in > /sys/class/gpio/gpio24/direction
