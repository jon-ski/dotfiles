#!/usr/bin/env bash
set -euo pipefail

# Repo root = directory containning this install script.
REPO_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

log() { printf '%s\n' "$*"; }
die() {
  printf 'ERROR: %s\n' "$*" >&2
  exit 1
}

command_exists() { command -v "$1" >/dev/null 2>&1; }

is_debian_like() {
  [ -f /etc/debian_version ] && command_exists apt-get
}

install_apt_packages() {
  sudo apt-get update -y
  sudo apt-get install -y \
    git \
    curl \
    ca-certificates \
    build-essential \
    tmux \
    fzf \
    ripgrep \
    fd-find \
    jq \
    unzip \
    vim
}

main() {
  if ! is_debian_like; then
    die "This bootstrap supports Debian/Ubuntu only (apt)"
  fi

  command_exists sudo || die "sudo is required"

  log "Requesting sudo..."
  sudo -v

  install_apt_packages
}

main "$@"
