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
  # When using easyCerts=true the IP Address must resolve to the master on creation.
  # So use simply 127.0.0.1 in that case. Otherwise you will have errors like this https://github.com/NixOS/nixpkgs/issues/59364
  domain = "7965stpeters.local";
  zone = "kube";
  ip_v4_block = "10.1.1";

  kubeBuildIP = "127.0.0.1";
  kubeBuildHostname = "localhost";
  kubeMasterAPIServerPort = 6443;

  kube_managers = {
    alpha = {
      name = "alpha_mgr.${zone}.${domain}";
      ip_v4 = "${ip_v4_block}.10";
    };
    bravo = {
      name = "bravo_mgr.${zone}.${domain}";
      ip_v4 = "${ip_v4_block}.11";
    };
  };

  kube_workers = {
    alpha = {
      name = "alpha_wrk.${zone}.${domain}";
      ip_v4 = "${ip_v4_block}.20";
    };
    bravo = {
      name = "bravo_wrk.${zone}.${domain}";
      ip_v4 = "${ip_v4_block}.21";
    };
  };
in {
  networking = {
    vlans = {
      vlan100 = {
        id = 100;
        interface = "enp1s0";
      };
    };
    interfaces.vlan100.ipv4.addresses = [
      {
        address = "${ip_v4_block}.1";
        prefixLength = 24;
      }
      {
        address = "${kube_managers.alpha.ip_v4}";
        prefixLength = 24;
      }
    ];
    hosts = {
      "${kube_managers.alpha.ip_v4}" = ["${kube_managers.alpha.name}"];
      "${kube_managers.bravo.ip_v4}" = ["${kube_managers.bravo.name}"];
      "${kube_workers.alpha.ip_v4}" = ["${kube_managers.alpha.name}"];
      "${kube_workers.bravo.ip_v4}" = ["${kube_managers.bravo.name}"];
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
    roles = ["master"];
    masterAddress = kubeBuildHostname;
    apiserverAddress = "https://${kubeBuildHostname}:${toString kubeMasterAPIServerPort}";
    apiserver = {
      securePort = kubeMasterAPIServerPort;
      advertiseAddress = kube_managers.alpha.ip_v4;
    };
    # use coredns
    addons.dns.enable = true;
    # needed if you use swap
    kubelet.extraOpts = "--fail-swap-on=false";
  };
}
