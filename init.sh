#!/bin/bash

set BOXIP=115
echo " "
echo "--- WARNING ---"
echo "This script will wipe this machine and replace it with the config for NIX{$BOXIP}"
echo "If you do not want this, hit CTRL-C right now. Otherwise, press space to continue"
echo
read

cd "/run/media/USB_B650a/Nix stuff/"
sudo nix --experimental-features "nix-command flakes" \
 run github:nix-community/disko -- \
 --mode disko /tmp/nixInstall/disk-config.nix

mount | grep /mnt
sudo nixos-generate-config --no-filesystems --root /mnt

sudo cp -v *.nix /mnt/etc/nixos
sudo cp -v hosts/boxen.nix{$BOXIP}.nix /mnt/etc/nixos/perHost.nix

cd /mnt/etc/nixos
sudo nixos-install
reboot
