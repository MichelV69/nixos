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
    dates = "daily";
    options = "--delete-older-than 21d";
  };

  # Auto system update
  system.autoUpgrade = {
    enable = true;
  };
}
