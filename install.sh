#!/usr/bin/env bash
set -euo pipefail

# Repo root = directory containning this install script.
REPO_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

# Destinations
HOME_DIR="$HOME"
XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME_DIR/.config}"

# Bash
ln -sf "$REPO_DIR/bash/.bashrc" "$HOME/.bashrc"
ln -sf "$REPO_DIR/bash/.bash_aliases" "$HOME/.bash_aliases"

# Helix
ln -sf "$REPO_DIR/helix/config.toml" "$HOME/.config/config.toml"
ln -sf "$REPO_DIR/helix/languages.toml" "$HOME/.config/languages.toml"
