#!/bin/bash
echo 'launch script execution occurred'
haveged -w 1024 -v 1
pacman-key --init
pkill haveged
pacman-key --populate archlinux

systemctl disable prgmr-on-init-launch
