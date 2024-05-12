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
      "127.0.0.1" = ["localhost"];
      "192.168.0.1" = ["router"];
      "192.168.0.111" = ["fileserver"];
      "192.168.0.113" = ["nixmini01"];
      "192.168.0.114" = ["nixmini02"];
      "192.168.0.115" = ["nixmini03"];
    };
    domain = "7965_stpeters.local";
  };
}
