{
  config,
  pkgs,
  lib,
  ...
}: let
  realmCfg = config.StPeters7965;

  X11Forwarding = true;
  my4xIP = 113;
  myHostName = "nix${my4xIP}";
  my4xMask = 24;
  myFullIP = "${realmCfg.ip_v4_block}.${toString my4xIP}";

  kube_role = "proxy";
  kube_ip_v4_block = "192.168.11";
  kube_ip_v4_mask = 8;
  kube_my4xIP = 1;
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
      upstream rocket_tavern {
        server 127.0.0.1:9021;
        }
      server {
        listen ${myFullIP}:9021;
        proxy_pass rocket_tavern;
        }

      upstream k3s_managers {
         server ${kube_ip_v4_block}.2:6443;
         server ${kube_ip_v4_block}.5:6443;
         }
      server {
        listen ${myFullIP}:6443;
        proxy_pass k3s_managers;
        }

      upstream k3s_agents {
         server ${kube_ip_v4_block}.3:6443;
         server ${kube_ip_v4_block}.4:6443;
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
}
