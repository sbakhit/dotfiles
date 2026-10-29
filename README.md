# dotfiles

Bash, vim, tmux and git settings. Made for WSL2 with Windows Terminal, and
also works on other Linux distros (under WSL or not) and on macOS, as long as
the shell is bash.

## Install

```sh
git clone git@github.com:sbakhit/dotfiles.git ~/dotfiles
~/dotfiles/install.sh
exec bash -l
```

`install.sh` symlinks each file below into `$HOME`. It's safe to re-run:
links already in place are left alone, and any other file in the way is moved
to `~/.dotfiles-backup/<timestamp>/` first. It also clones
[Oh my tmux!](https://github.com/gpakosz/.tmux) to `~/.tmux` if it's missing.
Start vim once afterwards so it installs its plugins.

### macOS

macOS ships bash 3.2 and uses zsh by default. Install a current bash with
[Homebrew](https://brew.sh) and make it your login shell first:

```sh
brew install bash bash-completion@2
echo "$(brew --prefix)/bin/bash" | sudo tee -a /etc/shells
chsh -s "$(brew --prefix)/bin/bash"
```

`install.sh` needs macOS 12.3 or later (for `readlink -f`).

### Optional tools

Each is used when installed and skipped otherwise: `fzf`, `fd`, `bat`, `tree`,
`pigz`/`zopfli` (for `targz`), `dig` (for `digga`), nvm, Go and the OCI CLI. On
a Linux desktop, `wl-clipboard` or `xclip` lets `pbcopy`/`pbpaste` use the
desktop clipboard, and `xdg-open` provides `open`.

## What's here

| File | Purpose |
|---|---|
| `.bash_profile` | Shell startup: loads the files below, shell options, completion, fzf, nvm, OCI CLI completion |
| `.bashrc` | Loads `.bash_profile` in interactive shells that aren't login shells |
| `.paths` | `$PATH` setup: Homebrew, `~/bin`, `~/.bin`, `~/.local/bin`, `~/local/bin`, Go |
| `.bash_prompt` | Solarized prompt with the git branch |
| `.exports` | Environment variables: editor, history, man pager |
| `.aliases`, `.functions` | Aliases and shell functions |
| `.extra` | Desktop integration: `open`/`o`, `pbcopy`/`pbpaste` on WSL and Linux (macOS has its own). On WSL also `dl`, `dt`, `code` |
| `.inputrc` | Readline: case-insensitive completion, Up/Down search history by prefix |
| `.vimrc`, `.vim/` | Vim settings, plugins (via vim-plug), Solarized colors |
| `.tmux.conf.local` | Oh my tmux! customizations |
| `.gitconfig`, `.config/git/ignore` | Git settings and global ignore rules |

## Local overrides (not in this repo)

- `~/.extra.local`: loaded last by `.extra`, for private or machine-specific
  shell settings.
- `~/.gitconfig.local`: included by `.gitconfig`. Set your email here; git
  won't commit until one is set:

  ```sh
  git config --file ~/.gitconfig.local user.email you@example.com
  ```

## Notes

- Colors assume the terminal uses the **Solarized Dark** color scheme.
- Where there's no desktop clipboard (WSL, SSH, servers), copying from vim, tmux
  and `pbcopy` goes through the terminal with OSC 52 escape sequences. Windows
  Terminal, iTerm2, kitty, WezTerm and Alacritty support this; GNOME Terminal
  doesn't.
- On WSL, setting `appendWindowsPath=false` under `[interop]` in
  `/etc/wsl.conf` makes tab completion much faster. `.extra` calls Windows
  programs by their full path, so they keep working.
- On Ubuntu with only the `C.UTF-8` locale, switch to `en_US.UTF-8` with
  `sudo locale-gen en_US.UTF-8 && sudo update-locale LANG=en_US.UTF-8`.
