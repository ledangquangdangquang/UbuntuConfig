#!/usr/bin/env bash
set -euo pipefail

repo_url="${REPO_URL:-https://github.com/ledangquangdangquang/UbuntuConfig.git}"
repo_dir="${REPO_DIR:-$HOME/UbuntuConfig}"
profile="${HM_PROFILE:-quang}"

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

ensure_apt_packages() {
	local missing=()

	for package in "$@"; do
		if ! dpkg -s "$package" >/dev/null 2>&1; then
			missing+=("$package")
		fi
	done

	if [ "${#missing[@]}" -eq 0 ]; then
		return
	fi

	ensure_command sudo || die "sudo is required to install: ${missing[*]}"
	info "Installing required Ubuntu packages: ${missing[*]}"
	sudo apt-get update
	sudo DEBIAN_FRONTEND=noninteractive apt-get install -y "${missing[@]}"
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

		if git -C "$repo_dir" diff --quiet && git -C "$repo_dir" diff --cached --quiet; then
			info "Updating repo"
			git -C "$repo_dir" pull --ff-only
		else
			warn "Local changes detected in $repo_dir; skipping git pull"
		fi
		return
	fi

	if [ -e "$repo_dir" ]; then
		die "$repo_dir already exists but is not a git repository. Move it away or set REPO_DIR to another path."
	fi

	info "Cloning dotfiles into $repo_dir"
	git clone "$repo_url" "$repo_dir"
}

switch_home_manager() {
	info "Applying Home Manager profile: $profile"

	if ensure_command home-manager; then
		home-manager switch --flake "$repo_dir#$profile"
	else
		nix run github:nix-community/home-manager -- switch --flake "$repo_dir#$profile"
	fi
}

main() {
	ensure_apt_packages git curl xz-utils ca-certificates
	install_nix
	enable_flakes
	load_nix_profile
	prepare_repo
	switch_home_manager
	info "Done. Restart your shell if new commands are not available yet."
}

main "$@"
