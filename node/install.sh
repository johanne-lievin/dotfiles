#!/usr/bin/env bash
# =============================================================================
# node/install.sh — Install LTS Node and global packages
# =============================================================================

echo "Setting up Node.js..."

# Install latest LTS
fnm install --lts
fnm use lts-latest
fnm default lts-latest

# Global packages — keep minimal, prefer per-project
npm install -g \
  pnpm \
  tsx \
  typescript \
  @biomejs/biome \
  prettier \
  eslint \
  serve \
  nodemon \
  http-server \
  npm-check-updates \
  depcheck

echo "Node.js $(node --version) ready with global packages."
