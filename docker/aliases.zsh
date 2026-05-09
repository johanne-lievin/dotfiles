# =============================================================================
# docker/aliases.zsh — Docker helpers
# =============================================================================

# Exec into a running container (fuzzy select with fzf)
dexec() {
  local cname
  cname=$(docker ps --format '{{.Names}}' | fzf --prompt="Select container: ")
  [ -n "$cname" ] && docker exec -it "$cname" "${1:-/bin/sh}"
}

# Kill and remove all stopped containers
dcleanup() {
  docker rm $(docker ps -aq -f status=exited) 2>/dev/null
  docker rmi $(docker images -q -f dangling=true) 2>/dev/null
  echo "Cleaned up stopped containers and dangling images."
}

# Show container resource usage
dstats() {
  docker stats --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.NetIO}}\t{{.BlockIO}}"
}

# Get a container's IP
dip() {
  docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' "$1"
}

# Tail logs from a container (fuzzy select)
dlogs() {
  local cname="${1:-$(docker ps --format '{{.Names}}' | fzf --prompt='Select container: ')}"
  [ -n "$cname" ] && docker logs -f --tail=100 "$cname"
}

# Quick postgres shell into a running postgres container
dbshell() {
  local cname="${1:-$(docker ps --format '{{.Names}}' | grep -i postgres | head -1)}"
  docker exec -it "$cname" psql -U "${2:-postgres}"
}
