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
  anExampleDefault = true;
in {
  options = {};

  options.StPeters7965 = with lib; {
    anExample = lib.mkOption {
      type = lib.types.string;
      default = "an example of an example";
      description = ''
        This is a test of making options.
        This doubled single-quote style is essentially HEREDOC for NixOS.
        See what I mean?
      '';
    };

    booleanTest = lib.mkOption {
      type = lib.types.bool;
      default = anExampleDefault;
      description = ''
        a test case to do something elsewhere if true
      '';
    };
  };
}
