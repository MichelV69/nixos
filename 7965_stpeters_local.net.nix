#
# 7965_stpeters_local.net.nix
#
# set up important network objects / config
#
{
  config,
  pkgs,
  ...
}: {
  networking = {
    defaultGateway = "192.168.0.1";
    nameservers = ["192.168.0.1"];
    hosts = {
      "127.0.0.2" = ["other-localhost"];
      "192.0.1.111" = ["fileserver"];
      "192.0.1.113" = ["nixmini01"];
      "192.0.1.114" = ["nixmini02"];
      "192.0.1.115" = ["nixmini03"];
    };
    domain = "7965_stpeters.local";
  };
}
