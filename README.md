# NIXOS
## The Adventure Begins 

## Commands Used to Build

```(bash)

cd "/run/media/USB_B650a/Nix stuff/"
sudo nix --experimental-features "nix-command flakes" \
	run github:nix-community/disko -- \
	--mode disko /tmp/nixInstall/disk-config.nix

mount | grep /mnt	
sudo nixos-generate-config --no-filesystems --root /mnt

sudo cp -v *.nix /mnt/etc/nixos
sudo cp -v hosts/nix??.nix /mnt/etc/nixos/perHost.nix

cd /mnt/etc/nixos
sudo nixos-install
reboot

```

