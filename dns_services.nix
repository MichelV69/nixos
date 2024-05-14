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
}
