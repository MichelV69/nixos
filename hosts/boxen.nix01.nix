{
  config,
  pkgs,
  ...
}: {
  # global relam options used outside this file
  StPeters7965.X11Forwarding = true;
  StPeters7965.kubeRole = "master";

  # other box specific options we can just set here
  # Set your time zone.
  time.timeZone = "America/Halifax";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_CA.UTF-8";

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  networking = {
    hostName = "nix01"; # Define your hostname.
    dhcpcd.enable = false;
    interfaces.enp1s0.ipv4.addresses = [
      {
        address = "192.168.0.113";
        prefixLength = 24;
      }
    ];
  };
}
