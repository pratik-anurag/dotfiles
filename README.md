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

- Starting `nvim` without a file opens the `67` dashboard. Use `f`, `r`, `n`, `s`, or `q` for its quick actions.
- `Space` opens the WhichKey shortcut guide.
- `Space ff` finds files; `Space fg` searches project text.
- `Space e` toggles the file explorer; `Space t` toggles the terminal.
- `Space gg` opens the Git interface; `Space gd` opens a side-by-side diff.
- `Space xx` opens diagnostics; `Space T` shows test commands; `Space d` shows debug commands.
- `gd` goes to definition; `gr` finds references; `K` shows documentation.

## Enhanced workflow

- `s` jumps to visible text; `S` jumps by syntax node.
- `Space o` toggles the current file's symbol outline.
- `Space sr` opens project-wide search and replace; `Space sw` starts it for the word under the cursor.
- `Space or` runs a project task; `Space ot` opens the task list.
- `Space pv` selects the Python virtual environment for the current project.
- JSON and YAML files receive schema-aware completion and validation automatically.
- JavaScript and TypeScript can use the normal debugger controls: `F5`, `F10`, `F11`, and `F12`.
- Markdown files render headings, tables, checkboxes, and code blocks more clearly when opened.

For editing, `mini.ai` adds text objects such as `vif` (select inside function) and `daf` (delete around function). `nvim-surround` adds `ysiw]` (surround word with brackets), `cs\"'` (change double quotes to single quotes), and `ds)` (delete surrounding parentheses).

## Updating

```vim
:Lazy update
:Mason
:checkhealth
```

Commit `nvim/lazy-lock.json` whenever plugins change so installs remain reproducible.
