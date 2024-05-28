#
# ssh.nix
#
# Configure ssh server
#
{
  pkgs,
  config,
  ...
}: let
  realmCfg = config.StPeters7965;
in {
  # This setups a SSH server. Very important if you're setting up a headless system.
  # Feel free to remove if you don't need it.
  services.openssh = {
    enable = true;
    # Forbid root login through SSH.
    settings.PermitRootLogin = "no";
    # Use keys only. Remove if you want to SSH using password (not recommended)
    settings.PasswordAuthentication = false;
  };

  services.openssh.settings.X11Forwarding =
    if (realmCfg.booleanTest)
    then true
    else false;
}
