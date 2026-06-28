{pkgs, ...}: let
  tmux-sessionizer = pkgs.writeShellApplication {
    name = "tmux-sessionizer";
    runtimeInputs = with pkgs; [
      fzf
      tmux
    ];
    text = ''
      set -o pipefail

      roots=(
        "$HOME/UbuntuConfig"
        "$HOME/Projects"
        "$HOME/Code"
        "$HOME/dev"
        "$HOME/work"
      )

      candidates=()
      for root in "''${roots[@]}"; do
        if [[ -d "$root" ]]; then
          candidates+=("$root")
          for dir in "$root"/* "$root"/*/*; do
            [[ -d "$dir" ]] && candidates+=("$dir")
          done
        fi
      done

      selected=$(
        printf '%s\n' "''${candidates[@]}" |
          fzf --prompt='tmux session > ' --height=80% --layout=reverse
      )

      [[ -z "$selected" ]] && exit 0

      session_name=$(basename "$selected" | tr '.:' '__')

      if [[ -z "''${TMUX:-}" ]]; then
        tmux new-session -A -s "$session_name" -c "$selected"
      else
        tmux new-session -ds "$session_name" -c "$selected" 2>/dev/null || true
        tmux switch-client -t "$session_name"
      fi
    '';
  };
in {
  home.packages = [tmux-sessionizer];

  programs.tmux = {
    enable = true;
    baseIndex = 1;
    clock24 = true;
    escapeTime = 10;
    historyLimit = 50000;
    keyMode = "vi";
    mouse = true;
    prefix = "M-a";
    sensibleOnTop = true;
    terminal = "tmux-256color";

    plugins = with pkgs.tmuxPlugins; [
      {
        plugin = catppuccin;
        extraConfig = ''
          set -g @catppuccin_flavor 'mocha'
          set -g @catppuccin_window_status_style 'rounded'
          set -g @catppuccin_window_number_position 'right'
          set -g @catppuccin_status_modules_right 'session date_time'
          set -g @catppuccin_date_time_text '%H:%M %d/%m/%Y'
        '';
      }
      {
        plugin = resurrect;
        extraConfig = ''
          set -g @resurrect-capture-pane-contents 'on'
          set -g @resurrect-strategy-nvim 'session'
        '';
      }
      {
        plugin = continuum;
        extraConfig = ''
          set -g @continuum-restore 'on'
          set -g @continuum-save-interval '15'
        '';
      }
    ];

    extraConfig = ''
      set -g renumber-windows on
      set -g set-clipboard on

      set -g status-position top

      bind r source-file ~/.config/tmux/tmux.conf \; display-message 'tmux config reloaded'
      bind f display-popup -E "${tmux-sessionizer}/bin/tmux-sessionizer"
      bind | split-window -h -c '#{pane_current_path}'
      bind - split-window -v -c '#{pane_current_path}'
      bind c new-window -c '#{pane_current_path}'

      bind-key -T copy-mode-vi y send-keys -X copy-pipe-and-cancel '${pkgs.wl-clipboard}/bin/wl-copy'

      bind -n M-h select-pane -L
      bind -n M-j select-pane -D
      bind -n M-k select-pane -U
      bind -n M-l select-pane -R

      bind -n M-H resize-pane -L 5
      bind -n M-J resize-pane -D 5
      bind -n M-K resize-pane -U 5
      bind -n M-L resize-pane -R 5
    '';
  };
}
