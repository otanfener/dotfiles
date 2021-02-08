# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export AWS_CLI_AUTO_PROMPT=on-partial
export ZSH="${HOME}/.oh-my-zsh"
eval $(${HOME}/.linuxbrew/bin/brew shellenv)

export NVM_DIR=~/.nvm
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(git
	zsh-autosuggestions
	colored-man-pages
	zsh-syntax-highlighting)

source ~/.config/zsh-interactive-cd.plugin.zsh
source $ZSH/oh-my-zsh.sh

if type rg &> /dev/null; then
 export FZF_DEFAULT_COMMAND='rg --files'
 export FZF_DEFAULT_OPTS='-m --height 50% --border'
fi


[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
