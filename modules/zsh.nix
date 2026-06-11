{hostMain, ...}: {
  programs.zsh = {
    enable = true;
    enableCompletion = true; # Đang bị comment, giữ nguyên
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    initContent = ''
      eval "$(starship init zsh)"
      export EDITOR=nvim
      export STARSHIP_CONFIG=~/.config/starship/starship.toml
      # =========================================================
      # Sửa lại function y() cho Yazi: cd vào thư mục đã chọn
      # =========================================================
      function y() {
        local tmp_file=$(mktemp -t "yazi-cwd.XXXXXX")
        # Đảm bảo file tạm được xóa khi hàm kết thúc (kể cả khi yazi crash)
        trap "rm -f $tmp_file" EXIT

        yazi "$@" --cwd-file="$tmp_file"

        # Đọc nội dung từ file tạm
        local cwd=$(<"$tmp_file")

        # Đổi thư mục nếu $cwd hợp lệ và khác thư mục hiện tại
        if [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
          builtin cd -- "$cwd"
        fi
      }

      # =========================================================
      # function fuzzyvim
      # =========================================================
      fuzzyvim() {
        local file
        file=$(find . -type f \
          | fzf --layout=reverse \
                --height=80% \
                --preview 'bat --style=numbers --color=always {}' \
                --preview-window=right:60%) || return
        nvim "$file"
      }
    '';

    oh-my-zsh = {
      enable = true;
      plugins = ["git" "sudo" "docker"];
      theme = "robbyrussell";
    };
    # zplug = {
    #   enable = true;
    #   plugins = [
    #     {name = "zsh-users/zsh-autosuggestions";}
    #   ];
    # };

    shellAliases = {
      c = "clear";
      btw = "echo I use nixos, btw";
      rebuild = "sudo nixos-rebuild switch --impure --flake ~/nixos-flakes-btw#${hostMain.hostname}";
    };

    history.size = 10000;
  };
}
