# =============================================================================
# go/aliases.zsh — Go helpers
# =============================================================================

# Quickly create a new Go module
gonew() {
  if [ -z "$1" ]; then
    echo "Usage: gonew <module-name>"
    return 1
  fi
  mkdir -p "$1" && cd "$1"
  go mod init "$1"
  cat > main.go << 'EOF'
package main

import "fmt"

func main() {
	fmt.Println("Hello, World!")
}
EOF
  echo "Go module $1 ready."
}

# Run tests with coverage report
gocover() {
  go test ./... -coverprofile=coverage.out
  go tool cover -html=coverage.out -o coverage.html
  open coverage.html
}
