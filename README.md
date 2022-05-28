# Dotfiles
Synchronize personal dotfiles, and install required packages.
## Steps
1) Download Xcode
2) Install [oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh)
3) Install Homebrew to `$HOME/.homebrew`:
   - `git clone https://github.com/brew.git $HOME/.homebrew`
   - `brew analytics off`
4) Install Homebrew packages:
   - `brew bundle --global`
5) Install fzf completion:
   - `$HOMEBREW/opt/fzf/install`
6) Install nvim plugin manager
   - `curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim`
7) Run `link.sh` to complete settings sync
8) Change default shell to zsh:
   - `chsh -s $(which zsh)`
9) Install nvim plugins by opening nvim and running:
   - `:PlugInstall`
