# dotfiles

> A thoughtfully assembled Mac development environment.
> Inspired by the best of Mathias Bynens, Zach Holman, and Dries Vints.

## What's inside

| Source | What we borrowed |
|--------|-----------------|
| **Mathias Bynens** | `.macos` defaults script — hundreds of sensible system tweaks |
| **Zach Holman** | Topic folder architecture — auto-sourced, infinitely scalable |
| **Dries Vints** | `fresh.sh` bootstrap + clean Brewfile structure |

## Stack

- **JS/Node** via `fnm` (fast, auto-switches per project)
- **Go** with proper `GOPATH`
- **Rust** via `rustup`
- **Docker** + `lazydocker` + Kubernetes (`k9s`)
- **Shell**: `zsh` + `starship` prompt + `fzf` + `zoxide` + `bat` + `eza`

---

## First-time setup (brand new Mac)

```sh
# 1. Clone to ~/.dotfiles
git clone https://github.com/YOU/dotfiles.git ~/.dotfiles
cd ~/.dotfiles

# 2. Copy your personal git identity (NOT tracked in git)
cp git/gitconfig.local.example ~/.gitconfig.local
# Edit it: name, email, optional signing key

# 3. Run the bootstrap
chmod +x fresh.sh
./fresh.sh
```

That's it. The script handles:
- Xcode CLI tools
- Homebrew + all packages from `Brewfile`
- Symlinking all `*.symlink` files to `~/`
- Applying macOS defaults
- Setting zsh as default shell
- Generating an SSH key for GitHub

---

## Architecture (Zach Holman topic pattern)

```
dotfiles/
├── fresh.sh              # One-shot bootstrap (run once on new Mac)
├── Brewfile              # All packages: CLI, apps, fonts
│
├── bin/
│   └── symlink.sh        # Symlinks *.symlink → ~/.<name>
│
├── git/
│   ├── gitconfig.symlink         → ~/.gitconfig
│   └── gitignore_global.symlink  → ~/.gitignore_global
│
├── zsh/
│   ├── zshrc.symlink     → ~/.zshrc
│   ├── aliases.zsh       # Auto-sourced
│   └── starship.toml.symlink → ~/.config/starship.toml
│
├── node/
│   ├── path.zsh          # fnm init — auto-sourced (path files load first)
│   └── install.sh        # Install LTS + global packages
│
├── go/
│   ├── path.zsh          # GOPATH, GOBIN — auto-sourced
│   └── aliases.zsh       # gonew, gocover helpers
│
├── rust/
│   └── path.zsh          # Cargo bin — auto-sourced
│
├── docker/
│   └── aliases.zsh       # dexec, dlogs, dstats, dcleanup
│
└── macos/
    └── defaults.sh       # System defaults (run by fresh.sh)
```

### How auto-sourcing works

Your `~/.zshrc` scans every `**/*.zsh` file in this repo and sources it automatically. The order is:
1. `path.zsh` files first (set `$PATH` before anything else)
2. All other `*.zsh` files
3. `completion.zsh` files last (after `compinit`)

To **add a new topic**: create a folder, drop in `*.zsh` files. Done.

---

## Customisation

### Machine-specific overrides
Create `~/.zshrc.local` — it's sourced last and never tracked in git. Put work VPN aliases, private tokens, machine-specific paths here.

### Git identity
Create `~/.gitconfig.local`:
```ini
[user]
  name  = Your Name
  email = you@example.com
```

### Add/remove Homebrew packages
Edit `Brewfile`, then run:
```sh
brew bundle
```

### Tweak macOS defaults
Edit `macos/defaults.sh` and re-run:
```sh
source macos/defaults.sh
```

---

## Updating

```sh
cd ~/.dotfiles
git pull
brew bundle         # install any new packages
source ~/.zshrc     # reload shell
```

---

## Key aliases

| Alias | Command |
|-------|---------|
| `ll` | `eza -lah --icons --git` |
| `cat` | `bat --paging=never` |
| `gs` | `git status -sb` |
| `glog` | Pretty git graph |
| `d` / `dc` | `docker` / `docker compose` |
| `dcu` / `dcd` | compose up/down |
| `lzd` | `lazydocker` |
| `k` | `kubectl` |
| `got` | `go test ./...` |
| `brewup` | update + upgrade + cleanup |
| `myip` | External IP |
| `ports` | Listening ports |
