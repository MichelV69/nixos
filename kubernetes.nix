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
  #kubeMasterIP = "10.1.1.10";
  kubeMasterIP = "127.0.0.1";
  kubeMasterHostname = "kube_main_alpha";
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
    ];
    hosts = {
      "${kubeMasterIP}" = ["${kubeMasterHostname}"];
      "10.1.1.11" = ["kube_node_alpha"];
      "10.1.1.12" = ["kube_node_bravo"];
    };
  };

  # packages for administration tasks
  #-  environment.systemPackages = with pkgs; [
  #-    kompose
  #-    kubectl
  #-    kubernetes
  #-  ];
  #-  services.kubernetes = {
  #-    easyCerts = true;
  #-    roles = ["master"];
  #-    masterAddress = kubeMasterHostname;
  #-    apiserverAddress = "https://${kubeMasterHostname}:${toString kubeMasterAPIServerPort}";
  #-  apiserver = {
  #-      securePort = kubeMasterAPIServerPort;
  #-      advertiseAddress = kubeMasterIP;
  #-  };

  # use coredns
  #-    addons.dns.enable = true;

  # needed if you use swap
  #-    kubelet.extraOpts = "--fail-swap-on=false";
  #-  };
}
