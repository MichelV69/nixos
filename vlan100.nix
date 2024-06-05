#
# vlan100.nix
#
# set up packages and services
# for to experiment with VLANs
#
{
  pkgs,
  config,
  ...
}: let
  ip_v4_block = "10.1.1";
  router_address = "${ip_v4_block}.1";
  this_machine = "${ip_v4_block}.11";
in {
  networking = {
    vlans = {
      vlan100 = {
        id = 100;
        interface = "enp1s0";
      };
    };
    interfaces.vlan100.ipv4.addresses = [
      {
        address = "${this_machine}";
        prefixLength = 24;
      }
    ];
  };
}
