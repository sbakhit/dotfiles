#!/usr/bin/env bash
#
# Symlink the dotfiles in this repo into $HOME. Safe to re-run: links that are
# already in place are left alone, and anything else in the way is moved to
# ~/.dotfiles-backup/<timestamp>/ first.

set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"

FILES=(
	.aliases
	.bash_profile
	.bash_prompt
	.bashrc
	.config/git/ignore
	.exports
	.extra
	.functions
	.gitconfig
	.inputrc
	.paths
	.tmux.conf.local
	.vim
	.vimrc
)

# link <path relative to $HOME> <link target>
link() {
	local dst="$HOME/$1" src="$2"

	# Also accept an existing link that resolves to the same place (e.g. a
	# relative one like ~/.vimrc -> dotfiles/.vimrc)
	if [ -L "$dst" ] && [ "$(readlink -f "$dst")" = "$(cd "$(dirname "$dst")" && readlink -f "$src")" ]; then
		echo "ok      ~/$1"
		return
	fi

	if [ -e "$dst" ] || [ -L "$dst" ]; then
		mkdir -p "$(dirname "$BACKUP_DIR/$1")"
		mv "$dst" "$BACKUP_DIR/$1"
		echo "backup  ~/$1 -> ${BACKUP_DIR/#$HOME/\~}/$1"
	fi

	mkdir -p "$(dirname "$dst")"
	ln -s "$src" "$dst"
	echo "link    ~/$1 -> $src"
}

for file in "${FILES[@]}"; do
	link "$file" "$DOTFILES/$file"
done

# Oh my tmux! provides ~/.tmux.conf, and our .tmux.conf.local customizes it
if [ ! -d "$HOME/.tmux" ]; then
	git clone --depth 1 https://github.com/gpakosz/.tmux.git "$HOME/.tmux"
fi
link .tmux.conf .tmux/.tmux.conf

echo
echo "Done. Next: run 'exec bash -l', then start vim once to install its plugins."
