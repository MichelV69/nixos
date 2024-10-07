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
  realmCfg = config.StPeters7965;
  domain = "${realmCfg.domain}";
  ip_v4_block = "${realmCfg.ip_v4_block}";
  network_edge_ip = "${ip_v4_block}.1";
in {
  networking = {
    defaultGateway = "${network_edge_ip}";
    nameservers = ["${network_edge_ip}"];
    hosts = {
      "127.0.0.1" = ["localhost"];
      "${network_edge_ip}" = ["router.${domain}" "edge_local.eastlink.ca"];
      "${ip_v4_block}.111" = ["fileserver.${domain}" "files.${domain}"];
      "${ip_v4_block}.113" = ["nix113.${domain}" "gk_mini01.${domain}" "lb01.${domain}"];
      "${ip_v4_block}.114" = ["nix114.${domain}" "gk_mini02.${domain}" "k8mgr01.${domain}"];
      "${ip_v4_block}.115" = ["nix115.${domain}" "gk_mini03.${domain}" "k8node01.${domain}"];
      "${ip_v4_block}.116" = ["nix116.${domain}" "gk_mini04.${domain}" "k8node02.${domain}"];
      "${ip_v4_block}.117" = ["nix117.${domain}" "gk_mini05.${domain}" "k8node03.${domain}"];
    };
    domain = "${domain}";
  };
}
