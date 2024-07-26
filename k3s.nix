{
  pkgs,
  config,
  lib,
  ...
}: let
  realmCfg = config.StPeters7965;
  kubeMgrAPIServerPort = 6443;

  kube_role = realmCfg.kubeCfg.role;
  kube_my4xIP = realmCfg.kubeCfg.my4xIP;
  kube_ip_v4_block = realmCfg.kubeCfg.ip_v4_block;
  kube_ip_v4_mask = realmCfg.kubeCfg.ip_v4_mask;
  kube_myFullIP = "${kube_ip_v4_block}.${toString kube_my4xIP}";

  kube_proxies = "${kube_ip_v4_block}.113";

  kube_mgr_proxy = {
    alpha = {
      name = "mgr_proxy.${realmCfg.kubeCfg.dns_zone}.${realmCfg.domain}";
      ip_v4 = kube_proxies;
    };
  };
  kube_agent_proxy = {
    alpha = {
      name = "agent_proxy.${realmCfg.kubeCfg.dns_zone}.${realmCfg.domain}";
      ip_v4 = kube_proxies;
    };
  };
in {
  services.k3s = lib.mkMerge [
    (
      if ((kube_role == "agent") || (kube_role == "manager"))
      then {
        enable = true;
        extraFlags = "--cluster-cidr ${kube_ip_v4_block}.0/${toString kube_ip_v4_mask}";
        role =
          if (kube_role == "manager")
          then "server"
          else "${kube_role}";
      }
      else {
        enable = false;
      }
    )
  ];

  networking.hosts = lib.mkMerge [
    (
      if ((kube_role == "agent") || (kube_role == "manager") || (kube_role == "proxy"))
      then {
        "${kube_myFullIP}" = ["${kube_role}${toString kube_my4xIP}.${realmCfg.kubeCfg.dns_zone}.${realmCfg.domain}"];
      }
      else {"" = [""];}
    )
  ];
}
