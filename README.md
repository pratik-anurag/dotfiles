# dotfiles

Personal macOS development configuration, currently centered on a portable Neovim setup.

## Install on a new Mac

```sh
git clone https://github.com/pratik-anurag/dotfiles.git ~/dotfiles
brew bundle --file=~/dotfiles/Brewfile
mkdir -p ~/.config
if [ -e ~/.config/nvim ] && [ ! -L ~/.config/nvim ]; then
  mv ~/.config/nvim ~/.config/nvim.backup
fi
ln -sfn ~/dotfiles/nvim ~/.config/nvim
printf '\nsource ~/dotfiles/zsh/nvim.zsh\n' >> ~/.zshrc
exec zsh
nvim --headless '+Lazy! sync' +qa
```

Then open Neovim and run `:Mason` if you want to inspect language-server and formatter installations. Run `:checkhealth` to diagnose a fresh installation.

## Terminal font

This configuration uses Nerd Font icons in the statusline and file explorer. The Brewfile installs **JetBrainsMono Nerd Font Mono**; select it in your terminal application's font settings, then restart the terminal. Without that font, missing icons appear as question marks.

## Neovim essentials

- `Space` opens the WhichKey shortcut guide.
- `Space ff` finds files; `Space fg` searches project text.
- `Space e` toggles the file explorer; `Space t` toggles the terminal.
- `Space gg` opens the Git interface; `Space gd` opens a side-by-side diff.
- `Space xx` opens diagnostics; `Space T` shows test commands; `Space d` shows debug commands.
- `gd` goes to definition; `gr` finds references; `K` shows documentation.

## Updating

```vim
:Lazy update
:Mason
:checkhealth
```

Commit `nvim/lazy-lock.json` whenever plugins change so installs remain reproducible.
