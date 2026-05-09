# =============================================================================
# go/path.zsh — Go environment
# =============================================================================

export GOPATH="$HOME/go"
export GOBIN="$GOPATH/bin"
export PATH="$GOBIN:$PATH"

# Use the Homebrew-installed Go
export PATH="/opt/homebrew/opt/go/libexec/bin:$PATH"
