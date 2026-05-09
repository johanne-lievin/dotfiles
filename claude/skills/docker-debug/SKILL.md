---
name: docker-debug
description: >
  Use when the user has a Docker or docker-compose problem: container won't
  start, networking issue, volume mount problem, build failure, health check
  failing, or asking "why is my container X".
---

# Docker Debug Skill

## Systematic diagnosis flow

### Container won't start
```bash
docker ps -a                              # Find the container + exit code
docker logs <container> --tail=50         # Last 50 lines of output
docker inspect <container> | jq '.[0].State'  # State + error
```

Exit codes to know:
- `0` = clean exit (misconfigured restart policy?)
- `1` = application error (check logs)
- `125` = Docker daemon error
- `126` = permission denied on entrypoint
- `127` = entrypoint/command not found
- `137` = OOM killed (increase memory limit)
- `139` = segfault
- `143` = SIGTERM not handled (graceful shutdown issue)

### Networking issues
```bash
docker network ls
docker network inspect <network>
# Test DNS resolution from inside container:
docker exec <container> nslookup <service-name>
# Test connectivity:
docker exec <container> curl -v http://<service>:<port>/health
```

### Volume mount problems
```bash
docker inspect <container> | jq '.[0].Mounts'
# Check permissions:
docker exec <container> ls -la /path/to/mount
```

### Build failures
- Always check `.dockerignore` — missing it causes huge contexts and cache misses
- Multi-stage: make sure you're `COPY --from=builder` the right paths
- Layer caching: put `COPY package.json` before `COPY . .` for Node apps

## Common fixes

### Node app: `node_modules` disappearing
```dockerfile
COPY package.json pnpm-lock.yaml ./
RUN pnpm install
COPY . .
# node_modules now in layer before COPY . . — preserved
```

### Go app: small production image
```dockerfile
FROM golang:1.22-alpine AS builder
WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 go build -o /app/server .

FROM scratch
COPY --from=builder /app/server /server
ENTRYPOINT ["/server"]
```

### Health check not passing
```bash
# Test the health check command directly:
docker exec <container> wget -qO- http://localhost:8080/health
# or
docker exec <container> curl -f http://localhost:8080/health
```
