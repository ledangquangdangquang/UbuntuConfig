{
  config,
  inputs,
  pkgs,
  hostMain,
  user,
  ...
}: let
  dotfiles = "${config.home.homeDirectory}/UbuntuConfig/dotfiles";
  create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;
in {
  imports = [
    inputs.catppuccin.homeModules.catppuccin
    ./modules
  ];
  home.username = "${user}";
  home.homeDirectory = "/home/${user}";
  home.stateVersion = hostMain.stateVersion;
  targets.genericLinux.enable = true;
# ---------------------------------------------------------------------------
# ------------------------------ CONFIG FILE --------------------------------
# ---------------------------------------------------------------------------
  xdg.configFile."bat" = {
    source = create_symlink "${dotfiles}/bat/";
    recursive = true;
  };
  xdg.configFile."DankMaterialShell" = {
    source = create_symlink "${dotfiles}/DankMateriaShell/";
    recursive = true;
  };
  xdg.configFile."nvim" = {
    source = create_symlink "${dotfiles}/nvim/";
    recursive = true;
  };
  xdg.configFile."niri" = {
    source = create_symlink "${dotfiles}/niri/";
    recursive = true;
  };
  # programs.noctalia-shell.enable = true;
  # xdg.configFile."noctalia" = {
  #   source = create_symlink "${dotfiles}/noctalia/";
  #   recursive = true;
  # };
  xdg.configFile."kitty" = {
    source = create_symlink "${dotfiles}/kitty/";
    recursive = true;
  };
  xdg.configFile."starship" = {
    source = create_symlink "${dotfiles}/starship/";
    recursive = true;
  };
  xdg.configFile."yazi" = {
    source = create_symlink "${dotfiles}/yazi/";
    recursive = true;
  };
  home.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
    wl-clipboard
    fzf
    tree
    bat
    git
    kitty
    fuzzel
    fastfetch
    swaybg
    neovim
    alejandra
    ripgrep
    nil
    nixpkgs-fmt
    nodejs
    btop
    gcc
    yazi
    starship
  ];
}
