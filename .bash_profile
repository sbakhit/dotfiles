# Add `~/bin` to the `$PATH` if it exists
[ -d $HOME/bin ] && export PATH="$HOME/bin:$PATH";
# Add `~/.local/bin` to the `$PATH` if it exists
[ -d $HOME/.local/bin ] && export PATH="$HOME/.local/bin:$PATH";
# Add `/usr/local/cuda-10.1/bin/` to the `$PATH` if it exists
[ -d /usr/local/cuda-10.1/bin ] && export PATH="/usr/local/cuda-10.1/bin:$PATH";
# Add `/usr/local/go/bin/` to the `$PATH` if it exists
[ -d /usr/local/go/bin ] && export PATH="/usr/local/go/bin:$PATH";

# Load the shell dotfiles, and then some:
# * ~/.path can be used to extend `$PATH`.
# * ~/.extra can be used for other settings you don’t want to commit.
for file in ~/.{path,bash_prompt,exports,aliases,functions,extra}; do
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
if [ -f /etc/bash_completion ]; then
	source /etc/bash_completion;
fi;

# Add tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards
[ -e "$HOME/.ssh/config" ] && complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2- | tr ' ' '\n')" scp sftp ssh;

# kubectl bash completion
source <(kubectl completion bash)

# helm bash completion
source <(helm completion bash)

# kubeone bash completion
source <(kubeone completion bash)

# minikube bash completion
source <(minikube completion bash)

# leetcode bash completion
source <(leetcode completion)

# source vte.sh for tilix terminal
if [ $TILIX_ID ] || [ $VTE_VERSION ]; then
        source /etc/profile.d/vte.sh
fi
