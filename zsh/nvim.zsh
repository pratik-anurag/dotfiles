# Use Neovim for local tools and Git commit messages.
export EDITOR="nvim"
export VISUAL="nvim"

# Machine-specific settings belong outside this repository.
typeset local_dotfiles_config="${XDG_CONFIG_HOME:-$HOME/.config}/dotfiles/local.zsh"
[[ -r "$local_dotfiles_config" ]] && source "$local_dotfiles_config"
unset local_dotfiles_config
