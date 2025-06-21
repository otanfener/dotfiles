HISTFILE=~/.zsh_history
HISTSIZE=5000
SAVEHIST=5000
setopt append_history share_history histignorealldups autocd extendedglob
setopt nomatch notify
unsetopt beep


# Vim mode
bindkey -v
bindkey '^P' up-history
bindkey '^N' down-history
bindkey '^?' backward-delete-char
bindkey '^h' backward-delete-char
bindkey '^w' backward-kill-word
bindkey '^r' history-incremental-search-backward
bindkey -M vicmd '?' history-incremental-search-backward
bindkey -M vicmd '/' history-incremental-search-forward
bindkey -M vicmd "k" history-beginning-search-backward
bindkey -M vicmd "j" history-beginning-search-forward
export KEYTIMEOUT=1
zle-keymap-select () {
	if [ $KEYMAP = vicmd ]; then
		printf "\033[2 q"
	else
		printf "\033[6 q"
	fi
}
zle-line-init () {
	zle -K viins
	printf "\033[6 q"
}


zle -N zle-line-init
zle -N zle-keymap-select
# Enable colors
autoload -U colors && colors

zstyle :compinstall filename '~/.zshrc'

# disable sort when completing `git checkout`
zstyle ':completion:*:git-checkout:*' sort false
# set descriptions format to enable group support
zstyle ':completion:*:descriptions' format '[%d]'
# set list-colors to enable filename colorizing
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# preview directory's content with eza when completing cd
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
# switch group using `,` and `.`
zstyle ':fzf-tab:*' switch-group ',' '.'
# Enable git information.
autoload -Uz vcs_info
zstyle ':vcs_info:git*' formats "%r/%S (%F{green}%b%f)"
zstyle ':vcs_info:git*' actionformats "%r/%S (%F{green}%b%f|%F{yellow}%a%f) %m%u%c"
# Add caching to completion
zstyle ':completion::complete:*' use-cache 1
zstyle ':completion::complete:*' cache-path $ZSH_CACHE_DIR

export DOTFILES_DIR="$HOME/Documents/code/projects/dotfiles"
precmd() {
	vcs_info

	if [[ ${vcs_info_msg_0_} ]]; then
		PS1="${vcs_info_msg_0_} %B%b "
	else
		PS1="%~ %B%b "
	fi

	RPS1="%(?..%B%F{red}%?%f%b)"
}

#Locale configuration
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
# Source scripts
for script in "$DOTFILES_DIR/custom/scripts/"*.sh; do
  [[ -r "$script" ]] && source "$script"
done
# Load customized aliases and functions
if [[ -f "$DOTFILES_DIR/custom/zsh_functions.inc" ]]; then
	source "$DOTFILES_DIR/custom/zsh_functions.inc"
else
	echo >&2 "WARNING: can't load shell functions"
fi

if [[ -f "$DOTFILES_DIR/custom/zsh_aliases.inc" ]]; then
	source "$DOTFILES_DIR/custom/zsh_aliases.inc"
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
	fpath=(${ASDF_DATA_DIR:-$HOME/.asdf}/completions $fpath)

# Reload the zsh-completions
autoload -U compinit
if [[ -z ~/.zcompdump || -n ~/.zcompdump(N.mh+24) ]]; then
  compinit -i # Regenerate the dump file
else
  compinit -i -C # Load from the cache
fi
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
PATH="$HOMEBREW/opt/python@3.11/libexec/bin:$PATH"
# gcloud completion scripts via brew cask installation
if [ -f "$HOMEBREW/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc" ]; then # brew cask installation
	export CLOUDSDK_PYTHON="/$HOMEBREW/opt/python/libexec/bin/python"
	source "$HOMEBREW/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc"
	source "$HOMEBREW/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc"
fi
export USE_GKE_GCLOUD_AUTH_PLUGIN=True
# kubectl completion (w/ refresh cache every 48-hours)
if command -v kubectl > /dev/null; then
	kcomp="$HOME/.kube/.zsh_completion"
	if [ ! -f "$kcomp" ] ||  [ "$(( $(date +"%s") - $(stat -c "%Y" "$kcomp") ))" -gt "172800" ]; then
		mkdir -p "$(dirname "$kcomp")"
		kubectl completion zsh > "$kcomp"
	fi
	source "$kcomp"
fi

# fzf completion. run $HOMEBREW/opt/fzf/install to create the ~/.fzf.* script
if type fzf &>/dev/null && [ -f ~/.fzf.zsh ]; then
	source ~/.fzf.zsh
else
	echo "WARNING: skipping loading fzf.zsh"
fi

if command -v rg > /dev/null; then
 export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --no-ignore-vcs -g "!{node_modules, .git}"'
 export FZF_DEFAULT_OPTS='-m --height 50% --border'
fi
# zsh Tab
if [[ -d "$HOME/Documents/code/library/fzf-tab" ]]; then
	source "$HOME/Documents/code/library/fzf-tab/fzf-tab.plugin.zsh"
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
	source "$HOMEBREW/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
fi

bindkey '^ ' autosuggest-accept
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

# asdf hook
if command -v asdf > /dev/null; then
	eval "$(asdf exec direnv hook zsh)"
fi
#1password hook
if command -v op > /dev/null; then
	eval "$(op completion zsh)"; compdef _op op
fi

if [ "$TERMINAL_EMULATOR" != "JetBrains-JediTerm" ]
then
   ZSH_TMUX_AUTOSTART=true
fi
# asdf bin
PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"
#Kubernetes editor
export KUBE_EDITOR=nvim
#Editor
export EDITOR=nvim
# Export path
export PATH
