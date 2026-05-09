#!/usr/bin/env bash
# =============================================================================
# bin/symlink.sh
# Symlinks all *.symlink files to the home directory (Zach Holman pattern)
# e.g. git/gitconfig.symlink    → ~/.gitconfig
# e.g. zsh/starship.toml.symlink → ~/.config/starship.toml  (special case)
# Claude files are handled by claude/install.sh — skipped here.
# =============================================================================

DOTFILES_DIR="${DOTFILES:-$HOME/.dotfiles}"

link() {
  local src="$1"
  local dst="$2"

  # Ensure parent directory exists
  mkdir -p "$(dirname "$dst")"

  if [ -f "$dst" ] || [ -d "$dst" ] || [ -L "$dst" ]; then
    if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then
      echo "  ✓ already linked: $dst"
      return
    fi
    echo "  ⚠ Backing up existing: $dst → $dst.backup"
    mv "$dst" "$dst.backup"
  fi

  ln -s "$src" "$dst"
  echo "  → $dst"
}

echo "Creating symlinks from $DOTFILES_DIR..."

while IFS= read -r -d '' src; do
  # Skip claude/ topic — handled by claude/install.sh
  [[ "$src" == */claude/* ]] && continue

  filename=$(basename "$src" .symlink)

  # Special cases: files that go to ~/.config/ instead of ~/
  case "$filename" in
    starship.toml)
      dst="$HOME/.config/starship.toml"
      ;;
    *)
      dst="$HOME/.$filename"
      ;;
  esac

  link "$src" "$dst"
done < <(find "$DOTFILES_DIR" -name "*.symlink" -not -path "*/.git/*" -print0)

echo "Done."
