#!/usr/bin/env bash
set -euo pipefail

repo_url="${REPO_URL:-https://github.com/ledangquangdangquang/UbuntuConfig.git}"
repo_dir="${REPO_DIR:-$HOME/UbuntuConfig}"
profile="${HM_PROFILE:-quang}"
backup_ext="${HM_BACKUP_EXT:-backup}"

info() {
	printf '\033[1;34m==>\033[0m %s\n' "$*"
}

warn() {
	printf '\033[1;33m==>\033[0m %s\n' "$*"
}

die() {
	printf '\033[1;31merror:\033[0m %s\n' "$*" >&2
	exit 1
}

ensure_command() {
	command -v "$1" >/dev/null 2>&1
}

ensure_dependencies() {
	local missing_commands=()

	for command_name in git curl xz; do
		if ! ensure_command "$command_name"; then
			missing_commands+=("$command_name")
		fi
	done

	if [ "${#missing_commands[@]}" -gt 0 ]; then
		die "Missing required command(s): ${missing_commands[*]}. Install them with: sudo apt install git curl xz-utils ca-certificates"
	fi

	if [ ! -d /etc/ssl/certs ]; then
		warn "Could not find /etc/ssl/certs. If downloads fail, install ca-certificates."
	fi
}

enable_flakes() {
	local nix_conf="$HOME/.config/nix/nix.conf"

	mkdir -p "$(dirname "$nix_conf")"
	touch "$nix_conf"

	if ! grep -Eq '(^|[[:space:]])nix-command([[:space:]]|$)' "$nix_conf" ||
		! grep -Eq '(^|[[:space:]])flakes([[:space:]]|$)' "$nix_conf"; then
		info "Enabling nix-command and flakes"
		printf '\nexperimental-features = nix-command flakes\n' >>"$nix_conf"
	fi
}

load_nix_profile() {
	if [ -e "$HOME/.nix-profile/etc/profile.d/nix.sh" ]; then
		# shellcheck disable=SC1091
		. "$HOME/.nix-profile/etc/profile.d/nix.sh"
	fi

	if [ -e "/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh" ]; then
		# shellcheck disable=SC1091
		. "/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh"
	fi
}

install_nix() {
	if ensure_command nix; then
		return
	fi

	info "Installing Nix in single-user mode"
	curl -fsSL https://nixos.org/nix/install | sh -s -- --no-daemon --yes
	load_nix_profile
	ensure_command nix || die "Nix was installed, but the nix command is not available yet. Open a new terminal and run this script again."
}

prepare_repo() {
	if [ -d "$repo_dir/.git" ]; then
		info "Using existing repo at $repo_dir"
		git -C "$repo_dir" remote set-url origin "$repo_url"

		local stash_ref=""
		if ! git -C "$repo_dir" diff --quiet ||
			! git -C "$repo_dir" diff --cached --quiet ||
			[ -n "$(git -C "$repo_dir" ls-files --others --exclude-standard)" ]; then
			warn "Local changes detected; stashing them before update"
			git -C "$repo_dir" stash push --include-untracked -m "install.sh auto-stash $(date +%Y-%m-%dT%H:%M:%S%z)"
			stash_ref="$(git -C "$repo_dir" stash list -n 1 --format='%gd')"
		fi

		info "Updating repo"
		git -C "$repo_dir" pull --ff-only

		if [ -n "$stash_ref" ]; then
			info "Restoring stashed local changes"
			if ! git -C "$repo_dir" stash pop "$stash_ref"; then
				warn "Could not apply the stash cleanly. Your changes are still saved in git stash."
			fi
		fi
		return
	fi

	if [ -e "$repo_dir" ]; then
		die "$repo_dir already exists but is not a git repository. Move it away or set REPO_DIR to another path."
	fi

	info "Cloning dotfiles into $repo_dir"
	git clone "$repo_url" "$repo_dir"
}

verify_repo() {
	if ! grep -q '"foot"' "$repo_dir/home.nix" || [ ! -f "$repo_dir/dotfiles/foot/foot.ini" ]; then
		die "Repo at $repo_dir does not contain the expected foot config. Check that it is on the latest main branch."
	fi

	info "Repo commit: $(git -C "$repo_dir" rev-parse --short HEAD)"
}

switch_home_manager() {
	info "Applying Home Manager profile: $profile"

	if ensure_command home-manager; then
		home-manager switch -b "$backup_ext" --flake "$repo_dir#$profile"
	else
		nix run github:nix-community/home-manager -- switch -b "$backup_ext" --flake "$repo_dir#$profile"
	fi
}

main() {
	ensure_dependencies
	install_nix
	enable_flakes
	load_nix_profile
	prepare_repo
	verify_repo
	switch_home_manager
	info "Done. Restart your shell if new commands are not available yet."
}

main "$@"
