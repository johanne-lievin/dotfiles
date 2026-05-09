#!/usr/bin/env bash
# =============================================================================
# bin/dots-status.sh
# Fast drift detection — cached brew checks, background git fetch.
# Prints nothing when everything is clean.
# =============================================================================

DOTFILES="${DOTFILES:-$HOME/.dotfiles}"
BREWFILE="$DOTFILES/Brewfile"
CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/dots"
CACHE_FILE="$CACHE_DIR/brew-drift"
CACHE_TTL=$((2 * 24 * 60 * 60))  # 2 days in seconds

YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
RESET='\033[0m'

mkdir -p "$CACHE_DIR"

issues=()
hints=()

# ── 1. Git: uncommitted changes (fast — no network) ──────────────────────────
cd "$DOTFILES" 2>/dev/null || exit 0

if ! git diff --quiet 2>/dev/null || ! git diff --staged --quiet 2>/dev/null; then
  changed=$(git status --short 2>/dev/null | wc -l | tr -d ' ')
  issues+=("${YELLOW}⚠${RESET}  $changed uncommitted change(s) in dotfiles")
  hints+=("  run: ${CYAN}dots commit${RESET}")
fi

# ── 2. Git: unpushed commits (fast — local only) ──────────────────────────────
unpushed=$(git log @{u}.. --oneline 2>/dev/null | wc -l | tr -d ' ')
if [ "$unpushed" -gt 0 ]; then
  issues+=("${YELLOW}⚠${RESET}  $unpushed unpushed commit(s)")
  hints+=("  run: ${CYAN}git -C \$DOTFILES push${RESET}")
fi

# ── 3. Git: behind remote (read cached fetch result — no network block) ───────
FETCH_RESULT="$CACHE_DIR/fetch-behind"
if [ -f "$FETCH_RESULT" ]; then
  behind=$(cat "$FETCH_RESULT" 2>/dev/null || echo 0)
  if [ "${behind:-0}" -gt 0 ]; then
    issues+=("${YELLOW}⚠${RESET}  dotfiles are $behind commit(s) behind remote")
    hints+=("  run: ${CYAN}dots sync${RESET}")
  fi
fi

# Kick off background fetch for next time (non-blocking)
{
  git fetch --quiet origin 2>/dev/null
  git rev-list HEAD..@{u} --count 2>/dev/null > "$FETCH_RESULT" || echo 0 > "$FETCH_RESULT"
} &disown 2>/dev/null

# ── 4. Brew drift (cached — only re-check every 6 hours) ──────────────────────
now=$(date +%s)
cache_valid=false

if [ -f "$CACHE_FILE" ]; then
  cache_mtime=$(stat -f %m "$CACHE_FILE" 2>/dev/null || echo 0)
  age=$(( now - cache_mtime ))
  [ "$age" -lt "$CACHE_TTL" ] && cache_valid=true
fi

if $cache_valid; then
  cached=$(cat "$CACHE_FILE")
  [ -n "$cached" ] && {
    issues+=("${YELLOW}⚠${RESET}  (cached) $cached")
    hints+=("  run: ${CYAN}dots brew install <name>${RESET}  or ${CYAN}dots commit${RESET}")
  }
else
  # Re-check in background — result shows on next terminal open
  {
    drift=""
    brewfile_formulae=$(grep '^brew "' "$BREWFILE" 2>/dev/null | sed 's/brew "\([^"]*\)".*/\1/' | sort)
    installed_formulae=$(brew leaves 2>/dev/null | sort)
    untracked_brews=""
    while IFS= read -r pkg; do
      [ -z "$pkg" ] && continue
      if ! echo "$brewfile_formulae" | grep -q "^${pkg}$" && \
         ! echo "$brewfile_formulae" | grep -q "/${pkg}$"; then
        untracked_brews="$untracked_brews $pkg"
      fi
    done <<< "$installed_formulae"
    [ -n "$untracked_brews" ] && {
      count=$(echo "$untracked_brews" | wc -w | tr -d ' ')
      drift="$count brew(s) not in Brewfile:${untracked_brews}"
    }

    brewfile_casks=$(grep '^cask "' "$BREWFILE" 2>/dev/null | sed 's/cask "\([^"]*\)".*/\1/' | sort)
    installed_casks=$(brew list --cask 2>/dev/null | sort)
    untracked_casks=""
    while IFS= read -r cask; do
      [ -z "$cask" ] && continue
      if ! echo "$brewfile_casks" | grep -q "^${cask}$"; then
        untracked_casks="$untracked_casks $cask"
      fi
    done <<< "$installed_casks"
    [ -n "$untracked_casks" ] && {
      count=$(echo "$untracked_casks" | wc -w | tr -d ' ')
      drift="${drift:+$drift | }$count cask(s) not in Brewfile:${untracked_casks}"
    }

    echo "$drift" > "$CACHE_FILE"
  } &disown 2>/dev/null
fi

# ── 5. Broken symlinks (fast) ─────────────────────────────────────────────────
broken_links=$(find "$HOME" -maxdepth 1 -name ".*" -type l ! -exec test -e {} \; -print 2>/dev/null | wc -l | tr -d ' ')
if [ "$broken_links" -gt 0 ]; then
  issues+=("${YELLOW}⚠${RESET}  $broken_links broken symlink(s) in ~/")
  hints+=("  run: ${CYAN}bash \$DOTFILES/bin/symlink.sh${RESET}")
fi

# ── Output ────────────────────────────────────────────────────────────────────
[ ${#issues[@]} -eq 0 ] && exit 0

echo ""
echo -e "${BOLD}${CYAN}● dotfiles${RESET}"
for i in "${!issues[@]}"; do
  echo -e "  ${issues[$i]}"
  [ -n "${hints[$i]:-}" ] && echo -e "${hints[$i]}"
done
echo ""
