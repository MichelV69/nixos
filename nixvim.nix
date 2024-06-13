{
  pkgs,
  lib,
  ...
}: let
  nixvim = import (builtins.fetchGit {
    url = "https://github.com/nix-community/nixvim";
  });
in {
  imports = [
    nixvim.nixosModules.nixvim
  ];

  programs.nixvim = {
    enable = true;
    opts = {
      number = true; # Show line numbers
      relativenumber = true; # Show relative line numbers

      shiftwidth = 2; # Tab width should be 2
    };

    plugins = {
      lazy.enable = true;
      edgy.enable = true;
      telescope.enable = true;
      chadtree.enable = true;
      lazygit.enable = true;
      airline.enable = true;
    };
  };
}
