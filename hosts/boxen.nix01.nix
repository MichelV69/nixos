{
  config,
  pkgs,
  ...
}: let
  realmCfg = config.StPeters7965;

  X11Forwarding = true;
  kubeRole = "none";
  myHostName = "nix01";
  my4xIP = "113";
  myFullIP = "${realmCfg.ip_v4_block}.${my4xIP}";
in {
  # global relam options used outside this file
  StPeters7965.X11Forwarding = X11Forwarding;
  StPeters7965.kubeRole = kubeRole;
  StPeters7965.myHostName = myHostName;
  StPeters7965.my4xIP = my4xIP;

  # other box specific options we can just set here
  services.nginx = {
    enable = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    streamConfig = ''
      upstream k8s_servers {
         server 192.168.0.14:6443;
         server 192.168.0.24:6443;
         }

      upstream rust_rocket1 {
        server 127.0.0.1:8000;
      }
      server {
        listen 8080;
        proxy_pass rust_rocket1;
      }

      server {
          listen 6443;
          proxy_pass k8s_servers;
         }
    '';
  };

  services.mysql = {
    enable = true;
    package = pkgs.mariadb;
  };

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
