#
#	wifi.nix
#
#	manage the wifi radios
#
{...}: {
  networking.wireless.enable = false; # Enables wireless support via wpa_supplicant.
}
