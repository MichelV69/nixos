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

  vim_packages = with pkgs; [
    neovim
    vimPlugins.barbecue-nvim
    vimPlugins.zoxide-vim
    vimPlugins.vim-toml
    vimPlugins.vim-ruby
    vimPlugins.vim-rails
    vimPlugins.vim-nix
    vimPlugins.vim-addon-nix
    vimPlugins.vim-markdown
    vimPlugins.vim-lua
    vimPlugins.vim-ledger
    vimPlugins.vim-fugitive
    vimPlugins.vim-crates
    vimPlugins.vim-colorschemes
    vimPlugins.vim-addon-manager
    vimPlugins.vim-addon-completion
    vimPlugins.todo-txt-vim
    vimPlugins.todo-comments-nvim
    vimPlugins.tagbar
    vimPlugins.tabline-nvim
    vimPlugins.vim-airline
  ];
in {
  users.groups = {
    staff = {};
    developers = {};
    sysadmins = {};
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
      extraGroups = ["networkmanager" "wheel" "staff" "developers" "sysadmins"];
      shell = pkgs.zsh;
      packages = with pkgs;
        [
          alejandra
          fzf
          zinit
          zoxide
          gh
        ]
        ++ common_packages
        ++ vim_packages;
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
        ++ common_packages;
    };
  };
}
