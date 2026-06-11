{hostMain, ...}: {
  programs.bash = {
    enable = true;
    bashrcExtra = ''
    '';
    shellAliases = {
      c = "clear";
      btw = "echo I use nixos, btw";
      rebuild = "sudo nixos-rebuild switch --impure --flake ~/nixos-flakes-btw#${hostMain.hostname}";
    };
  };
}
