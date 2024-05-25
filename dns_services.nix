#
# dns_services.nix
#
# provide DNS operations to local LAN
#
{
  pkgs,
  config,
  ...
}: {
  environment.systemPackages = [
    pkgs.dnsmasq
  ];
  services.dnsmasq = {
    enable = true;
    alwaysKeepRunning = false; #only restart on error
    resolveLocalQueries = true;
    settings = {
      domain-needed = true;
      dhcp-range = ["192.168.0.100, 192.168.0.199"];
      server = [
        "192.168.0.1" #edge-router
        "172.105.11.50" #linode server
      ];
    };
    extraConfig = "";
  };

  services.nixops-dns.dnsmasq = true;
}
