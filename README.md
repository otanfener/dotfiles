# Dotfiles
Synchronize personal dotfiles, and install required packages.
## Steps
1) Download Xcode
2) Run ```link.sh``` for symlink.
3) Install Homebrew to `$HOME/.homebrew`:
   - `git clone https://github.com/brew.git $HOME/.homebrew`
   - `brew analytics off`
4) Install Homebrew packages:
   - `brew bundle --global`
5) Change default shell to zsh:
   - `chsh -s $(which zsh)`
6) Install nvim plugin manager
   - `curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim`
7) Install nvim plugins by opening nvim and running:
   - `:PlugInstall`
