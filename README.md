# NIXOS
## The Adventure Begins 

## Commands Used to Build

```(bash)
cp "/run/media/USB_B650a/Nix stuff/*.nix" /tmp
sudo nix --experimental-features "nix-command flakes" \
	run github:nix-community/disko -- \
	--mode disko /tmp/disk-config.nix

mount | grep /mnt	
sudo nixos-generate-config --no-filesystems --root /mnt

sudo mv /tmp/*.nix /etc/nixos

 
```

