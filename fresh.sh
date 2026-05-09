#!/usr/bin/env bash
# =============================================================================
# fresh.sh — Bootstrap a brand new Mac from zero
# Inspired by Dries Vints' clean install script
# =============================================================================

set -uo pipefail
# Note: NOT using -e so a failing brew package doesn't abort the whole setup.

# Always resolve to the directory containing this script
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export DOTFILES="$DOTFILES_DIR"
BOLD='\033[1m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
RESET='\033[0m'

step() { echo -e "\n${CYAN}▶ ${BOLD}$1${RESET}"; }
ok()   { echo -e "  ${GREEN}✓${RESET} $1"; }
warn() { echo -e "  ${YELLOW}⚠${RESET}  $1"; }

echo -e "\n${BOLD}🚀 Setting up your Mac...${RESET}\n"

# ── Xcode CLI tools ──────────────────────────────────────────────────────────
step "Installing Xcode Command Line Tools"
if ! xcode-select -p &>/dev/null; then
  xcode-select --install
  # Wait for it to finish
  until xcode-select -p &>/dev/null; do sleep 5; done
  ok "Xcode CLI tools installed"
else
  ok "Already installed"
fi

# ── Homebrew ─────────────────────────────────────────────────────────────────
step "Installing Homebrew"
if ! command -v brew &>/dev/null; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  # Apple Silicon path
  eval "$(/opt/homebrew/bin/brew shellenv)" 2>/dev/null || eval "$(/usr/local/bin/brew shellenv)"
  ok "Homebrew installed"
else
  ok "Already installed — running update"
  brew update
fi

# ── Brewfile ─────────────────────────────────────────────────────────────────
step "Installing packages from Brewfile"
if brew bundle --file="$DOTFILES_DIR/Brewfile" --verbose 2>&1; then
  ok "All packages installed"
else
  warn "Some packages failed — continuing anyway. Run 'brew bundle --file=$DOTFILES_DIR/Brewfile' later to retry."
fi

# ── Symlinks ─────────────────────────────────────────────────────────────────
step "Symlinking dotfiles (Zach Holman topic style)"
source "$DOTFILES_DIR/bin/symlink.sh"
ok "Symlinks created"

# ── macOS defaults ───────────────────────────────────────────────────────────
step "Applying macOS defaults"
if bash "$DOTFILES_DIR/macos/defaults.sh"; then
  ok "macOS configured"
else
  warn "Some macOS defaults failed — check macos/defaults.sh manually"
fi

# ── Shell ────────────────────────────────────────────────────────────────────
step "Setting zsh as default shell"
if [ "$SHELL" != "$(which zsh)" ]; then
  chsh -s "$(which zsh)"
  ok "Shell changed to zsh"
else
  ok "zsh already default"
fi

# ── Claude Code ──────────────────────────────────────────────────────────────
step "Setting up Claude Code"
source "$DOTFILES_DIR/claude/install.sh"

# ── SSH key ──────────────────────────────────────────────────────────────────
if [ ! -f "$HOME/.ssh/id_ed25519" ]; then
  step "Generating SSH key"
  read -rp "  Enter your GitHub email: " email
  ssh-keygen -t ed25519 -C "$email" -f "$HOME/.ssh/id_ed25519" -N ""
  eval "$(ssh-agent -s)"
  ssh-add --apple-use-keychain "$HOME/.ssh/id_ed25519"
  echo "  Public key (add to GitHub → Settings → SSH keys):"
  echo ""
  cat "$HOME/.ssh/id_ed25519.pub"
fi

echo -e "\n${BOLD}${GREEN}✅ All done! Restart your terminal.${RESET}\n"
