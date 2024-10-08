# --- need etcd active BEFORE we launch K3S ---
{
  pkgs,
  config,
  lib,
  ...
}: let
  some_fact = true;
in {
  services.etcd.enable = true;
  #  services.etcd = lib.mkMerge [
  #    (
  #    )
}
