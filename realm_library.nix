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
    domain = lib.mkOption {
      type = lib.types.string;
      default = "7965stpeters.local";
      description = ''
        Which LAN FQDN we expect to be on.
      '';
    };

    kubeRole = lib.mkOption {
      type = lib.types.string;
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
