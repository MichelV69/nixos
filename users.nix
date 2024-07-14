# users.nix
#
# Define a user accounts
#
{
  pkgs,
  config,
  ...
}: let
  common_packages = with pkgs; [
    mailutils
    screen
    stow
    wget
  ];

  developer_packages = with pkgs; [
    alejandra
    neovim
    gcc
    gh
    lazygit
    docker
    docker-client
    ctop
  ];
in {
  users.groups = {
    staff = {};
    developers = {};
    sysadmins = {};
    docker = {};
  };

  users.users = {
    michelv69 = {
      isNormalUser = true;
      description = "SysAdmin MichelV69";
      uid = 9902;
      initialPassword = "changeMeRightNow!";
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDNS3lil5pZIcRbnyE97bqxFB55MtkvojJcytHS3hyZ4"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJJ0p9LYcnYnqIFNBezlJ8qq5PELUnunK0BcbcZXQ8l+"
      ];
      extraGroups = ["networkmanager" "wheel" "staff" "developers" "sysadmins" "docker"];
      shell = pkgs.zsh;
      packages = with pkgs;
        [
          w3m
          rustup
          cargo-binstall
          bottom
          gitui
          zellij
          ripgrep
          uutils-coreutils-noprefix
          micro
          fzf
          zinit
          zoxide
          freetype
          fontconfig
        ]
        ++ common_packages
        ++ developer_packages;
    };
    kat_wilson = {
      isNormalUser = true;
      description = "developer kat_wilson";
      uid = 9903;
      initialPassword = "changeMeRightNow!";
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDNS3lil5pZIcRbnyE97bqxFB55MtkvojJcytHS3hyZ4"
      ];
      extraGroups = ["staff" "developers"];
      shell = pkgs.zsh;
      packages = with pkgs;
        [
        ]
        ++ common_packages
        ++ developer_packages;
    };
  };
}
