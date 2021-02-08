#!/bin/bash

set -x
set -e 
echo "==> Updating and upgrading packages ..."


sudo apt-get -y update 
sudo apt-get -y upgrade


sudo apt-get install -qq \
	cmake  \
	apt-transport-https \
	gnupg-agent \
	software-properties-common \
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


#Install rga
RGA_VERSION=v0.9.6
RGA_FILE=("$HOME"/ripgrep_all-"$RGA_VERSION"-x86_64-unknown-linux-musl)

if [ ! -d "${RGA_FILE}" ]; then
	cd "$HOME" && curl -sL https://github.com/phiresky/ripgrep-all/releases/download/"$RGA_VERSION"/ripgrep_all-"$RGA_VERSION"-x86_64-unknown-linux-musl.tar.gz | tar -xz
	sudo mv ${RGA_FILE}/rga /usr/local/sbin
fi

#Install Nvm
NVM_VERSION=v0.37.2
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
echo "===> Adding current user to docker group"
sudo usermod -aG docker $USER

#Install Homebrew
LINUXBREW_FILE="${HOME}/.linuxbrew/Homebrew"
if [ ! -d "${LINUXBREW_FILE}" ]; then
	mkdir -p ${HOME}/.linuxbrew/bin 
	git clone https://github.com/Homebrew/brew ~/.linuxbrew/Homebrew
	ln -s ~/.linuxbrew/Homebrew/bin/brew ~/.linuxbrew/bin
fi
# Install Oh-my-zsh
if [ ! -d "${HOME}/.oh-my-zsh" ]; then
	curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh | bash /dev/stdin --unattended
fi

#Install Powerlevel10k theme
POWERLEVEL10K_FILE="${HOME}/.oh-my-zsh/custom/themes/powerlevel10k"
if [ ! -d "${POWERLEVEL10K_FILE}" ]; then
	git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${POWERLEVEL10K_FILE}
fi
# Install NeoVim

if ! [ -x "$(command -v nvim)" ]; then
	curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
	chmod u+x nvim.appimage
	sudo mv nvim.appimage /usr/local/sbin/nvim
	sudo ln -sfn /usr/local/sbin/nvim /usr/bin/vim
fi


#Install NeoVim Plugins

VIM_PLUG_FILE="${HOME}/.local/share/nvim/site/autoload/plug.vim"
if [ ! -f "${VIM_PLUG_FILE}" ]; then 
	echo " ==> Installing vim plugins"
	curl -fLo ${VIM_PLUG_FILE} --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

	mkdir -p "${HOME}/.config/nvim/plugged"
	pushd "${HOME}/.config/nvim/plugged"
	git clone "https://github.com/neoclide/coc.nvim"
	git clone "https://github.com/majutsushi/tagbar"
	git clone  'https://github.com/ludovicchabant/vim-gutentags'
	git clone  'https://github.com/itchyny/lightline.vim'
	git clone  'https://github.com/itchyny/vim-gitbranch'
	git clone  'https://github.com/tomasiser/vim-code-dark'
	git clone  'https://github.com/pangloss/vim-javascript'
	git clone  'https://github.com/ryanoasis/vim-devicons'
	git clone  'https://github.com/szw/vim-maximizer'
	git clone  'https://github.com/christoomey/vim-tmux-navigator'
	git clone  'https://github.com/kassio/neoterm'
	git clone  'https://github.com/tpope/vim-commentary'
	git clone  'https://github.com/sbdchd/neoformat'
	git clone  'https://github.com/AndrewRadev/splitjoin.vim'
	git clone  'https://github.com/ConradIrwin/vim-bracketed-paste'
	git clone  'https://github.com/Raimondi/delimitMate'
	git clone  'https://github.com/SirVer/ultisnips'
	git clone  'https://github.com/arthurxavierx/vim-caser'
	git clone  'https://github.com/cespare/vim-toml'
	git clone  'https://github.com/corylanou/vim-present'
	git clone  'https://github.com/ekalinin/Dockerfile.vim'
	git clone  'https://github.com/elzr/vim-json'
	git clone  'https://github.com/ervandew/supertab'
	git clone  'https://github.com/godlygeek/tabular'
	git clone  'https://github.com/junegunn/fzf'
	git clone  'https://github.com/junegunn/fzf.vim'
	git clone  'https://github.com/mileszs/ack.vim'
	git clone  'https://github.com/plasticboy/vim-markdown'
	git clone  'https://github.com/roxma/vim-tmux-clipboard'
	git clone  'https://github.com/scrooloose/nerdtree'
	git clone  'https://github.com/t9md/vim-choosewin'
	git clone  'https://github.com/tmux-plugins/vim-tmux'
	git clone  'https://github.com/tmux-plugins/vim-tmux-focus-events'
	git clone  'https://github.com/tpope/vim-eunuch'
	git clone  'https://github.com/tpope/vim-fugitive'
	git clone  'https://github.com/airblade/vim-gitgutter'
	git clone  'https://github.com/tpope/vim-repeat'
	git clone  'https://github.com/tpope/vim-scriptease'
fi

#Install ZSH Plugins

if [ ! -d "${HOME}/.zsh" ]; then
	echo " ==> Installing zsh pluings"
	git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${HOME}/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting"
	git clone https://github.com/zsh-users/zsh-autosuggestions "${HOME}/.oh-my-zsh/custom/plugins/zsh-autosuggestions"
fi

#Install TMUX Pluings

if [ ! -d "${HOME}/.tmux/plugins" ]; then
	echo " ==> Installing tmux plugins"
	git clone https://github.com/tmux-plugins/tpm "${HOME}/.tmux/plugins/tpm"
	git clone https://github.com/tmux-plugins/tmux-open.git "${HOME}/.tmux/plugins/tmux-open"
	git clone https://github.com/tmux-plugins/tmux-yank.git "${HOME}/.tmux/plugins/tmux-yank"
	git clone https://github.com/tmux-plugins/tmux-prefix-highlight.git "${HOME}/.tmux/plugins/tmux-prefix-highlight"
fi

echo "==> Creating temporay directory for dot files"
mkdir -p "${HOME}/development"

if [ ! -d "${HOME}/development/dotfiles" ]; then
	echo " ===> Setting up dotfiles"
	pushd "${HOME}/development"
	git clone --recursive https://github.com/otanfener/dotfiles.git
	pushd "${HOME}/development/dotfiles"
	ln -sfn $(pwd)/init.vim "${HOME}/.config/nvim/init.vim"
	ln -sfn $(pwd)/.zshrc "${HOME}/.zshrc"
	ln -sfn $(pwd)/.tmux.conf "${HOME}/.tmux.conf"
	ln -sfn $(pwd)/.gitconfig "${HOME}/.gitconfig"
fi
echo "==> Done"
