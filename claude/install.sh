#!/usr/bin/env bash
# =============================================================================
# claude/install.sh — Install Claude Code CLI and sync ~/.claude/ config
# =============================================================================

set -euo pipefail

DOTFILES_DIR="${DOTFILES:-$HOME/.dotfiles}"
CLAUDE_DIR="$HOME/.claude"

echo "Setting up Claude Code..."

# ── Install Claude Code CLI ───────────────────────────────────────────────────
if ! command -v claude &>/dev/null; then
  echo "  Installing Claude Code CLI..."
  npm install -g @anthropic-ai/claude-code
  echo "  ✓ Claude Code installed: $(claude --version)"
else
  echo "  ✓ Claude Code already installed: $(claude --version)"
fi

# ── Create ~/.claude directory structure ─────────────────────────────────────
mkdir -p \
  "$CLAUDE_DIR/skills" \
  "$CLAUDE_DIR/commands" \
  "$CLAUDE_DIR/agents" \
  "$CLAUDE_DIR/hooks"

# ── Symlink CLAUDE.md ─────────────────────────────────────────────────────────
link_file() {
  local src="$1"
  local dst="$2"
  if [ -f "$dst" ] && [ ! -L "$dst" ]; then
    mv "$dst" "$dst.backup"
    echo "  ⚠ Backed up $dst"
  fi
  ln -sf "$src" "$dst"
  echo "  → $dst"
}

link_file "$DOTFILES_DIR/claude/CLAUDE.md.symlink"      "$CLAUDE_DIR/CLAUDE.md"
link_file "$DOTFILES_DIR/claude/settings.json.symlink"  "$CLAUDE_DIR/settings.json"

# ── Symlink hooks ─────────────────────────────────────────────────────────────
chmod +x "$DOTFILES_DIR/claude/hooks/"*.sh 2>/dev/null || true
for hook in "$DOTFILES_DIR/claude/hooks/"*.sh; do
  [ -f "$hook" ] || continue
  hookname=$(basename "$hook")
  link_file "$hook" "$CLAUDE_DIR/hooks/$hookname"
done

# ── Symlink skills (each skill is a directory) ────────────────────────────────
for skill_dir in "$DOTFILES_DIR/claude/skills/"/*/; do
  [ -d "$skill_dir" ] || continue
  skill_name=$(basename "$skill_dir")
  dst="$CLAUDE_DIR/skills/$skill_name"
  if [ -L "$dst" ]; then
    rm "$dst"
  elif [ -d "$dst" ]; then
    mv "$dst" "$dst.backup"
    echo "  ⚠ Backed up $dst"
  fi
  ln -sf "$skill_dir" "$dst"
  echo "  → $dst (skill)"
done

# ── Symlink slash commands ────────────────────────────────────────────────────
for cmd in "$DOTFILES_DIR/claude/commands/"*.md; do
  [ -f "$cmd" ] || continue
  cmdname=$(basename "$cmd")
  link_file "$cmd" "$CLAUDE_DIR/commands/$cmdname"
done

echo ""
echo "✓ Claude Code configured."
echo "  Skills: $(ls "$CLAUDE_DIR/skills/" 2>/dev/null | tr '\n' ' ')"
echo "  Commands: $(ls "$CLAUDE_DIR/commands/" 2>/dev/null | tr '\n' ' ')"
