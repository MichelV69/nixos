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
  tcp_kubctl = 6443;
  tcp_kubapi = 8080;
  tcp_kublet_reg = 8888;
  tcp_dnsmasq_dns = 53;
  tcp_dnsmasq_dhcp = 76;
  tcp_rust_rocket_app = 8000;
in {
  networking = {
    firewall.enable = true;
    firewall.allowedTCPPorts = [tcp_ssh tcp_kubctl tcp_kubapi tcp_dnsmasq_dns tcp_kublet_reg tcp_rust_rocket_app];
    firewall.allowedUDPPorts = [tcp_dnsmasq_dhcp];
  };
}
