# systems_library.nix
#
# Define a unique per-box variables
#
{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  anExampleDefault = true;
in {
  options = {};

  options.StPeters7965 = {
    anExample = mkOption {
      type = "string";
      default = "an example of an example";
      description = "This is a test of making options";
    };

    booleanTest = mkOption {
      type = "bool";
      default = anExampleDefault;
      description = "a test case to do something elsewhere if true";
    };
  };
}
