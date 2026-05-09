---
description: Generate or improve a Makefile for the current project
---

# Makefile Generator

Look at the current project structure to determine the stack (check for `package.json`, `go.mod`, `Cargo.toml`, `Dockerfile`, etc.).

Generate a `Makefile` with:

```makefile
.PHONY: <all targets>

# Declare the default target first
.DEFAULT_GOAL := help

help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'
```

Include targets relevant to the stack:
- **All projects**: `help`, `clean`, `lint`, `test`, `build`
- **Node/JS**: `dev`, `install`, `format`
- **Go**: `run`, `tidy`, `vet`, `cover`
- **Rust**: `check`, `clippy`, `fmt`
- **Docker**: `up`, `down`, `logs`, `shell`
- **With DB**: `db-migrate`, `db-rollback`, `db-seed`

Each target must have a `## description` comment for the help output.
Prefer `:=` over `=` for variable assignment.
Use `$(shell ...)` for dynamic values.
