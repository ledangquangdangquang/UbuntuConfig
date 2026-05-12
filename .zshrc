eval "$(starship init zsh)"

export EDITOR=nvim
export STARSHIP_CONFIG=~/.config/starship/starship.toml
export FZF_DEFAULT_OPTS=" \
--color=bg+:#313244,bg:#1E1E2E,spinner:#F5E0DC,hl:#F38BA8 \
--color=fg:#CDD6F4,header:#F38BA8,info:#CBA6F7,pointer:#F5E0DC \
--color=marker:#B4BEFE,fg+:#CDD6F4,prompt:#CBA6F7,hl+:#F38BA8 \
--color=selected-bg:#45475A \
--color=border:#6C7086,label:#CDD6F4"
# Catppuccin Mocha for zsh-syntax-highlighting
typeset -A ZSH_HIGHLIGHT_STYLES

# Base syntax
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=#f38ba8,bold'          # red
ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=#cba6f7,bold'          # mauve
ZSH_HIGHLIGHT_STYLES[suffix-alias]='fg=#89b4fa,bold'           # blue
ZSH_HIGHLIGHT_STYLES[global-alias]='fg=#89b4fa,bold'           # blue
ZSH_HIGHLIGHT_STYLES[precommand]='fg=#f9e2af,bold'             # yellow
ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=#9399b2'            # overlay2
ZSH_HIGHLIGHT_STYLES[autodirectory]='fg=#94e2d5,bold'          # teal
ZSH_HIGHLIGHT_STYLES[path]='fg=#89dceb,underline'              # sky
ZSH_HIGHLIGHT_STYLES[path_pathseparator]='fg=#74c7ec'          # sapphire
ZSH_HIGHLIGHT_STYLES[path_prefix]='fg=#89dceb'
ZSH_HIGHLIGHT_STYLES[path_prefix_pathseparator]='fg=#74c7ec'

# Commands
# Catppuccin Mauve for typed commands
ZSH_HIGHLIGHT_STYLES[command]='fg=#cba6f7,bold'
ZSH_HIGHLIGHT_STYLES[alias]='fg=#cba6f7,bold'
ZSH_HIGHLIGHT_STYLES[builtin]='fg=#cba6f7,bold'
ZSH_HIGHLIGHT_STYLES[function]='fg=#cba6f7,bold'
ZSH_HIGHLIGHT_STYLES[hashed-command]='fg=#cba6f7,bold'
ZSH_HIGHLIGHT_STYLES[arg0]='fg=#cba6f7,bold'

# Arguments / strings
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=#f9e2af'      # yellow
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=#f9e2af'      # yellow
ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]='fg=#f9e2af'      # yellow
ZSH_HIGHLIGHT_STYLES[back-quoted-argument]='fg=#fab387'        # peach
ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]='fg=#fab387'
ZSH_HIGHLIGHT_STYLES[back-dollar-quoted-argument]='fg=#fab387'

# Options / operators
ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=#fab387'        # peach
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=#fab387'        # peach
ZSH_HIGHLIGHT_STYLES[back-dollar-quoted-argument-delimiter]='fg=#f38ba8'
ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter]='fg=#cba6f7'
ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter-unquoted]='fg=#cba6f7'
ZSH_HIGHLIGHT_STYLES[process-substitution-delimiter]='fg=#cba6f7'
ZSH_HIGHLIGHT_STYLES[back-quoted-argument-delimiter]='fg=#cba6f7'
ZSH_HIGHLIGHT_STYLES[redirection]='fg=#f5c2e7,bold'            # pink
ZSH_HIGHLIGHT_STYLES[arg0]='fg=#a6e3a1,bold'                   # green

# Brackets / patterns
ZSH_HIGHLIGHT_STYLES[bracket-error]='fg=#f38ba8,bold'          # red
ZSH_HIGHLIGHT_STYLES[bracket-level-1]='fg=#89b4fa,bold'        # blue
ZSH_HIGHLIGHT_STYLES[bracket-level-2]='fg=#cba6f7,bold'        # mauve
ZSH_HIGHLIGHT_STYLES[bracket-level-3]='fg=#f5c2e7,bold'        # pink
ZSH_HIGHLIGHT_STYLES[bracket-level-4]='fg=#fab387,bold'        # peach
ZSH_HIGHLIGHT_STYLES[globbing]='fg=#89dceb,bold'               # sky

# History expansion
ZSH_HIGHLIGHT_STYLES[history-expansion]='fg=#f9e2af,bold'      # yellow

# Comments
ZSH_HIGHLIGHT_STYLES[comment]='fg=#6c7086,italic'              # overlay0
source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
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
alias ll='ls -la'
alias gs='git status'
alias update='sudo apt update && sudo apt upgrade'
alias c='clear'
alias ..='cd ..'

# export GTK_DEBUG = interactive
