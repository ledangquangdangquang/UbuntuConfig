{hostMain, ...}: {
  programs.bash = {
    enable = true;
    bashrcExtra = ''
    '';
    shellAliases = {
      c = "clear";
      rebuild = "sudo nixos-rebuild switch --impure --flake ~/nixos-flakes-btw#${hostMain.hostname}";
    };
  };
}
