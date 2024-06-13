#
# kubernetes.nix
#
# set up packages and services
# for kubernetes
#
{
  pkgs,
  config,
  ...
}: let
  realmCfg = config.StPeters7965;
  zone = "kube";
  ip_v4_block = "192.168.0";
  kubeBuildIP = "127.0.0.1";
  kubeBuildHostname = "localhost";
  kubeMasterAPIServerPort = 6443;

  kube_managers = {
    alpha = {
      name = "alpha_mgr.${zone}.${realmCfg.domain}";
      ip_v4 = "${ip_v4_block}.113";
    };
    bravo = {
      name = "bravo_mgr.${zone}.${realmCfg.domain}";
      ip_v4 = "${ip_v4_block}.114";
    };
  };

  kube_workers = {
    alpha = {
      name = "alpha_wrk.${zone}.${realmCfg.domain}";
      ip_v4 = "${ip_v4_block}.120";
    };
    bravo = {
      name = "bravo_wrk.${zone}.${realmCfg.domain}";
      ip_v4 = "${ip_v4_block}.121";
    };
    charlie = {
      name = "charlie_wrk.${zone}.${realmCfg.domain}";
      ip_v4 = "${ip_v4_block}.122";
    };
  };

  realManagerIP = kube_managers.alpha.ip_v4;
  #  if ("${realmCfg.kubeRole}" != "node")
  #  then kube_managers.alpha.ip_v4
  #  else kubeBuildIP;

  realManagerName = kube_managers.alpha.name;
  #  if ("${realmCfg.kubeRole}" != "node")
  #  then kube_managers.alpha.name
  #  else kubeBuildHostname;
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
  services.kubernetes = {
    easyCerts = true;
    roles = ["${realmCfg.kubeRole}"];
    masterAddress = realManagerIP;
    pki.cfsslAPIExtraSANs = ["${kube_managers.alpha.name}" "${kube_managers.bravo.name}"];
    apiserverAddress = "https://${realManagerName}:${toString kubeMasterAPIServerPort}";
    apiserver = {
      extraSANs = ["${kube_managers.alpha.name}" "${kube_managers.bravo.name}"];
      serviceAccountIssuer = realManagerName;
      securePort = kubeMasterAPIServerPort;
      advertiseAddress = realManagerIP;
    };
    # use coredns
    addons.dns.enable = true;
    # needed if you use swap
    kubelet.extraOpts = "--fail-swap-on=false";
  };
}
