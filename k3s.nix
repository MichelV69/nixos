{
  pkgs,
  config,
  lib,
  ...
}: let
  realmCfg = config.StPeters7965;
  kubeMgrAPIServerPort = 6443;

  kube_mgr_proxy = {
    alpha = {
      name = "mgr_proxy.${realmCfg.kubeCfg.dns_zone}.${realmCfg.domain}";
      ip_v4 = "${realmCfg.kubeCfg.ip_v4_block}.113";
    };
  };
  kube_agent_proxy = {
    alpha = {
      name = "agent_proxy.${realmCfg.kubeCfg.dns_zone}.${realmCfg.domain}";
      ip_v4 = "${realmCfg.kubeCfg.ip_v4_block}.113";
    };
  };
in {
  services.k3s = lib.mkMerge [
    (
      if ((realmCfg.kubeCfg.role == "agent") || (realmCfg.kubeCfg.role == "manager"))
      then {
        enable = true;
        extraFlags = "--cluster-cidr ${realmCfg.kubeCfg.ip_v4_block}.0/${toString realmCfg.kubeCfg.ip_v4_mask}";
        role =
          if (realmCfg.kubeCfg.role == "manager")
          then "server"
          else "${realmCfg.kubeCfg.role}";
      }
      else {
        enable = false;
      }
    )
  ];
}
