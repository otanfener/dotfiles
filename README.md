# dotfiles and Macbook configuration

Synchronize personal dotfiles, install required packages and configure related Macbook settings.

## OS Configuration

- Show battery percentage -> Show in menu bar
- Configure input sources -> Disable auto capitalization
- Configure spelling check for U.S. English
- Configure Dock to align on right side
- Configure Finder Favorites
- Create Screenshots folder in the `$HOME` directory
- Add Downloads folder to dock
- Create screenshot automation to reduce screenshots size [Screenshot Trick](https://about.gitlab.com/blog/2020/01/30/simple-trick-for-smaller-screenshots/)
- Disable sleep when plugged in the power
- Disable hotkey for spotlight

## Instructions

- Download Xcode
- Install Homebrew to `$HOME/.homebrew`:
  - `git clone https://github.com/Homebrew/brew.git $HOME/.homebrew`
- Change default shell to zsh:

  - ```shell
      chsh -s $(which zsh)
     ```

- Run `link.sh` to complete dotfiles linking
  - `brew analytics off`
- Install Homebrew packages:
  - `brew bundle --global`

    - ```shell
         pip install virtualenv
         pip install virtualenvwrapper
        ```

- Install **nvim** plugin manager

  - ```shell
      curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs 
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
     ```

- Install nvim plugins by opening nvim and running:
  - `:PlugInstall`
- Install necessary providers for nvim

  - ```shell
       pip install --user --upgrade pynvim
     ```

- **fzf** completion:

  - ```shell
     $HOMEBREW/opt/fzf/install
     ```

- **iterm**
  - Go to the profile tab and change fonts
  - Create a new profile
  - Change espace sequence key to work to fzf
  - Create launch command to attach tmux session
    - `tmux attach || tmux new`

- **rectangle**
  - Security -> Accessibility: Give access
  - Launch at login
- **open-in-code**
  - Move Open in Code.app to /Applications
  - Drag it to Finder toolbar while holding command key
