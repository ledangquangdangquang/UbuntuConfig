{
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "ledangquangdangquang";
        email = "quang.ld224113@sis.hust.edu.vn";
      };
      init.defaultBranch = "main";
      credential.helper = "store";
      alias.acp = ''!f() { git add . && git commit -m "$1" && git push; }; f'';
    };
  };

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings."github.com" = {
      IdentityFile = "~/.ssh/id_ed25519";
      User = "git";
    };
  };

  services.ssh-agent.enable = true;
}
