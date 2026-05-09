# =============================================================================
# rust/path.zsh — Rust/Cargo environment
# =============================================================================

export PATH="$HOME/.cargo/bin:$PATH"

# Source rustup completions if available
[ -f "$HOME/.cargo/env" ] && source "$HOME/.cargo/env"
