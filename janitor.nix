#
# janitpr.nix
#
# configure garbage collection behavior
#
{
  pkgs,
  config,
  ...
}: {
  # get ride of DRVs that haven't been looked at in a month
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 28d";
  };

  # Auto system update
  system.autoUpgrade = {
    enable = true;
  };
}
