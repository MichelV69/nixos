{
  pkgs,
  config,
  lib,
  ...
}: {
  services.k3s = {
    enable = true;
    extraFlags = "--cluster-cidr 192.168.0.113/24";
    role = "server";
  };
}
