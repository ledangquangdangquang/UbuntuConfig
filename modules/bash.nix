{
  programs.bash = {
    enable = true;
    bashrcExtra = ''
      export PATH="$HOME/bin:$PATH"

    '';
    shellAliases = {
      c = "clear";
      rebuild = "nix run github:nix-community/home-manager -- switch --flake .#quang";
    };
  };
}
