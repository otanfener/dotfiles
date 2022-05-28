#!/bin/bash
set -x

cd "$(dirname "$0")" || exit

function symlink {
	ln -sfn "$1" "$2"
}

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

mkdir -p ~/.config/nvim
symlink "${HOME}"/.vimrc ~/.config/nvim/init.vim

echo -e "${GREEN}==> Symlink config files${RESET}"

# Karabiner
karabiner=~/.config/karabiner/karabiner.json
if [ -e "$karabiner" ]; then rm -- "$karabiner"; fi
mkdir -p "$(dirname "$karabiner")"

symlink config/karabiner.json $karabiner

# Coc settings
coc=~/.config/nvim/coc-settings.json
if [ -e "$coc" ]; then rm -- "$coc"; fi
symlink config/coc-settings.json $coc

