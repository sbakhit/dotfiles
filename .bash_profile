# Load the shell dotfiles, and then some:
# * ~/.paths sets up `$PATH` (loaded first so the rest can rely on it).
# * ~/.extra holds the WSL ↔ Windows integration. It also sources
#   ~/.extra.local, for settings you don’t want to commit.
for file in ~/.{paths,bash_prompt,exports,aliases,functions,extra}; do
	[ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;

# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob;

# Append to the Bash history file, rather than overwriting it
shopt -s histappend;

# Autocorrect typos in path names when using `cd`
shopt -s cdspell;

# Enable some Bash 4 features when possible:
# * `autocd`, e.g. `**/qux` will enter `./foo/bar/baz/qux`
# * Recursive globbing, e.g. `echo **/*.txt`
for option in autocd globstar; do
	shopt -s "$option" 2> /dev/null;
done;

# Add tab completion for many Bash commands
if ! shopt -oq posix; then
	if [ -f /usr/share/bash-completion/bash_completion ]; then
		source /usr/share/bash-completion/bash_completion;
	elif [ -f /etc/bash_completion ]; then
		source /etc/bash_completion;
	elif [ -f "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh" ]; then
		source "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh";
	fi;
fi;

# Add tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards
[ -e "$HOME/.ssh/config" ] && complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2- | tr ' ' '\n')" scp sftp ssh;

# Let `less` show the contents of archives, PDFs, etc.
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)";

# fzf: Ctrl-R (history), Ctrl-T (files), Alt-C (cd) and `**<Tab>` completion
if command -v fzf > /dev/null; then
	if command -v fdfind > /dev/null; then
		export FZF_DEFAULT_COMMAND='fdfind --type f --hidden --exclude .git';
		export FZF_CTRL_T_COMMAND="${FZF_DEFAULT_COMMAND}";
	fi;
	if fzf_init="$(fzf --bash 2> /dev/null)"; then
		eval "${fzf_init}";
	else
		# fzf before 0.48 (e.g. Debian 12) has no `--bash`; use the scripts the
		# distro package installs instead
		for file in /usr/share/doc/fzf/examples/{key-bindings,completion}.bash \
			/usr/share/fzf/shell/key-bindings.bash /usr/share/fzf/{key-bindings,completion}.bash; do
			[ -r "$file" ] && source "$file";
		done;
		unset file;
	fi;
	unset fzf_init;
fi;

# nvm (Node Version Manager). When reinstalling or upgrading nvm, run its
# installer with `PROFILE=/dev/null` so it doesn't append these lines to ~/.bashrc.
export NVM_DIR="$HOME/.nvm";
[ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh";
[ -s "$NVM_DIR/bash_completion" ] && source "$NVM_DIR/bash_completion";

# OCI CLI tab completion. The glob keeps working when an upgrade moves it to a
# newer Python. If the OCI installer appends this to ~/.bashrc again, drop it.
for file in "$HOME"/lib/oracle-cli/lib/python3.*/site-packages/oci_cli/bin/oci_autocomplete.sh; do
	[ -r "$file" ] && source "$file";
done;
unset file;
