#!/bin/sh
#Bus 003 Device 002: ID 0411:0260 BUFFALO INC. (formerly MelCo., Inc.)
#sudo udevadm info --query=path --name=/dev/video0
UDEV=/devices/pci0000:00/0000:00:14.0/usb3/3-6/3-6:1.0/video4linux/video0
sudo echo -n "3-6" > /sys/bus/usb/drivers/usb/unbind
sudo echo -n "3-6" > /sys/bus/usb/drivers/usb/bind

