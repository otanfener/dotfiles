#!/bin/bash

set -x
set -e 
echo "==> Updating and upgrading packages ..."


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
	echo " ==> Installing zsh pluings"
	git clone --depth 1 https://github.com/zsh-users/zsh-syntax-highlighting.git "${HOME}/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting"
	git clone --depth 1 https://github.com/zsh-users/zsh-autosuggestions "${HOME}/.oh-my-zsh/custom/plugins/zsh-autosuggestions"
fi

#Install TMUX Pluings

if [ ! -d "${HOME}/.tmux/plugins" ]; then
	echo " ==> Installing tmux plugins"
	git clone --depth 1 https://github.com/tmux-plugins/tpm "${HOME}/.tmux/plugins/tpm"
	git clone --depth 1 https://github.com/tmux-plugins/tmux-open.git "${HOME}/.tmux/plugins/tmux-open"
	git clone --depth 1 https://github.com/tmux-plugins/tmux-yank.git "${HOME}/.tmux/plugins/tmux-yank"
	git clone --depth 1 https://github.com/tmux-plugins/tmux-prefix-highlight.git "${HOME}/.tmux/plugins/tmux-prefix-highlight"
fi

echo "==> Symlinking dot files"

ln -sfn $(PWD)/init.vim "${HOME}/.config/nvim/init.vim"
ln -sfn $(PWD)/.zshrc "${HOME}/.zshrc"
ln -sfn $(PWD)/.tmux.conf "${HOME}/.tmux.conf"
ln -sfn $(PWD)/.gitconfig "${HOME}/.gitconfig"
ln -sfn $(PWD)/zsh-interactive-cd.plugin.zsh "${HOME}/.config/zsh-interactive-cd.plugin.zsh"

echo "==> (1) chsh -s $(which zsh)"
echo "==> (2) nvm install node"
echo " curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
echo "==> (3) Run :PlugInstall in Nvim"
