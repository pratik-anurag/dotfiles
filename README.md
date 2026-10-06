# dotfiles

Personal macOS development configuration, including Neovim, Zsh, Git, Ghostty, and sensible macOS defaults.

## Install on a new Mac

```sh
git clone https://github.com/pratik-anurag/dotfiles.git ~/dotfiles
~/dotfiles/bin/install
exec zsh
```

`bin/install` is safe to run again. It installs Homebrew if necessary, installs the Brewfile, creates the managed symlinks, backs up conflicting files with a timestamp, updates one marked block in `~/.zshrc`, and synchronizes Neovim plugins.

## Local machine configuration

Keep machine-specific and private shell settings in `~/.config/dotfiles/local.zsh`, which is loaded only when it exists. Start with [`zsh/local.example.zsh`](zsh/local.example.zsh). Put work paths, API-adjacent settings, private aliases, and host-specific configuration there—never in this repository.

## Tool ownership

Homebrew provides command-line tools used by Neovim and CI: `ruff`, `stylua`, `prettier`, `prettierd`, `eslint_d`, `golangci-lint`, `yamllint`, and `actionlint`. Mason provides only Neovim-specific LSP servers and debug adapters. This keeps terminal and editor behavior aligned while retaining portable editor setup.

Run a complete local check at any time:

```sh
~/dotfiles/bin/doctor
```

It checks the Brewfile and Nerd Font, Neovim symlink, language tools and formatters, then runs a headless Lazy sync.

## Optional system preferences

Review and apply [`macos/defaults.sh`](macos/defaults.sh) manually:

```sh
~/dotfiles/macos/defaults.sh
```

It sets keyboard repeat, Finder, Dock, screenshots, and trackpad clicking preferences.

## Terminal font

The Brewfile installs **JetBrainsMono Nerd Font Mono**, which Ghostty is configured to use. Select it in another terminal if you do not use Ghostty; otherwise icons in the statusline and file explorer may be missing.

## Neovim essentials

- Starting `nvim` without a file opens the `67` dashboard. Use `f`, `r`, `n`, `s`, or `q` for its quick actions.
- `Space` opens the WhichKey shortcut guide.
- `Space ff` finds files; `Space fg` searches project text; `Space fp` opens recent projects.
- `Space e` toggles the file explorer; `Space t` toggles the terminal.
- `Space gg` opens Git status; `Space gd` opens a side-by-side diff.
- `Space xx` opens diagnostics; `Space T` shows test commands.
- Debug controls are `Space db`, `Space dc`, `Space dr`, and `Space du` (plus `F5`–`F12`); `Space d` is their WhichKey group, not an action.
- `gd` goes to definition; `gr` finds references; `K` shows documentation.

The Neovim entrypoint is deliberately small. Options and keymaps are under `lua/config`; editor, LSP, and debugging plugins are under `lua/plugins`.

## Updating

```vim
:Lazy update
:Mason
:checkhealth
```

Commit `nvim/lazy-lock.json` whenever plugins change so installs remain reproducible. GitHub Actions validates shell formatting, the Brewfile, and headless Neovim startup.
