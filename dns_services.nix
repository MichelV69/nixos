#
# dns_services.nix
#
# provide DNS operations to local LAN
#
{
  pkgs,
  config,
  ...
}: let
  dhcp_range_low = "192.168.0.100";
  dhcp_range_hi = "192.168.0.199";
  dhcp_expire = "4h";
  dhcp_opt_gateway = 3;
  dhcp_opt_dns = 6;
in {
  environment.systemPackages = [
    pkgs.dnsmasq
  ];
  services.dnsmasq = {
    enable = true;
    alwaysKeepRunning = false; #only restart on error
    resolveLocalQueries = true;
    settings = {
      server = [
        "192.168.0.1" #edge-router
        "172.105.11.50" #linode-server
      ];
      domain-needed = true;
      dhcp-range = ["${dhcp_range_low},${dhcp_range_hi}"];
      #dhcp-expire = dhcp_expire;
      #dhcp-options = [dhcp_opt_gateway dhcp_opt_dns];

      ##static leases
      #dhcp-host=52:54:00:1d:e1:33,192.168.0.33
    };
  };

  services.nixops-dns.dnsmasq = true;
}
