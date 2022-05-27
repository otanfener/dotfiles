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


#Install NVM
NVM_VERSION=v0.39.1
NVM_FILE="${HOME}/.nvm"
if [ ! -d "{$NVM_FILE}"	]; then
	curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/$NVM_VERSION/install.sh | bash
fi

# Install Oh-my-zsh
if [ ! -d "${HOME}/.oh-my-zsh" ]; then
	curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh | bash /dev/stdin --unattended
fi


#Install ZSH Plugins

if [ ! -d "${HOME}/.zsh" ]; then
	echo -e "${GREEN} ==> Installing zsh plugins ${RESET}"
	git clone --depth 1 https://github.com/zsh-users/zsh-syntax-highlighting.git "${HOME}/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting"
	git clone --depth 1 https://github.com/zsh-users/zsh-autosuggestions "${HOME}/.oh-my-zsh/custom/plugins/zsh-autosuggestions"
fi

#Install TMUX Plugins

if [ ! -d "${HOME}/.tmux/plugins" ]; then
	echo -e "${GREEN} ==> Installing tmux plugins ${RESET}"
	git clone --depth 1 https://github.com/tmux-plugins/tpm "${HOME}/.tmux/plugins/tpm"
	git clone --depth 1 https://github.com/tmux-plugins/tmux-open.git "${HOME}/.tmux/plugins/tmux-open"
	git clone --depth 1 https://github.com/tmux-plugins/tmux-yank.git "${HOME}/.tmux/plugins/tmux-yank"
	git clone --depth 1 https://github.com/tmux-plugins/tmux-prefix-highlight.git "${HOME}/.tmux/plugins/tmux-prefix-highlight"
fi


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

# Alacritty
alacritty=~/.config/alacritty/alacritty.yml
if [ -e "$alacritty" ]; then rm -- "$alacritty"; fi
mkdir -p "$(dirname "$alacritty")"
symlink config/.alacritty.yml $alacritty

# Alacritty color
alacritty_color=~/.config/alacritty/color.yml
if [ -e "$alacritty_color" ]; then rm -- "$alacritty_color"; fi
symlink config/.color.yml $alacritty_color

# Coc settings
coc=~/.config/nvim/coc-settings.json
if [ -e "$coc" ]; then rm -- "$coc"; fi
symlink config/coc-settings.json $coc

echo -e "==> ${YELLOW}(1) chsh -s $(which zsh) ${RESET}"
echo -e "==> ${YELLOW}(2) nvm install node ${RESET}"
echo -e "${YELLOW} curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim ${RESET}"
echo -e "==> ${YELLOW} (3) Run :PlugInstall in Nvim ${RESET}"
