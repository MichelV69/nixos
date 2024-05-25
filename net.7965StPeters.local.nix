#
# 7965_stpeters_local.net.nix
#
# set up important network objects / config
#
{
  config,
  pkgs,
  ...
}: let
  domain = "7965stpeters.local";
  network_edge_ip = "192.168.0.1";
in {
  networking = {
    defaultGateway = "${network_edge_ip}";
    nameservers = ["${network_edge_ip}"];
    hosts = {
      "127.0.0.1" = ["localhost"];
      "192.168.0.1" = ["router.${domain}"];
      "192.168.0.111" = ["fileserver.${domain}"];
      "192.168.0.113" = ["nixmini01.${domain}" "gk_mini01.${domain}"];
      "192.168.0.114" = ["nixmini02.${domain}" "gk_mini02.${domain}"];
      "192.168.0.115" = ["nixmini03.${domain}" "gk_mini03.${domain}"];
    };
    domain = "${domain}";
  };
}
