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

