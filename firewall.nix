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
  tcp_ssh = 22;
  tcp_mariaDB = 13306;
  tcp_kubctl = 6443;
  tcp_kubapi = 8080;
  tcp_kublet_reg = 8888;
  tcp_dnsmasq_dns = 53;
  tcp_dnsmasq_dhcp = 76;
  tcp_rust_rocket_app1 = 9021;
in {
  networking = {
    firewall.enable = true;
    firewall.allowedTCPPorts = [
      tcp_dnsmasq_dns
      tcp_kubapi
      tcp_kubctl
      tcp_kublet_reg
      tcp_mariaDB
      tcp_rust_rocket_app1
      tcp_ssh
    ];
    firewall.allowedUDPPorts = [tcp_dnsmasq_dhcp];
  };
}
