#!/bin/bash
set -xeou pipefail

cd "$(dirname "$0")" || exit

function symlink {
	ln -sfn "$1" "$2"
}

#Suppress login message
[[ ! -e ~/.hushlogin ]] && touch ~/.hushlogin

BLACK=$(tput setaf 0)
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
BLUE=$(tput setaf 4)
MAGENTA=$(tput setaf 5)
CYAN=$(tput setaf 6)
WHITE=$(tput setaf 7)

BOLD=$(tput bold)
RESET=$(tput sgr0)


echo -e "${GREEN}==> Symlink dot files${RESET}"

for file in home/.[^.]*; do
  path="$(pwd)/$file"
  base=$(basename "$file")
  target="$HOME/$(basename "$file")"

  if [[ -h $target && ($(readlink "$target") == "$path")]]; then
    echo -e "${GREEN}~/$base is symlinked to your dotfiles."
  elif [[ -f $target && $(sha256sum "$path" | awk '{print $2}') == $(sha256sum "$target" | awk '{print $2}') ]]; then
    echo -e "${GREEN}~/$base exists and was identical to your dotfile.  Overriding with symlink.${RESET}"
    symlink "$path" "$target"
  elif [[ -a $target ]]; then
    read -p "${RED}~/$base exists and differs from your dotfile. Override?  [yn] ${RESET}" -n 1

    if [[ $REPLY =~ [yY]* ]]; then
      symlink "$path" "$target"
    fi
  else
    echo -e "${GREEN}~/$base does not exist. Symlink to dotfile.${RESET}"
    symlink "$path" "$target"
  fi
done


echo -e "${GREEN}==> Symlink config files${RESET}"

# Install fzf-tab plugin
FZF_TAB=~/fzf-tab
[[ -d "$FZF_TAB" ]] || \
	git clone https://github.com/Aloxaf/fzf-tab "$FZF_TAB"

# Nvim
nvim=~/.config/nvim/init.vim
if [ -e "$nvim" ]; then rm -- "$nvim"; fi
mkdir -p "$(dirname "$nvim")"
symlink "$(pwd)/home/.vimrc"  ~/.config/nvim/init.vim

# Karabiner
karabiner=~/.config/karabiner/karabiner.json
if [ -e "$karabiner" ]; then rm -- "$karabiner"; fi
mkdir -p "$(dirname "$karabiner")"
symlink "$(pwd)/config/karabiner.json" ~/.config/karabiner/karabiner.json 

# Coc settings
coc=~/.config/nvim/coc-settings.json
if [ -e "$coc" ]; then rm -- "$coc"; fi
symlink "$(pwd)/config/coc-settings.json" ~/.config/nvim/coc-settings.json

# Ghostty
ghostty=~/.config/ghostty/config
if [ -e "$ghostty" ]; then rm -- "$ghostty"; fi
mkdir -p "$(dirname "$ghostty")"
symlink "$(pwd)/config/ghostty_config" ~/.config/ghostty/config

