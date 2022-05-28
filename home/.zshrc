# ZSH Configuration
	export ZSH="/Users/$USER/.oh-my-zsh"

	ZSH_THEME="apple"
	plugins=(git
		zsh-autosuggestions
		colored-man-pages
		)
	source $ZSH/oh-my-zsh.sh

	export ZSH_HIGHLIGHT_MAXLENGTH=60
	export ZSH_UPDATE_DAYS=14
	export DISABLE_UPDATE_PROMPT=true # accept updates by default


# Load customized aliases and functions
if [[ -f "$HOME/dotfiles/custom/zsh_functions.inc" ]]; then
	source "$HOME/dotfiles/custom/zsh_functions.inc"
else
	echo >&2 "WARNING: can't load shell functions"
fi

if [[ -f "$HOME/dotfiles/custom/zsh_aliases.inc" ]]; then
	source "$HOME/dotfiles/custom/zsh_aliases.inc"
else
	echo >&2 "WARNING: can't load shell aliases"
fi

# Homebrew install path customization
	export HOMEBREW="$HOME/.homebrew"
	if [ ! -d "$HOMEBREW" ]; then
		# fallback
        export HOMEBREW=/opt/homebrew # newer
        if [ ! -d "$HOMEBREW" ]; then
            export HOMEBREW=/usr/local
        fi
	fi

	export HOMEBREW_NO_ANALYTICS=1
	export HOMEBREW_NO_INSECURE_REDIRECT=1

	PATH="$HOMEBREW/bin:$HOMEBREW/sbin:$PATH"

	# Add zsh completion scripts installed via Homebrew
	fpath=("$HOMEBREW/share/zsh-completions" $fpath)
	fpath=("$HOMEBREW/share/zsh/site-functions" $fpath)

# Reload the zsh-completions
autoload -U compinit && compinit -i

# coreutils
MANPATH="$HOMEBREW/opt/coreutils/libexec/gnuman:$MANPATH"
PATH="$HOMEBREW/opt/coreutils/libexec/gnubin:$PATH"
PATH="$HOMEBREW/opt/gnu-getopt/bin:$PATH"
PATH="$HOMEBREW/opt/gnu-indent/libexec/gnubin:$PATH"
PATH="$HOMEBREW/opt/gnu-tar/libexec/gnubin:$PATH"
PATH="$HOMEBREW/opt/gnu-sed/libexec/gnubin:$PATH"
PATH="$HOMEBREW/opt/grep/libexec/gnubin:$PATH"
PATH="$HOMEBREW/opt/gnu-time/libexec/gnubin:$PATH"

# go tools
PATH="$PATH:$HOME/gotools/bin"

# git: use system ssh for git, otherwise UseKeychain option doesn't work
export GIT_SSH=/usr/bin/ssh

# python: replace system python
PATH="$HOMEBREW/opt/python/libexec/bin:$PATH"

# gcloud completion scripts via brew cask installation
if [ -f "$HOMEBREW/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc" ]; then # brew cask installation
	export CLOUDSDK_PYTHON="/$HOMEBREW/opt/python@3.8/libexec/bin/python"
	source "$HOMEBREW/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc"
	source "$HOMEBREW/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc"
fi

# kubectl completion (w/ refresh cache every 48-hours)
if command -v kubectl > /dev/null; then
	kcomp="$HOME/.kube/.zsh_completion"
	if [ ! -f "$kcomp" ] ||  [ "$(( $(date +"%s") - $(stat -c "%Y" "$kcomp") ))" -gt "172800" ]; then
		mkdir -p "$(dirname "$kcomp")"
		kubectl completion zsh > "$kcomp"
		log "refreshing kubectl zsh completion to $kcomp"
	fi
	source "$kcomp"
fi

# fzf completion. run $HOMEBREW/opt/fzf/install to create the ~/.fzf.* script
if type fzf &>/dev/null && [ -f ~/.fzf.zsh ]; then
	source ~/.fzf.zsh
else
	log "WARNING: skipping loading fzf.zsh"
fi

if command -v rg > /dev/null; then
 export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --no-ignore-vcs -g "!{node_modules, .git}"'
 export FZF_DEFAULT_OPTS='-m --height 50% --border'
fi

# z completion
if [ -f "$HOMEBREW/etc/profile.d/z.sh" ]; then
    . "$HOMEBREW/etc/profile.d/z.sh"
fi
# load zsh plugins installed via brew
if [[ -d "$HOMEBREW/share/zsh-syntax-highlighting" ]]; then
	source "$HOMEBREW/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi
if [[ -d "$HOMEBREW/share/zsh-autosuggestions" ]]; then
	# source "$HOMEBREW/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
fi

# global ~/go/bin
PATH="${HOME}/go/bin:${PATH}"
# global ~/.cargo/bin
PATH="${HOME}/.cargo/bin:${PATH}"

# direnv hook
if command -v direnv > /dev/null; then
	eval "$(direnv hook zsh)"
fi

# autojump hook
if command -v jump > /dev/null; then
	eval "$(jump shell zsh)"
fi

if [ "$TERMINAL_EMULATOR" != "JetBrains-JediTerm" ]
then 
   ZSH_TMUX_AUTOSTART=true
fi

export NVM_DIR="$HOME/.nvm"

# nvm completion
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


export PATH
