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
in {
  networking = {
    firewall.enable = true;
    firewall.allowedTCPPorts = [tcp_ssh tcp_kubctl tcp_kubapi];
    #firewall.allowedUDPPorts = [ ... ];
  };
}
