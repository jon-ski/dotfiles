# LS aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias lsl='ls -l'

# Clipboard helpers - auto-detect Wayland vs X11
if [ "$XDG_SESSION_TYPE" = "wayland" ] && command -v wl-copy >/dev/null 2>&1; then
  alias clipset='wl-copy'
  alias clipget='wl-paste'
elif command -v xclip >/dev/null 2>&1; then
  alias clipset='xclip -selection clipboard'
  alias clipget='xclip -o -selection clipboard'
fi
