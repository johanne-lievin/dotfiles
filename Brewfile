# =============================================================================
# Brewfile — Curated for JS/Node + Go/Rust + Docker dev
# Run: brew bundle
# =============================================================================

# ── Taps ────────────────────────────────────────────────────────────────────
tap "oven-sh/bun"          # Required for bun
tap "hashicorp/tap"        # Required for terraform

# ── Core CLI ────────────────────────────────────────────────────────────────
brew "git"
brew "git-delta"          # Beautiful git diffs
brew "gh"                 # GitHub CLI
brew "curl"
brew "wget"
brew "jq"                 # JSON in the terminal
brew "yq"                 # YAML in the terminal
brew "bat"                # cat with wings
brew "eza"                # Modern ls (exa successor)
brew "fd"                 # Better find
brew "ripgrep"            # Better grep
brew "fzf"                # Fuzzy finder — life-changing
brew "zoxide"             # Smarter cd
brew "starship"           # Cross-shell prompt
brew "direnv"             # Per-directory env vars
brew "htop"
brew "tldr"               # Practical man pages
brew "tree"
brew "gnu-sed"
brew "gpg"
cask "1password-cli"      # op CLI

# ── JavaScript / Node ───────────────────────────────────────────────────────
brew "fnm"                # Fast Node Manager (replaces nvm)
brew "pnpm"
brew "oven-sh/bun/bun"    # Bun runtime (via official tap)
brew "deno"

# ── Go ──────────────────────────────────────────────────────────────────────
brew "go"
brew "golangci-lint"
brew "air"                # Live reload for Go

# ── Rust ────────────────────────────────────────────────────────────────────
brew "rustup"             # Installs rustc + cargo + rustfmt

# ── Docker / DevOps ─────────────────────────────────────────────────────────
brew "docker"
brew "docker-compose"
brew "lazydocker"         # TUI for Docker
brew "kubectl"
brew "helm"
brew "k9s"                # Kubernetes TUI
brew "hashicorp/tap/terraform"  # Official HashiCorp tap
brew "ansible"
brew "awscli"

# ── Databases ───────────────────────────────────────────────────────────────
brew "postgresql@16", restart_service: :changed
brew "redis", restart_service: :changed  # redis-cli included
brew "sqlite"
brew "pgcli"              # Better psql

# ── Network / HTTP ──────────────────────────────────────────────────────────
brew "httpie"
cask "ngrok"              # Reverse proxy tunnels
brew "mkcert"             # Local HTTPS
brew "rclone"             # Sync to S3, GDrive, etc.

# ── Shell ───────────────────────────────────────────────────────────────────
brew "zsh"
brew "zsh-autosuggestions"
brew "zsh-syntax-highlighting"
brew "zsh-history-substring-search"

# ── Editors ─────────────────────────────────────────────────────────────────
brew "neovim"
cask "visual-studio-code"
cask "windsurf"           # Windsurf AI editor

# ── Terminals ───────────────────────────────────────────────────────────────
cask "warp"
cask "ghostty"

# ── Productivity ────────────────────────────────────────────────────────────
cask "raycast"            # Spotlight replacement
cask "arc"                # Browser
cask "1password"
cask "obsidian"
cask "notion"
cask "linear"             # Linear project management

# ── Communication ───────────────────────────────────────────────────────────
cask "slack"
cask "discord"

# ── Security ────────────────────────────────────────────────────────────────
cask "keepassxc"          # Password manager (KeePassX successor)

# ── Fonts ───────────────────────────────────────────────────────────────────
cask "font-jetbrains-mono-nerd-font"
cask "font-monaspace"

# ── macOS Apps ──────────────────────────────────────────────────────────────
cask "bartender"          # Menu bar manager
cask "rectangle"          # Window snapping
cask "istat-menus"
cask "imageoptim"
cask "keka"               # Archive utility
