#!/bin/bash
set -x
set -e 

cd "$(dirname "$0")"

function symlink {
	ln -sfn $1 $2
}

BLACK=`tput setaf 0`
RED=`tput setaf 1`
GREEN=`tput setaf 2`
YELLOW=`tput setaf 3`
BLUE=`tput setaf 4`
MAGENTA=`tput setaf 5`
CYAN=`tput setaf 6`
WHITE=`tput setaf 7`

BOLD=`tput bold`
RESET=`tput sgr0`

echo -e "==> ${GREEN}Updating and upgrading packages ...${RESET}"


sudo apt-get -y update 
sudo apt-get -y upgrade


sudo apt-get install -qq \
	cmake  \
	fzf \
	apt-transport-https \
	gnupg-agent \
	software-properties-common \
	python3.8 \
	python3-pip \
	curl \
	git \
	ripgrep \
	pandoc \
	poppler-utils \
	ffmpeg \
	silversearcher-ag \
	zsh \
	socat \
	tmux \
	tree \
	unzip \
 	wget \
	universal-ctags \
	ca-certificates \
	build-essential \
	-y --no-install-recommends \

#Install neovim plugin
pip3 install neovim
#Install rga
RGA_VERSION=v0.9.6
RGA_FILE=("$HOME"/ripgrep_all-"$RGA_VERSION"-x86_64-unknown-linux-musl)

if [ ! -d "${RGA_FILE}" ]; then
	cd "$HOME" && curl -sL https://github.com/phiresky/ripgrep-all/releases/download/"$RGA_VERSION"/ripgrep_all-"$RGA_VERSION"-x86_64-unknown-linux-musl.tar.gz | tar -xz
	sudo mv ${RGA_FILE}/rga /usr/local/sbin
	rm -rf ${RGA_FILE}
fi

#Install Nvm
NVM_VERSION=v0.38
NVM_FILE="${HOME}/.nvm"

if [ ! -d "{$NVM_FILE}"	]; then
	curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.37.2/install.sh | bash
fi

#Install Docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add  -
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
    focal \
   stable"
sudo apt-get -y update

sudo apt-get install -qq \
	 docker-ce \
	 docker-ce-cli \
	 containerd.io \
	 -y \
# Docker post install
echo -e "${GREEN}===> Adding current user to docker group${RESET}"
sudo usermod -aG docker $USER

#Install Homebrew
LINUXBREW_FILE="${HOME}/.linuxbrew/Homebrew"
if [ ! -d "${LINUXBREW_FILE}" ]; then
	mkdir -p ${HOME}/.linuxbrew/bin 
	git clone --depth 1 https://github.com/Homebrew/brew ~/.linuxbrew/Homebrew
	ln -s ~/.linuxbrew/Homebrew/bin/brew ~/.linuxbrew/bin
fi
# Install Oh-my-zsh
if [ ! -d "${HOME}/.oh-my-zsh" ]; then
	curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh | bash /dev/stdin --unattended
fi

#Install Powerlevel10k theme
POWERLEVEL10K_FILE="${HOME}/.oh-my-zsh/custom/themes/powerlevel10k"
if [ ! -d "${POWERLEVEL10K_FILE}" ]; then
	git clone --depth 1 https://github.com/romkatv/powerlevel10k.git ${POWERLEVEL10K_FILE}
fi
# Install NeoVim

if ! [ -x "$(command -v nvim)" ]; then
	curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
	chmod u+x nvim.appimage
	sudo mv nvim.appimage /usr/local/sbin/nvim
	sudo ln -sfn /usr/local/sbin/nvim /usr/bin/vim
fi

#Install ZSH Plugins

if [ ! -d "${HOME}/.zsh" ]; then
	echo -e "${GREEN} ==> Installing zsh pluings ${RESET}"
	git clone --depth 1 https://github.com/zsh-users/zsh-syntax-highlighting.git "${HOME}/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting"
	git clone --depth 1 https://github.com/zsh-users/zsh-autosuggestions "${HOME}/.oh-my-zsh/custom/plugins/zsh-autosuggestions"
fi

#Install TMUX Pluings

if [ ! -d "${HOME}/.tmux/plugins" ]; then
	echo -e "${GREEN} ==> Installing tmux plugins ${RESET}"
	git clone --depth 1 https://github.com/tmux-plugins/tpm "${HOME}/.tmux/plugins/tpm"
	git clone --depth 1 https://github.com/tmux-plugins/tmux-open.git "${HOME}/.tmux/plugins/tmux-open"
	git clone --depth 1 https://github.com/tmux-plugins/tmux-yank.git "${HOME}/.tmux/plugins/tmux-yank"
	git clone --depth 1 https://github.com/tmux-plugins/tmux-prefix-highlight.git "${HOME}/.tmux/plugins/tmux-prefix-highlight"
fi

echo -e "${GREEN}==> Symlinking dot files${RESET}"

for file in home/.[^.]*; do
  path="$(pwd)/$file"
  base=$(basename $file)
  target="$HOME/$(basename $file)"

  if [[ -h $target && ($(readlink $target) == $path)]]; then
    echo -e "${GREEN}~/$base is symlinked to your dotfiles."
  elif [[ -f $target && $(sha256sum $path | awk '{print $2}') == $(sha256sum $target | awk '{print $2}') ]]; then
    echo -e "${GREEN}~/$base exists and was identical to your dotfile.  Overriding with symlink.${RESET}"
    symlink $path $target
  elif [[ -a $target ]]; then
    read -p "${RED}~/$base exists and differs from your dotfile. Override?  [yn] ${RESET}" -n 1

    if [[ $REPLY =~ [yY]* ]]; then
      symlink $path $target
    fi
  else
    echo -e "${GREEN}~/$base does not exist. Symlinking to dotfile.${RESET}"
    symlink $path $target
  fi
done

ln -sfn $(pwd)/home/zsh-interactive-cd.plugin.zsh "${HOME}/.config/zsh-interactive-cd.plugin.zsh"

mkdir -p ~/.config/nvim
ln -sfn ${HOME}/.vimrc ~/.config/nvim/init.vim

echo -e "==> ${YELLOW}(1) chsh -s $(which zsh) ${RESET}"
echo -e "==> ${YELLOW}(2) nvm install node ${RESET}"
echo -e "${YELLOW} curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim ${RESET}"
echo -e "==> ${YELLOW} (3) Run :PlugInstall in Nvim ${RESET}"
