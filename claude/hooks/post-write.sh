#!/usr/bin/env bash
# =============================================================================
# claude/hooks/post-write.sh
# Runs after Claude writes/edits a file.
# The modified file path is passed as $CLAUDE_TOOL_INPUT_FILE_PATH
# =============================================================================

set -euo pipefail

FILE="${CLAUDE_TOOL_INPUT_FILE_PATH:-}"

[ -z "$FILE" ] && exit 0
[ ! -f "$FILE" ] && exit 0

EXT="${FILE##*.}"

case "$EXT" in
  ts|tsx|js|jsx|mjs|cjs)
    # Biome format in-place if biome is available
    if command -v biome &>/dev/null; then
      biome format --write "$FILE" 2>/dev/null || true
    fi
    ;;
  go)
    if command -v gofmt &>/dev/null; then
      gofmt -w "$FILE" 2>/dev/null || true
    fi
    ;;
  rs)
    if command -v rustfmt &>/dev/null; then
      rustfmt "$FILE" 2>/dev/null || true
    fi
    ;;
  sh|bash)
    # Ensure shell scripts are executable
    chmod +x "$FILE" 2>/dev/null || true
    ;;
esac

exit 0
