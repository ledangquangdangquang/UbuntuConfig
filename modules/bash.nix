{hostMain, ...}: {
  programs.bash = {
    enable = true;
    bashrcExtra = ''
    export PATH="$HOME/bin:$PATH"

    '';
    shellAliases = {
      c = "clear";
      rebuild = "sudo nixos-rebuild switch --impure --flake ~/nixos-flakes-btw#${hostMain.hostname}";
    };
  };
}
