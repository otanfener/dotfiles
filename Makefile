# Makefile for managing dotfiles

# Use bash for all shell commands
SHELL := /bin/bash

# --- Variables ---
# List of all packages to stow. Add or remove package names here.
PACKAGES := brew direnv editor ghostty git ideavim karabiner nvim ripgrep scripts tmux vim zsh

# --- Phony targets (targets that don't represent files) ---
.PHONY: all install stow unstow clean help

# --- Main targets ---

all: install stow ## Run the full setup: install dependencies and stow dotfiles

install: ## Install all dependencies (Homebrew, fzf, LazyVim)
	@echo "--> Installing Homebrew packages..."
	@brew bundle --file=brew/.Brewfile

	@echo "--> Installing fzf keybindings and completions..."
	@if [ -f "$(brew --prefix)/opt/fzf/install" ]; then \
		$(brew --prefix)/opt/fzf/install --all; \
	else \
		echo "fzf not found. Please ensure it is in your Brewfile."; \
	fi

	@echo "--> Setting up Neovim configuration..."
	@NVIM_CONFIG="$(HOME)/.config/nvim"; \
	if [ ! -d "$$NVIM_CONFIG" ]; then \
		echo "    Cloning LazyVim starter..."; \
		git clone https://github.com/LazyVim/starter "$$NVIM_CONFIG"; \
		rm -rf "$$NVIM_CONFIG/.git"; \
	else \
		echo "    ~/.config/nvim already exists. Skipping clone."; \
	fi

stow: ## Stow all dotfiles using GNU Stow
	@echo "--> Stowing dotfiles..."
	@for pkg in $(PACKAGES); do \
		stow -R --target=$(HOME) $$pkg; \
		echo "    Stowed $$pkg"; \
	done

unstow: ## Unstow all dotfiles
	@echo "--> Removing stowed dotfiles..."
	@for pkg in $(PACKAGES); do \
		stow -D --target=$(HOME) $$pkg; \
		echo "    Unstowed $$pkg"; \
	done

clean: unstow ## Alias for unstow

help: ## Display this help message
	@echo "Usage: make [target]"
	@echo ""
	@echo "Targets:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}'
