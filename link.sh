#!/usr/bin/env bash

# Abort on error (-e), on undefined variable (-u), and ensure pipefail is active
set -eou pipefail

# Enable debug mode if DEBUG is set (e.g., DEBUG=1 ./link.sh)
[[ -n "${DEBUG:-}" ]] && set -x

###############################################################################
# Dotfiles directory: path to the folder where this script resides
###############################################################################
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

###############################################################################
# A helper function to create or update a symlink
###############################################################################
function symlink {
  ln -sfn "$1" "$2"
}

# Suppress login message
[[ ! -e ~/.hushlogin ]] && touch ~/.hushlogin

###############################################################################
# Optional: set up some colors/formatting
###############################################################################
BLACK=$(tput setaf 0 || true)
RED=$(tput setaf 1 || true)
GREEN=$(tput setaf 2 || true)
YELLOW=$(tput setaf 3 || true)
BLUE=$(tput setaf 4 || true)
MAGENTA=$(tput setaf 5 || true)
CYAN=$(tput setaf 6 || true)
WHITE=$(tput setaf 7 || true)

BOLD=$(tput bold || true)
RESET=$(tput sgr0 || true)

###############################################################################
# 1) SYMLINK DOT FILES
###############################################################################
echo -e "${GREEN}==> Symlink dot files${RESET}"

for file in "$DOTFILES_DIR"/home/.[^.]*; do
  base="$(basename "$file")"
  target="$HOME/$base"

  # 1. If it's already a symlink pointing to the same file, skip
  if [[ -h "$target" && "$(readlink "$target")" == "$file" ]]; then
    echo -e "${GREEN}~/$base is already symlinked to your dotfiles.${RESET}"
    continue

  # 2. If it's an existing regular file and the contents match, replace with symlink
  elif [[ -f "$target" && \
          "$(sha256sum "$file" | awk '{print $1}')" == "$(sha256sum "$target" | awk '{print $1}')" ]]; then
    echo -e "${GREEN}~/$base exists and was identical to your dotfile. Overriding with symlink.${RESET}"
    symlink "$file" "$target"

  # 3. If it exists but differs, prompt override
  elif [[ -e "$target" ]]; then
    read -p "${RED}~/$base exists and differs from your dotfile. Backup & override? [yN] ${RESET}" -n 1
    echo ""
    if [[ "$REPLY" =~ [yY] ]]; then
      # OPTIONAL: back up the old file/directory
      mv -- "$target" "${target}.bak.$(date +%Y%m%d%H%M%S)"
      symlink "$file" "$target"
    else
      echo -e "${YELLOW}Skipping $base ...${RESET}"
    fi
  else
    # 4. If ~/$base doesn’t exist, just symlink
    echo -e "${GREEN}~/$base does not exist. Symlinking to dotfile.${RESET}"
    symlink "$file" "$target"
  fi
done

###############################################################################
# 2) SYMLINK OTHER CONFIG FILES
###############################################################################
echo -e "${GREEN}==> Symlink config files${RESET}"

# -----------------------------------------------------------------------------
# Install fzf-tab plugin
# -----------------------------------------------------------------------------
FZF_TAB="$HOME/Documents/code/library/fzf-tab"
if [[ ! -d "$FZF_TAB" ]]; then
  git clone https://github.com/Aloxaf/fzf-tab "$FZF_TAB"
fi

# -----------------------------------------------------------------------------
# Neovim config from .vimrc
# -----------------------------------------------------------------------------
NVIM_CONFIG="$HOME/.config/nvim"
if [[ -d "$NVIM_CONFIG" ]]; then
  rm -rf "$NVIM_CONFIG"
fi
git clone https://github.com/LazyVim/starter "$NVIM_CONFIG"
rm -rf "$NVIM_CONFIG/.git"

# -----------------------------------------------------------------------------
# Karabiner
# -----------------------------------------------------------------------------
karabiner="$HOME/.config/karabiner/karabiner.json"
if [[ -e "$karabiner" ]]; then
  rm -- "$karabiner"
fi
mkdir -p "$(dirname "$karabiner")"
symlink "$DOTFILES_DIR/config/karabiner.json" "$karabiner"


# -----------------------------------------------------------------------------
# Ghostty
# -----------------------------------------------------------------------------
ghostty="$HOME/.config/ghostty/config"
if [[ -e "$ghostty" ]]; then
  rm -- "$ghostty"
fi
mkdir -p "$(dirname "$ghostty")"
symlink "$DOTFILES_DIR/config/ghostty_config" "$ghostty"

echo -e "${GREEN}Done!${RESET}"
