# dotfiles and Macbook configuration

Synchronize personal dotfiles, install required packages and configure related Macbook settings using GNU Stow.

## Quick Start

### Prerequisites
- macOS (Monterey or later recommended)
- Xcode Command Line Tools (installed automatically if needed)
- Internet connection

### Installation

1. Clone this repository:
   ```bash
   git clone https://github.com/ozantanfener/dotfiles.git ~/dotfiles
   cd ~/dotfiles
   ```

2. Run the setup:
   ```bash
   make all
   ```

   This will:
   - Install Homebrew to `$HOME/.homebrew` (if not already present)
   - Install all packages from `brew/.Brewfile`
   - Configure fzf keybindings and completions
   - Set up Neovim with LazyVim starter
   - Create symlinks for all dotfiles using GNU Stow

3. Change your default shell (optional but recommended):
   ```bash
   make setup-shell
   ```

4. Restart your terminal or run:
   ```bash
   exec zsh -l
   ```

## What Gets Installed

### Package Manager
- **Homebrew**: Installed to `$HOME/.homebrew` for isolation from system packages

### Core Development Tools
- **git**, **gh** (GitHub CLI)
- **neovim**, **vim**
- **tmux** (terminal multiplexer)
- **zsh** (with syntax highlighting and autosuggestions)
- **ripgrep**, **fzf**, **fd** (modern Unix tools)
- **asdf** (language version manager)

### Configuration Tools
- **direnv** (environment management per directory)
- **editorconfig** (consistent coding styles)
- **gnupg** (encryption and signing)
- **stow** (symlink management)

### Desktop Applications
- **Ghostty** (terminal emulator)
- **Visual Studio Code**
- **JetBrains Toolbox**
- **Docker**
- **Rectangle** (window management)
- **Karabiner Elements** (keyboard customization)
- **Obsidian** (note-taking)
- **Raycast** (productivity launcher)

See `brew/.Brewfile` for the complete list of packages.

## Managing Dotfiles

### Update Configuration Files
Edit files directly in their package directories (e.g., `zsh/.zshrc`, `git/.gitconfig`). Changes take effect immediately due to Stow symlinks.

### Add a New Package
1. Create a new directory for the package:
   ```bash
   mkdir myapp
   ```

2. Add configuration files with the target home directory structure:
   ```bash
   mkdir -p myapp/.config/myapp
   echo "config content" > myapp/.config/myapp/config
   ```

3. Add the package name to the `PACKAGES` variable in the Makefile

4. Stow the new package:
   ```bash
   make stow
   ```

### Remove a Package
1. Remove the package name from `PACKAGES` in the Makefile
2. Unstow all packages and restow:
   ```bash
   make unstow
   make stow
   ```
3. Delete the package directory

### Restow Everything
If symlinks get out of sync:
```bash
make unstow  # Remove all symlinks
make stow    # Recreate symlinks
```

## Post-Installation Configuration

### Homebrew Analytics
Homebrew analytics are disabled automatically in `.zshrc`. To verify:
```bash
brew analytics off
brew analytics
```

### fzf Keybindings
The fzf keybindings and completions are installed automatically. If you need to reinstall:
```bash
$HOME/.homebrew/opt/fzf/install --all
```

### Python Virtual Environments (Optional)
```bash
pip install virtualenv
pip install virtualenvwrapper
```

### asdf Language Version Manager (Optional)
```bash
asdf plugin add direnv
asdf plugin add nodejs
asdf plugin add golang
```

Configure `.tool-versions` at the global level for default versions.

### Mermaid CLI (Optional)
For diagram generation:
```bash
npm install -g @mermaid-js/mermaid-cli
```

### Rectangle (Window Management)
- Open System Settings → Privacy & Security → Accessibility
- Give Rectangle access
- Enable "Launch at login" in Rectangle preferences

### Open in Code (Finder Extension)
- Move `Open in Code.app` to `/Applications`
- Drag it to Finder toolbar while holding the Command key

## macOS System Configuration

The following macOS system settings should be configured manually (not automated):

### General Settings
- Show battery percentage in menu bar
- Disable auto capitalization: System Settings → Keyboard → Input Sources
- Configure spelling check for U.S. English
- Align Dock on right side
- Add Downloads folder to Dock
- Configure Finder Favorites

### Screenshots
1. Create Screenshots folder:
   ```bash
   mkdir -p "$HOME/Screenshots"
   ```

2. Set screenshot location:
   ```bash
   defaults write com.apple.screencapture location "$HOME/Screenshots"
   killall SystemUIServer
   ```

3. (Optional) Set up screenshot size reduction automation following [this guide](https://about.gitlab.com/blog/2020/01/30/simple-trick-for-smaller-screenshots/)

### Power Settings
- Disable sleep when plugged in: System Settings → Battery → Power Adapter

### Spotlight
- Disable Spotlight hotkey if using Raycast: System Settings → Keyboard → Keyboard Shortcuts → Spotlight

## Directory Structure

```
dotfiles/
├── Makefile              # Build automation and setup
├── README.md             # This file
├── brew/
│   └── .Brewfile        # Homebrew package definitions
├── git/
│   ├── .gitconfig       # Git configuration
│   ├── .gitignore_global
│   ├── .gitmessage
│   └── .githooks/       # Git hooks (pre-commit, etc.)
├── zsh/
│   ├── .zshrc           # Shell configuration
│   ├── zsh_aliases.inc  # Shell aliases
│   └── zsh_functions.inc # Shell functions
├── nvim/
│   └── .config/nvim/    # Neovim config (LazyVim based)
├── ghostty/
│   └── .config/ghostty/ # Ghostty terminal config
├── tmux/
│   └── .tmux.conf       # Tmux configuration
├── vim/
│   └── .vimrc           # Vim configuration
├── ideavim/
│   ├── .ideavimrc       # IdeaVim configuration
│   └── ideakeymap.xml   # IntelliJ keymap
├── karabiner/
│   └── .config/karabiner.json # Keyboard customization
├── notes/
│   └── .note-templates/ # Note templates for Obsidian
└── [other packages]/    # direnv, editor, ripgrep, scripts
```

## Environment Variables

Key environment variables set by the dotfiles:

- `DOTFILES_DIR`: Path to this repository (dynamically set in `.zshrc`)
- `HOMEBREW`: Path to Homebrew installation (`$HOME/.homebrew`)
- `HOMEBREW_NO_ANALYTICS`: Disable analytics (set to 1)
- `HOMEBREW_NO_INSECURE_REDIRECT`: Security setting
- `EDITOR`: Set to `nvim`
- `KUBE_EDITOR`: Set to `nvim`

## Makefile Targets

- `make all` - Run full setup: bootstrap Homebrew, install dependencies, and stow dotfiles
- `make bootstrap` - Install Homebrew to `$HOME/.homebrew` if not present
- `make install` - Install all Homebrew packages, fzf, and LazyVim
- `make stow` - Create symlinks for all dotfiles packages
- `make setup-shell` - Change default shell to zsh (requires password)
- `make unstow` - Remove all symlinks
- `make clean` - Alias for unstow
- `make help` - Display help message with all targets

## Troubleshooting

### `brew` command not found
After installation, close and reopen your terminal. Or run:
```bash
export PATH="$HOME/.homebrew/bin:$HOME/.homebrew/sbin:$PATH"
```

### Stow conflicts
If you get conflicts about existing files, either:
- Backup and remove the conflicting files from your home directory
- Or use `stow -R` to replace them (this is already in the Makefile)

### Permission issues with `$HOME/.homebrew`
Fix ownership:
```bash
sudo chown -R $(whoami) "$HOME/.homebrew"
```

### LazyVim not loading
Make sure `~/.config/nvim` was created properly:
```bash
ls -la ~/.config/nvim
```
If it's missing, manually clone:
```bash
git clone https://github.com/LazyVim/starter ~/.config/nvim
rm -rf ~/.config/nvim/.git
```

### zsh command not found after changing shell
If you changed your default shell but commands aren't found, make sure your `.zshrc` is loaded:
```bash
source ~/.zshrc
```

## License

MIT License - see LICENSE file for details
