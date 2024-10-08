{
  pkgs,
  config,
  lib,
  ...
}: let
  realmCfg = config.StPeters7965;

  k3s_token = "Custody-Fiber3-Spearfish#Antarctic7-Parchment-Patchy!";

  k3s_role = realmCfg.k3sCfg.role;

  ## k3s_my4xIP = realmCfg.k3sCfg.my4xIP;
  ## k3s_ip_v4_block = realmCfg.k3sCfg.ip_v4_block;
  ## k3s_ip_v4_mask = realmCfg.k3sCfg.ip_v4_mask;
  ## k3s_myFullIP = "${k3s_ip_v4_block}.${toString k3s_my4xIP}";
  ##
  ## k3s_proxy_ip = "${k3s_ip_v4_block}.3";
  ## k3s_proxy_port = 6443;
  ## k3s_primary_ip = "${k3s_ip_v4_block}.4";
  ## k3s_primary_port = 6443;

  k3s_my4xIP = realmCfg.my4xIP;
  k3s_ip_v4_block = realmCfg.ip_v4_block;
  k3s_ip_v4_mask = realmCfg.ip_v4_mask;
  k3s_myFullIP = "${k3s_ip_v4_block}.${toString k3s_my4xIP}";

  k3s_proxy_ip = "${k3s_ip_v4_block}.113";
  k3s_proxy_port = 6443;
  k3s_primary_ip = "${k3s_ip_v4_block}.114";
  k3s_primary_port = 6443;
in {
  services.k3s = lib.mkMerge [
    (
      if ((k3s_role == "agent") || (k3s_role == "primary") || (k3s_role == "manager"))
      then {
        enable = true;
        token = "'${k3s_token}'";
      }
      else {
        enable = false;
      }
    )

    (
      if (k3s_role == "primary")
      then {
        # --- primary "type 1" server ---
        # - https://github.com/NixOS/nixpkgs/blob/master/pkgs/applications/networking/cluster/k3s/docs/USAGE.md#multi-node
        clusterInit = true;
      }
      else {
        # --- subordinate "type 2" server ---
        clusterInit = false;
      }
    )

    (
      if ((k3s_role == "primary") || (k3s_role == "manager"))
      then {
        role = "server";
        extraFlags = toString [
          "--debug --cluster-cidr=10.42.0.0/16 --service-cidr=10.43.0.0/16 --flannel-iface enp1s0"
        ];
      }
      else {
        role = "agent";
        extraFlags = toString [
          "--debug"
        ];
      }
    )

    (
      if ((k3s_role == "agent") || (k3s_role == "manager"))
      then {
        clusterInit = false;
        serverAddr = "https://${k3s_primary_ip}:${toString k3s_primary_port}";
      }
      else {
        # --
      }
    )
  ];

  networking.hosts = lib.mkMerge [
    (
      if ((k3s_role == "agent") || (k3s_role == "primary") || (k3s_role == "manager") || (k3s_role == "proxy"))
      then {
        "${k3s_myFullIP}" = ["${k3s_role}${toString k3s_my4xIP}.${realmCfg.k3sCfg.dns_zone}.${realmCfg.domain}"];
      }
      else {"" = [""];}
    )
  ];
}
