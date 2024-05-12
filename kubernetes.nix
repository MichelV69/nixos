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
}: {
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
      "10.1.1.1" = ["kube_main_alpha"];
      "10.1.1.2" = ["kube_node_alpha"];
      "10.1.1.3" = ["kube_node_bravo"];
    };
  };
}
