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
      type = lib.types.str;
      default = "001";
      description = ''
        What is the last 4 digits of our unique v4 IP?
      '';
    };

    domain = lib.mkOption {
      type = lib.types.str;
      default = "7965stpeters.local";
      description = ''
        Which LAN FQDN we expect to be on?
      '';
    };

    ip_v4_block = lib.mkOption {
      type = lib.types.str;
      default = "192.168.0";
      description = ''
        Which LAN which /24 unroutable we expect to be on?
      '';
    };

    kubeRole = lib.mkOption {
      type = lib.types.str;
      default = "node";
      description = ''
        Used to set up what job this box does under kubernetes.
      '';
    };

    X11Forwarding = lib.mkOption {
      type = lib.types.bool;
      default = trueByDefault;
      description = ''
        enables X11Forwarding in SSHD.
      '';
    };
  };
}
