#
# firewall.nix
#
# configure the system firewall
#
{
  pkgs,
  config,
  ...
}: let
  ssh = 22;
  mariaDB = 3306;
  #
  k3s_api = 6443;
  k3s_etcd_clients = 2379;
  k3s_etcd_peers = 2380;
  k3s_flannel = 8472;
  #
  dnsmasq_dns = 53;
  dnsmasq_dhcp = 76;
  #
  kubernetes_bootcamp = 8080;
  rust_rocket_tavern = 9021;
  #
in {
  networking = {
    firewall.enable = true;
    firewall.allowedTCPPorts = [
      ssh
      mariaDB
      k3s_api
      k3s_etcd_clients
      k3s_etcd_peers
      dnsmasq_dns
      dnsmasq_dhcp
      kubernetes_bootcamp
      rust_rocket_tavern
    ];
    firewall.allowedUDPPorts = [
      k3s_flannel
      dnsmasq_dns
    ];
  };
}
