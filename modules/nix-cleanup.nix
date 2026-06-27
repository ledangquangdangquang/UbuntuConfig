{pkgs, ...}: let
  nixCleanup = pkgs.writeShellApplication {
    name = "nix-cleanup";
    runtimeInputs = [pkgs.nix];
    text = ''
      set -o pipefail

      keep_age="7d"
      profile_dir="$HOME/.local/state/nix/profiles"

      for profile in "$profile_dir/home-manager" "$profile_dir/profile"; do
        if [ -e "$profile" ]; then
          nix profile wipe-history --profile "$profile" --older-than "$keep_age"
        fi
      done

      nix store gc
    '';
  };
in {
  systemd.user.services.nix-cleanup = {
    Unit = {
      Description = "Clean old Nix profile generations and garbage collect the store";
    };

    Service = {
      Type = "oneshot";
      ExecStart = "${nixCleanup}/bin/nix-cleanup";
    };
  };

  systemd.user.timers.nix-cleanup = {
    Unit = {
      Description = "Run weekly Nix store cleanup";
    };

    Timer = {
      OnCalendar = "weekly";
      Persistent = true;
      Unit = "nix-cleanup.service";
    };

    Install = {
      WantedBy = ["timers.target"];
    };
  };
}
