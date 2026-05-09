# =============================================================================
# node/path.zsh — Node.js environment via fnm
# =============================================================================

# fnm (Fast Node Manager) — replaces nvm, written in Rust
export FNM_DIR="$HOME/.fnm"
export FNM_COREPACK_ENABLED=true
export FNM_RESOLVE_ENGINES=true

eval "$(fnm env --use-on-cd --shell zsh)"
