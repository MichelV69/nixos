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
in {
  networking = {
    firewall.enable = true;
    firewall.allowedTCPPorts = [tcp_ssh tcp_kubctl];
    #firewall.allowedUDPPorts = [ ... ];
  };
}
