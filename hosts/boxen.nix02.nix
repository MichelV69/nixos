{
  config,
  pkgs,
  lib,
  ...
}: let
  realmCfg = config.StPeters7965;

  X11Forwarding = true;
  myHostName = "nix02";
  my4xIP = 114;
  my4xMask = 24;
  myFullIP = "${realmCfg.ip_v4_block}.${toString my4xIP}";

  kube_role = "manager";
  kube_ip_v4_block = "192.168.11";
  kube_ip_v4_mask = 24;
  kube_my4xIP = 2;
  kube_myFullIP = "${kube_ip_v4_block}.${toString kube_my4xIP}";
in {
  # global relam options used outside this file
  StPeters7965.X11Forwarding = X11Forwarding;
  StPeters7965.myHostName = myHostName;
  StPeters7965.my4xIP = my4xIP;
  StPeters7965.ip_v4_mask = my4xMask;

  StPeters7965.kubeCfg.role = kube_role;
  StPeters7965.kubeCfg.ip_v4_block = kube_ip_v4_block;
  StPeters7965.kubeCfg.ip_v4_mask = kube_ip_v4_mask;
  StPeters7965.kubeCfg.my4xIP = kube_my4xIP;

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
    hostName = myHostName;
    dhcpcd.enable = false;
    interfaces.enp1s0.ipv4.addresses = [
      {
        address = myFullIP;
        prefixLength = my4xMask;
      }

      (
        lib.mkIf
        ((kube_role == "agent") || (kube_role == "manager") || (kube_role == "proxy"))
        {
          address = kube_myFullIP;
          prefixLength = kube_ip_v4_mask;
        }
      )
    ];
  };

  networking.hosts = lib.mkMerge [
    (
      if ((kube_role == "agent") || (kube_role == "manager") || (kube_role == "proxy"))
      then {
        "${kube_myFullIP}" = ["${kube_role}${toString kube_my4xIP}.${realmCfg.kubeCfg.dns_zone}.${realmCfg.domain}"];
      }
      else {"" = [""];}
    )
  ];
}
