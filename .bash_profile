###
#   PATH SETTING
#	Least important first; last wins

# Yarn
export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

# Rust
export PATH="$HOME/.cargo/bin:$PATH"

# Setup Android
export ANDROID_SDK_ROOT=/usr/local/share/android-sdk
export ANDROID_HOME=$ANDROID_SDK_ROOT

# Setup System Gems for Xcode
export PATH="/usr/local/opt/ruby/bin:$PATH"
export PATH="/usr/local/lib/ruby/gems/2.6.1/bin:$PATH"

export LDFLAGS="-L/usr/local/opt/ruby/lib"
export CPPFLAGS="-I/usr/local/opt/ruby/include"
export PKG_CONFIG_PATH="/usr/local/opt/ruby/lib/pkgconfig"

# Add `~/bin` to the `$PATH`, and grab newer OpenSSL, too.
export PATH="$HOME/bin:/usr/local/opt/openssl/bin:/usr/local/opt/curl/bin:$PATH";

# Add Visual Studio Code to the path
export PATH="/Applications/Visual Studio Code.app/Contents/Resources/app/bin:$PATH"


###
#  Other stuff
#

# Load the shell dotfiles, and then some:
# * ~/.path can be used to extend `$PATH`.
# * ~/.extra can be used for other settings you don’t want to commit.
for file in ~/.{path,bash_prompt,exports,aliases,functions,extra}; do
	[ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;

# Load ruby shims
if which rbenv > /dev/null; then
	eval "$(rbenv init -)"
fi;

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

## Bash 4 version
# if which brew &> /dev/null && [ -f "$(brew --prefix)/share/bash-completion/bash_completion" ]; then
# 	source "$(brew --prefix)/share/bash-completion/bash_completion";
# elif [ -f /etc/bash_completion ]; then
# 	source /etc/bash_completion;
# fi;

# Bash 3 version
[ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion

# Enable tab completion for `g` by marking it as an alias for `git`
if type _git &> /dev/null && [ -f /usr/local/etc/bash_completion.d/git-completion.bash ]; then
	complete -o default -o nospace -F _git g;
fi;

# Add tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards
[ -e "$HOME/.ssh/config" ] && complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2- | tr ' ' '\n')" scp sftp ssh;

# Add tab completion for top level projcets
complete -o "default" -o "nospace" -W "$(cd ~/projects && find * -type d -maxdepth 1 | grep /)" p;

# Add tab completion for `defaults read|write NSGlobalDomain`
# You could just use `-g` instead, but I like being explicit
complete -W "NSGlobalDomain" defaults;

# Add `killall` tab completion for common apps
complete -o "nospace" -W "Contacts Calendar Dock Finder Mail Safari iTunes SystemUIServer Terminal Twitter" killall;
