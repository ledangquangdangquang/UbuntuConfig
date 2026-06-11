{
  pkgs,
  config,
  ...
}: {
  fonts.fontconfig.enable = true;
  home.packages = [
    # pkgs.nerdfonts
    pkgs.twemoji-color-font
    pkgs.noto-fonts-color-emoji
    pkgs.nerd-fonts.noto
    pkgs.nerd-fonts.jetbrains-mono
  ];

  catppuccin.gtk = {
    icon = {
      enable = true;
      flavor = "mocha";
    };
  };
  gtk = {
    enable = true;
    theme = {
      name = "catppuccin-frappe-blue-standard";
      package = pkgs.catppuccin-gtk;
    };
    font = {
      name = "FiraCode Nerd Font";
      size = 11;
    };
    cursorTheme = {
      name = "Bibata-Modern-Ice";
      package = pkgs.bibata-cursors;
      size = 24;
    };
  };

  home.pointerCursor = {
    name = "Bibata-Modern-Ice";
    package = pkgs.bibata-cursors;
    size = 24;
  };
}
