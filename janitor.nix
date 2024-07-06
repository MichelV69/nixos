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
    dates = "Sunday, 01:44";
    options = "--delete-older-than 11d";
  };

  # Auto system update
  system.autoUpgrade = {
    enable = true;
    dates = "Sunday, 02:00";
    randomizedDelaySec = "11min";
  };

  # Make sure that we're not repeating ourselves and repeating ourselves
  nix.optimise = {
    automatic = true;
    dates = ["Sunday, 02:00"];
  };
}
