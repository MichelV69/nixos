{
  config,
  pkgs,
  lib,
  ...
}: let
  realmCfg = config.StPeters7965;

  X11Forwarding = true;
  my4xIP = 113;
  myHostName = "nix${toString my4xIP}";
  ip_v4_block = "${realmCfg.ip_v4_block}";
  my4xMask = 24;
  myFullIP = "${ip_v4_block}.${toString my4xIP}";

  k3s_role = "proxy";
  k3s_ip_v4_block = "192.168.11";
  k3s_ip_v4_mask = 24;
  k3s_my4xIP = 3;
  k3s_myFullIP = "${k3s_ip_v4_block}.${toString k3s_my4xIP}";
in {
  # global relam options used outside this file
  StPeters7965.X11Forwarding = X11Forwarding;
  StPeters7965.myHostName = myHostName;
  StPeters7965.my4xIP = my4xIP;
  StPeters7965.ip_v4_mask = my4xMask;

  StPeters7965.k3sCfg.role = k3s_role;
  # StPeters7965.k3sCfg.ip_v4_block = k3s_ip_v4_block;
  # StPeters7965.k3sCfg.ip_v4_mask = k3s_ip_v4_mask;
  # StPeters7965.k3sCfg.my4xIP = k3s_my4xIP;

  StPeters7965.k3sCfg.ip_v4_block = ip_v4_block;
  StPeters7965.k3sCfg.ip_v4_mask = my4xMask;
  StPeters7965.k3sCfg.my4xIP = my4xIP;

  # other box specific options we can just set here
  virtualisation.docker = {
    enable = true;
    storageDriver = "btrfs";
    enableOnBoot = true;
    daemon.settings = {
      "userland-proxy" = true;
    };
  };
  services.nginx = {
    enable = true;

    # listen only on external to avoid proxy conflicts on localhost
    defaultListenAddresses = ["${myFullIP}"];

    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    streamConfig = ''
      upstream kubernetes_bootcamp {
         server ${ip_v4_block}.114:8080;
         server ${ip_v4_block}.115:8080;
      }
      server {
        listen ${myFullIP}:8080;
        proxy_pass kubernetes_bootcamp;
        }

      upstream rocket_tavern {
        server 127.0.0.1:9021;
        }
      server {
        listen ${myFullIP}:9021;
        proxy_pass rocket_tavern;
        }

      upstream k3s_managers {
         server ${ip_v4_block}.114:6443;
         }
      server {
        listen ${myFullIP}:6443;
        proxy_pass k3s_managers;
        }

      upstream k3s_agents {
         server ${ip_v4_block}.114:6443;
         server ${ip_v4_block}.115:6443;
         }
      server {
        listen ${myFullIP}:6443;
        proxy_pass k3s_agents;
        }

      upstream maria_db {
        server 127.0.0.1:3306;
        }
      server {
        listen ${myFullIP}:13306;
        proxy_pass maria_db;
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
    hostName = myHostName;
    dhcpcd.enable = false;
    interfaces.enp1s0.ipv4.addresses = [
      {
        address = myFullIP;
        prefixLength = my4xMask;
      }

      #(
      #  lib.mkIf
      #  ((k3s_role == "agent") || (k3s_role == "manager") || (k3s_role == "proxy"))
      #  {
      #    address = k3s_myFullIP;
      #    prefixLength = k3s_ip_v4_mask;
      #  }
      #)
    ];
  };
}
