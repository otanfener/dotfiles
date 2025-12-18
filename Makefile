# Makefile for managing dotfiles

# Use bash for all shell commands
SHELL := /bin/bash

# Homebrew installation path
HOMEBREW_DIR := $(HOME)/.homebrew
BREW_CMD := $(HOMEBREW_DIR)/bin/brew

# --- Variables ---
# List of all packages to stow. Add or remove package names here.
PACKAGES := brew direnv editor ghostty git ideavim karabiner notes nvim ripgrep scripts tmux vim zsh

# --- Phony targets (targets that don't represent files) ---
.PHONY: all bootstrap install stow configure-macos setup-shell unstow clean help

# --- Main targets ---

all: bootstrap install stow configure-macos ## Run the full setup: bootstrap Homebrew, install dependencies, stow dotfiles, and configure macOS

bootstrap: ## Initialize Homebrew if not present
	@echo "--> Checking for Homebrew..."
	@if ! command -v brew > /dev/null 2>&1 && [ ! -x "$(BREW_CMD)" ]; then \
		echo "    Homebrew not found. Installing to $(HOMEBREW_DIR)..."; \
		git clone https://github.com/Homebrew/brew.git "$(HOMEBREW_DIR)"; \
		echo "    ✓ Homebrew installed successfully"; \
	else \
		echo "    ✓ Homebrew already available"; \
	fi

install: ## Install Homebrew packages
	@export PATH="$(HOMEBREW_DIR)/bin:$(HOMEBREW_DIR)/sbin:$$PATH"; \
	echo "--> Installing Homebrew packages..."; \
	$(BREW_CMD) bundle --file=brew/.Brewfile

stow: ## Stow all dotfiles using GNU Stow
	@export PATH="$(HOMEBREW_DIR)/bin:$(HOMEBREW_DIR)/sbin:$$PATH"; \
	echo "--> Stowing dotfiles..."; \
	for pkg in $(PACKAGES); do \
		stow -R --target=$(HOME) $$pkg; \
		echo "    Stowed $$pkg"; \
	done

configure-macos: ## Configure macOS system defaults
	@echo "--> Configuring macOS defaults..."
	@defaults write NSGlobalDomain AppleShowScrollBars -string "Always" && \
		echo "    ✓ Show scrollbars always"
	@defaults write com.apple.finder AppleShowAllFiles true && \
		echo "    ✓ Show hidden files in Finder"
	@defaults write com.apple.finder ShowStatusBar -bool true && \
		echo "    ✓ Show Finder status bar"
	@defaults write com.apple.finder NewWindowTarget -string "PfLo" && \
		defaults write com.apple.finder NewWindowTargetPath -string "file://$(HOME)" && \
		echo "    ✓ Set Finder default location to home folder"
	@chflags nohidden ~/Library && \
		echo "    ✓ Unhide ~/Library"
	@defaults write com.apple.screencapture location ~/Downloads && \
		echo "    ✓ Set screenshot location to ~/Downloads"
	@defaults write 'Apple Global Domain' NSAutomaticDashSubstitutionEnabled 0 && \
		echo "    ✓ Disable smart dashes"
	@defaults write 'Apple Global Domain' NSAutomaticQuoteSubstitutionEnabled 0 && \
		echo "    ✓ Disable smart quotes"
	@defaults write 'Apple Global Domain' NSAutomaticPeriodSubstitutionEnabled 0 && \
		echo "    ✓ Disable automatic period substitution"
	@defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false && \
		echo "    ✓ Disable auto capitalization"
	@defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false && \
		echo "    ✓ Disable auto spelling correction"
	@defaults write com.apple.menuextra.battery ShowPercent -string "YES" && \
		echo "    ✓ Show battery percentage in menu bar"
	@defaults write com.apple.dock orientation -string "right" && \
		echo "    ✓ Set Dock position to right side"
	@defaults write com.apple.dock autohide -bool false && \
		echo "    ✓ Disable Dock auto-hide"
	@killall Dock 2>/dev/null || true
	@echo "    Note: Some changes may require logging out or restarting Finder"
	@echo "    You can restart Finder with: killall Finder"

setup-shell: bootstrap ## Change default shell to zsh (requires password)
	@export PATH="$(HOMEBREW_DIR)/bin:$(HOMEBREW_DIR)/sbin:$$PATH"; \
	ZSH_PATH="$$($(BREW_CMD) --prefix)/bin/zsh"; \
	CURRENT_SHELL=$$(dscl . -read ~/ UserShell | awk '{print $$2}'); \
	echo "--> Setting up zsh as default shell..."; \
	if [ "$$CURRENT_SHELL" = "$$ZSH_PATH" ]; then \
		echo "    ✓ zsh is already the default shell"; \
	else \
		echo "    Current shell: $$CURRENT_SHELL"; \
		echo "    Target shell: $$ZSH_PATH"; \
		if ! grep -Fxq "$$ZSH_PATH" /etc/shells; then \
			echo "    Adding $$ZSH_PATH to /etc/shells (requires sudo)..."; \
			echo "$$ZSH_PATH" | sudo tee -a /etc/shells > /dev/null; \
		fi; \
		echo "    Changing default shell (requires password)..."; \
		chsh -s "$$ZSH_PATH"; \
		echo "    ✓ Default shell changed to zsh"; \
		echo "    Note: Restart your terminal for changes to take effect"; \
	fi

unstow: ## Unstow all dotfiles
	@export PATH="$(HOMEBREW_DIR)/bin:$(HOMEBREW_DIR)/sbin:$$PATH"; \
	echo "--> Removing stowed dotfiles..."; \
	for pkg in $(PACKAGES); do \
		stow -D --target=$(HOME) $$pkg; \
		echo "    Unstowed $$pkg"; \
	done

clean: unstow ## Alias for unstow

help: ## Display this help message
	@echo "Usage: make [target]"
	@echo ""
	@echo "Targets:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}'
