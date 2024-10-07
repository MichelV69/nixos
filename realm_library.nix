# systems_library.nix
#
# Define a unique per-box variables
#
{
  pkgs,
  config,
  lib,
  ...
}: let
  trueByDefault = true;
in {
  options = {};

  options.StPeters7965 = with lib; {
    myHostName = lib.mkOption {
      type = lib.types.str;
      default = "new.server";
      description = ''
        What is our unique IP hostname?
      '';
    };

    my4xIP = lib.mkOption {
      type = lib.types.int;
      default = 1;
      description = ''
        What is the last 3 digits of our unique v4 IP?
      '';
    };

    ip_v4_block = lib.mkOption {
      type = lib.types.str;
      default = "192.168.0";
      description = ''
        Which LAN which unroutable we expect to be on?
      '';
    };

    ip_v4_mask = lib.mkOption {
      type = lib.types.int;
      default = 24;
      description = ''
        Which Subnet Mask should we use with our ip_v4_block?
      '';
    };

    domain = lib.mkOption {
      type = lib.types.str;
      default = "7965stpeters.local";
      description = ''
        Which LAN FQDN we expect to be on?
      '';
    };

    X11Forwarding = lib.mkOption {
      type = lib.types.bool;
      default = trueByDefault;
      description = ''
        enables X11Forwarding in SSHD.
      '';
    };

    k3sCfg = lib.mkOption {
      type = with types;
        submodule {
          options = {
            role = mkOption {
              type = lib.types.enum ["none" "proxy" "primary" "manager" "agent"];
              default = "none";
              description = ''
                Used to set up what job this box does under k3srnetes.
                [none | proxy | manager | agent ]
              '';
            };
            dns_zone = lib.mkOption {
              type = lib.types.str;
              default = "k3s";
              description = ''
                What zone is this sitting on for DNS?
              '';
            };
            ip_v4_block = lib.mkOption {
              type = lib.types.str;
              default = "192.168.11";
              description = ''
                Which LAN which /24 unroutable we expect to be on?
              '';
            };

            my4xIP = lib.mkOption {
              type = lib.types.int;
              default = 1;
              description = ''
                What is the last 3 digits of our unique v4 IP?
              '';
            };

            ip_v4_mask = lib.mkOption {
              type = lib.types.int;
              default = 29;
              description = ''
                Which Subnet Mask should we use with our ip_v4_block?
                (Default is 8 IPs, 192.168.X.0 - 192.168.X.7)
              '';
            };
          };
        }; #submodule
    }; # k3sCfg
  };
}
