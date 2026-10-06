# Shared interactive Zsh defaults. Host-specific configuration is loaded by
# nvim.zsh from ~/.config/dotfiles/local.zsh when present.

HISTFILE="${XDG_STATE_HOME:-$HOME/.local/state}/zsh/history"
HISTSIZE=50000
SAVEHIST=50000
mkdir -p "${HISTFILE:h}"
setopt append_history inc_append_history share_history hist_ignore_dups hist_reduce_blanks

autoload -Uz compinit
compinit

alias ll='ls -lah'
alias la='ls -A'
alias gs='git status --short --branch'
alias gco='git checkout'
alias gl='git log --oneline --decorate -12'

mkcd() { mkdir -p "$1" && cd "$1" }

PROMPT='%F{cyan}%n@%m%f:%F{blue}%~%f %# '
