{
  config,
  pkgs,
  ...
}: let
  realmCfg = config.StPeters7965;

  X11Forwarding = true;
  kubeRole = "node";
  myHostName = "nix04";
  my4xIP = "116";
  myFullIP = "${realmCfg.ip_v4_block}.${my4xIP}";
in {
  # global relam options used outside this file
  StPeters7965.X11Forwarding = X11Forwarding;
  StPeters7965.kubeRole = kubeRole;
  StPeters7965.myHostName = myHostName;
  StPeters7965.my4xIP = my4xIP;
  StPeters7965.ip_v4_mask = "24";

  # other box specific options we can just set here
  # Set your time zone.
  time.timeZone = "America/Halifax";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_CA.UTF-8";

  # Configure keymap in X11
  services.xserver = {
    xkb.layout = "us";
    xkb.variant = "";
  };

  networking = {
    hostName = myHostName; # Define your hostname.
    dhcpcd.enable = false;
    interfaces.enp1s0.ipv4.addresses = [
      {
        address = myFullIP;
        prefixLength = 24;
      }
    ];
  };
}
