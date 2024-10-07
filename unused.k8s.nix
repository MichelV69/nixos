#
# kubernetes.nix
#
# set up packages and services
# for kubernetes
#
{
  pkgs,
  config,
  lib,
  ...
}: let
  realmCfg = config.StPeters7965;
  zone = "kube";
  kubeMasterAPIServerPort = 6443;

  kube_managers = {
    alpha = {
      name = "alpha_mgr.${zone}.${realmCfg.domain}";
      ip_v4 = "${realmCfg.ip_v4_block}.113";
    };
    bravo = {
      name = "bravo_mgr.${zone}.${realmCfg.domain}";
      ip_v4 = "${realmCfg.ip_v4_block}.114";
    };
  };

  kube_workers = {
    alpha = {
      name = "alpha_wrk.${zone}.${realmCfg.domain}";
      ip_v4 = "${realmCfg.ip_v4_block}.120";
    };
    bravo = {
      name = "bravo_wrk.${zone}.${realmCfg.domain}";
      ip_v4 = "${realmCfg.ip_v4_block}.121";
    };
    charlie = {
      name = "charlie_wrk.${zone}.${realmCfg.domain}";
      ip_v4 = "${realmCfg.ip_v4_block}.122";
    };
  };

  my_fqdn = "${realmCfg.myHostName}.${realmCfg.domain}";
  my_fullIP = "${realmCfg.ip_v4_block}.${realmCfg.my4xIP}";

  masterAddress =
    if (realmCfg.kubeRole == "master")
    then "${my_fullIP}"
    else "${kube_managers.alpha.ip_v4_block}";

  apiServer =
    if (realmCfg.kubeRole == "master")
    then "https://${my_fqdn}:${toString kubeMasterAPIServerPort}"
    else "https://${kube_managers.alpha.name}:${toString kubeMasterAPIServerPort}";
in {
  networking = {
    hosts = {
      "${kube_managers.alpha.ip_v4}" = ["${kube_managers.alpha.name}"];
      "${kube_managers.bravo.ip_v4}" = ["${kube_managers.bravo.name}"];
      "${kube_workers.alpha.ip_v4}" = ["${kube_workers.alpha.name}"];
      "${kube_workers.bravo.ip_v4}" = ["${kube_workers.bravo.name}"];
      "${kube_workers.charlie.ip_v4}" = ["${kube_workers.charlie.name}"];
    };
  };

  # packages for administration tasks
  environment.systemPackages = with pkgs; [
    kompose
    kubectl
    kubernetes
  ];

  services.kubernetes = lib.mkMerge [
    (
      lib.mkIf (realmCfg.kubeRole == "master")
      {
        easyCerts = true;
        roles = ["master"];
        masterAddress = "${my_fullIP}";
        pki.cfsslAPIExtraSANs = ["${kube_managers.alpha.name}" "${kube_managers.bravo.name}"];
        apiserverAddress = apiServer;
        apiserver = {
          extraSANs = ["${kube_managers.alpha.name}" "${kube_managers.bravo.name}" "${my_fqdn}" "${my_fullIP}"];
          serviceAccountIssuer = "${my_fqdn}";
          securePort = kubeMasterAPIServerPort;
          advertiseAddress = "${my_fullIP}";
        };
      }
    )
    (
      lib.mkIf (realmCfg.kubeRole == "node")
      {
        roles = ["node"];
        masterAddress = kube_managers.alpha.ip_v4;
        easyCerts = true;
        pki.cfsslAPIExtraSANs = ["${kube_workers.alpha.name}" "${kube_workers.bravo.name}" "${kube_workers.charlie.name}"];

        # point kubelet and other services to kube-apiserver
        kubelet.kubeconfig.server = apiServer;
        apiserverAddress = apiServer;
      }
    )
    {
      # use coredns
      addons.dns.enable = true;
      # needed if you use swap
      kubelet.extraOpts = "--fail-swap-on=false";
    }
  ];
}
