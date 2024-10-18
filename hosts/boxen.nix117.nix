{
  config,
  pkgs,
  lib,
  ...
}: let
  realmCfg = config.StPeters7965;

  X11Forwarding = true;
  my4xIP = 117;
  myHostName = "nix${toString my4xIP}";
  my4xMask = 24;
  myFullIP = "${realmCfg.ip_v4_block}.${toString my4xIP}";

  k3s_role = "agent";
  k3s_ip_v4_block = "192.168.11";
  k3s_ip_v4_mask = 24;
  k3s_my4xIP = 6;
  k3s_myFullIP = "${k3s_ip_v4_block}.${toString k3s_my4xIP}";
in {
  # global relam options used outside this file
  StPeters7965.X11Forwarding = X11Forwarding;
  StPeters7965.myHostName = myHostName;
  StPeters7965.my4xIP = my4xIP;
  StPeters7965.ip_v4_mask = my4xMask;

  StPeters7965.k3sCfg.role = k3s_role;
  StPeters7965.k3sCfg.ip_v4_block = k3s_ip_v4_block;
  StPeters7965.k3sCfg.ip_v4_mask = k3s_ip_v4_mask;
  StPeters7965.k3sCfg.my4xIP = k3s_my4xIP;

  boot.kernel.sysctl."vm.nr_hugepages" = "1440";

  # --- unlikely to need to change below ---
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
    hostName = myHostName;
    dhcpcd.enable = false;
    interfaces.enp1s0.ipv4.addresses = [
      {
        address = myFullIP;
        prefixLength = my4xMask;
      }

      #(
      #  lib.mkIf
      #  ((k3s_role == "agent") || (k3s_role == "primary") || (k3s_role == "manager") || (k3s_role == "proxy"))
      #  {
      #    address = k3s_myFullIP;
      #    prefixLength = k3s_ip_v4_mask;
      #  }
      #)
    ];
  };
}
