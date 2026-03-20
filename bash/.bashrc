# ~/.bashrc: executed by bash(1) for non-login shells.

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return ;;
esac

# ────────────────────────────────────────────
# History
# ────────────────────────────────────────────

HISTCONTROL=ignoreboth
HISTSIZE=1000
HISTFILESIZE=2000
shopt -s histappend

# ────────────────────────────────────────────
# Display / terminal
# ────────────────────────────────────────────

shopt -s checkwinsize

# Colored prompt — covers kitty, alacritty, and standard 256-color terms
case "$TERM" in
    xterm-color|*-256color|xterm-kitty|alacritty) color_prompt=yes ;;
esac

if [ "$color_prompt" = yes ]; then
    PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='\u@\h:\w\$ '
fi
unset color_prompt

# Set terminal title to user@host:dir
case "$TERM" in
    xterm*|rxvt*|xterm-kitty|alacritty)
        PS1="\[\e]0;\u@\h: \w\a\]$PS1" ;;
esac

# ────────────────────────────────────────────
# Core shell environment
# ────────────────────────────────────────────

# Helper: check if a command is available
command_exists() { command -v "$1" >/dev/null 2>&1; }

# Helper: add to PATH without duplicates
path_prepend() { case ":$PATH:" in *:"$1":*) ;; *) export PATH="$1:$PATH" ;; esac; }
path_append()  { case ":$PATH:" in *:"$1":*) ;; *) export PATH="$PATH:$1" ;; esac; }

# Export TTY for GPG
export GPG_TTY=$(tty)

# lesspipe — makes less handle non-text files (available on most distros)
command_exists lesspipe && eval "$(SHELL=/bin/sh lesspipe)"

# Color support for ls and grep
if command_exists dircolors; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='grep -F --color=auto'
    alias egrep='grep -E --color=auto'
fi

# ────────────────────────────────────────────
# PATH additions
# ────────────────────────────────────────────

# Local scripts and binaries
path_prepend "$HOME/.local/bin"

# Doom Emacs (optional)
[ -d "$HOME/.config/emacs/bin" ] && path_prepend "$HOME/.config/emacs/bin:$PATH"

# Go
[ -d "/usr/local/go/bin" ] && path_prepend "/usr/local/go/bin"
command_exists go && path_prepend "$HOME/go/bin"

# Neovim (manual install path - matches any architecture)
for _nvim_dir in /opt/nvim-linux-*/bin; do
    [ -d "$_nvim_dir" ] && path_append "$_nvim_dir" && break
done
unset _nvim_dir

# Rust / Cargo
[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ]             && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ]    && \. "$NVM_DIR/bash_completion"

# ────────────────────────────────────────────
# Aliases
# ────────────────────────────────────────────

# fd - Ubuntu packages the binary as 'fdfind'; alias to fd if needed
command_exists fdfind && alias fd=fdfind

# ────────────────────────────────────────────
# Editor
# ────────────────────────────────────────────

if command_exists hx; then
    export EDITOR="hx"
    export VISUAL="hx"
elif command_exists nvim; then
    export EDITOR="nvim"
    export VISUAL="nvim"
fi

# ────────────────────────────────────────────
# Tool integrations
# ────────────────────────────────────────────

# zoxide (smarter cd)
command_exists zoxide && eval "$(zoxide init bash)"

# fzf
command_exists fzf && eval "$(fzf --bash)"

# Yazi — wrapper that changes directory on exit
if command_exists yazi; then
    function y() {
        local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
        yazi "$@" --cwd-file="$tmp"
        IFS= read -r -d '' cwd < "$tmp"
        [ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
        rm -f -- "$tmp"
    }
fi

# ────────────────────────────────────────────
# Backup (restic) — machine-specific, not committed
# ────────────────────────────────────────────

# Set these in ~/.bashrc.local or similar:
# export RESTIC_REPOSITORY="/mnt/<drive>/restic"
# export RESTIC_PASSWORD_FILE="$HOME/.restic-password"

# ────────────────────────────────────────────
# Completions
# ────────────────────────────────────────────

if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi
fi

# ────────────────────────────────────────────
# Local overrides (machine-specific, not in git)
# ────────────────────────────────────────────

[ -f "$HOME/.bashrc.local" ] && . "$HOME/.bashrc.local"

# ────────────────────────────────────────────
# Aliases file (optional separate file)
# ────────────────────────────────────────────

[ -f "$HOME/.bash_aliases" ] && . "$HOME/.bash_aliases"
