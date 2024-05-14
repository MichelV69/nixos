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
      dhcp-range = ["192.168.0.22,192.168.0.88"];
      server = [
        "8.8.8.8"
        "8.8.4.4"
      ];
    };
    extraConfig = "";
  };

  services.nixops-dns.dnsmasq = true;
}
