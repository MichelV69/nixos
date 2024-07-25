{
  pkgs,
  config,
  lib,
  ...
}: let
  realmCfg = config.StPeters7965;
  zone = "kube";
  kubeMasterAPIServerPort = 6443;

  kube_mgr_proxy = {
    alpha = {
      name = "mgr_proxy.${zone}.${realmCfg.domain}";
      ip_v4 = "${realmCfg.ip_v4_block}.113";
    };
  };
  kube_agent_proxy = {
    alpha = {
      name = "agent_proxy.${zone}.${realmCfg.domain}";
      ip_v4 = "${realmCfg.ip_v4_block}.113";
    };
  };
in {
  services.k3s = {
    enable = true;
    extraFlags = "--cluster-cidr ${realmCfg.kube.ip_v4_block}.0/24";
    role = "server";
  };
}
