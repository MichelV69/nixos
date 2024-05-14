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
  kubeMasterIP = "127.0.0.1";
  kubeMasterHostname = "localhost";
  #kubeMasterIP = "10.1.1.10";
  #kubeMasterHostname = "main_alpha.kube";
  kubeMasterAPIServerPort = 6443;
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
        address = "10.1.1.1";
        prefixLength = 24;
      }
      {
        address = "10.1.1.10";
        prefixLength = 24;
      }
    ];
    hosts = {
      "${kubeMasterIP}" = ["${kubeMasterHostname}" "main_alpha.kube"];
      "10.1.1.11" = ["node-alpha.kube"];
      "10.1.1.12" = ["node-bravo.kube"];
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
    masterAddress = kubeMasterHostname;
    apiserverAddress = "https://${kubeMasterHostname}:${toString kubeMasterAPIServerPort}";
    apiserver = {
      securePort = kubeMasterAPIServerPort;
      advertiseAddress = kubeMasterIP;
    };
    # use coredns
    #- addons.dns.enable = true;
    # needed if you use swap
    kubelet.extraOpts = "--fail-swap-on=false";
  };
}
