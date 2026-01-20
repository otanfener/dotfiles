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
├── Makefile               # Build automation and setup
├── README.md              # This file
├── brew/
│   └── .Brewfile          # Homebrew package definitions
├── editor/
│   └── .editorconfig      # EditorConfig settings
├── git/
│   ├── .gitconfig         # Git configuration
│   ├── .gitignore_global
│   └── .gitmessage
├── ghostty/
│   └── .config/ghostty/   # Ghostty terminal config
├── ideavim/
│   └── .ideavimrc         # IdeaVim configuration
├── nvim/
│   └── .config/nvim/      # Neovim config (LazyVim based)
├── ripgrep/
│   └── .rgignore          # ripgrep ignore rules
├── tmux/
│   └── .tmux.conf         # Tmux configuration
├── zk/
│   └── .config/zk/        # ZK config + templates
└── zsh/
    ├── .zshrc             # Shell configuration
    ├── zsh_aliases.inc    # Shell aliases
    └── zsh_functions.inc  # Shell functions
```

## License

MIT License - see LICENSE file for details
