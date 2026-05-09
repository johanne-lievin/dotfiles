# =============================================================================
# zsh/aliases.zsh — Global aliases, auto-sourced
# =============================================================================

# ── Navigation ───────────────────────────────────────────────────────────────
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias ~="cd ~"
alias -- -="cd -"

# ── ls → eza ─────────────────────────────────────────────────────────────────
alias ls="eza --icons --group-directories-first"
alias ll="eza -lah --icons --group-directories-first --git"
alias la="eza -a --icons"
alias lt="eza --tree --icons --level=2"
alias lta="eza --tree --icons --level=3 -a --ignore-glob='.git|node_modules'"

# ── cat → bat ────────────────────────────────────────────────────────────────
alias cat="bat --paging=never"
alias catp="bat"  # cat with paging

# ── Git ──────────────────────────────────────────────────────────────────────
alias g="git"
alias gs="git status -sb"
alias ga="git add"
alias gaa="git add --all"
alias gc="git commit -m"
alias gca="git commit -am"
alias gco="git checkout"
alias gcb="git checkout -b"
alias gp="git push"
alias gpl="git pull"
alias gf="git fetch --prune"
alias glog="git log --oneline --graph --decorate --all"
alias gd="git diff"
alias gds="git diff --staged"
alias gundo="git reset HEAD~1 --mixed"
alias gstash="git stash push -m"

# ── Docker ───────────────────────────────────────────────────────────────────
alias d="docker"
alias dc="docker compose"
alias dcu="docker compose up -d"
alias dcd="docker compose down"
alias dcl="docker compose logs -f"
alias dps="docker ps --format 'table {{.Names}}\t{{.Status}}\t{{.Ports}}'"
alias dclean="docker system prune -af --volumes"
alias lzd="lazydocker"

# ── Kubernetes ───────────────────────────────────────────────────────────────
alias k="kubectl"
alias kgp="kubectl get pods"
alias kgs="kubectl get services"
alias kgd="kubectl get deployments"
alias klog="kubectl logs -f"
alias kctx="kubectl config use-context"

# ── Node / JS ─────────────────────────────────────────────────────────────────
alias ni="npm install"
alias nid="npm install --save-dev"
alias nr="npm run"
alias pn="pnpm"
alias pni="pnpm install"
alias pnr="pnpm run"

# ── Go ───────────────────────────────────────────────────────────────────────
alias got="go test ./..."
alias gor="go run ."
alias gob="go build ."
alias gotidy="go mod tidy"

# ── Python ───────────────────────────────────────────────────────────────────
alias python="python3"
alias pip="pip3"

# ── Network ──────────────────────────────────────────────────────────────────
alias myip="curl -s ifconfig.me"
alias localip="ipconfig getifaddr en0"
alias flush="dscacheutil -flushcache && killall -HUP mDNSResponder"
alias ports="lsof -i -P -n | grep LISTEN"

# ── System ───────────────────────────────────────────────────────────────────
alias reloadzsh="source $HOME/.zshrc"
alias zshconfig="$EDITOR $HOME/.zshrc"
alias dotfiles="cd $DOTFILES"
alias brewup="brew update && brew upgrade && brew cleanup"
alias showfiles="defaults write com.apple.finder AppleShowAllFiles YES && killall Finder"
alias hidefiles="defaults write com.apple.finder AppleShowAllFiles NO && killall Finder"

# ── Editor shortcuts ─────────────────────────────────────────────────────────
alias v="nvim"
alias vi="nvim"
alias vim="nvim"
alias code="windsurf"
# ── Utilities ────────────────────────────────────────────────────────────────
alias week="date +%V"
alias timestamp="date -u +'%Y-%m-%dT%H:%M:%SZ'"
alias cpwd="pwd | pbcopy"
alias grep="grep --color=auto"
alias sudo="sudo "  # Allow aliases to work with sudo
alias cleanup="find . -name '.DS_Store' -delete && find . -name '__pycache__' -type d -exec rm -rf {} + 2>/dev/null"
