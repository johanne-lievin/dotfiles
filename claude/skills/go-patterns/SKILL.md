---
name: go-patterns
description: >
  Use when writing or reviewing Go code. Triggers on: creating a new Go file,
  reviewing Go code, "how do I X in Go", writing Go HTTP handlers, middleware,
  CLI tools, or anything Go-related.
---

# Go Patterns Skill

## Project layout (standard)
```
myapp/
├── cmd/
│   └── myapp/
│       └── main.go        # Thin main — wire dependencies, call run()
├── internal/
│   ├── handler/           # HTTP handlers
│   ├── service/           # Business logic
│   ├── repository/        # Data access
│   └── model/             # Domain types
├── pkg/                   # Reusable, importable packages
├── Makefile
├── go.mod
└── go.sum
```

## Error handling
```go
// Wrap with context — always
if err != nil {
    return fmt.Errorf("createUser: %w", err)
}

// Sentinel errors for callers to check
var ErrNotFound = errors.New("not found")

// Rich error types when callers need fields
type ValidationError struct {
    Field   string
    Message string
}
func (e *ValidationError) Error() string {
    return fmt.Sprintf("validation: %s %s", e.Field, e.Message)
}
```

## HTTP handler pattern
```go
func (h *Handler) CreateUser(w http.ResponseWriter, r *http.Request) {
    var req CreateUserRequest
    if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
        http.Error(w, "invalid JSON", http.StatusBadRequest)
        return
    }

    user, err := h.service.CreateUser(r.Context(), req)
    if err != nil {
        var ve *ValidationError
        if errors.As(err, &ve) {
            http.Error(w, ve.Error(), http.StatusUnprocessableEntity)
            return
        }
        h.log.Error("createUser", "error", err)
        http.Error(w, "internal error", http.StatusInternalServerError)
        return
    }

    w.Header().Set("Content-Type", "application/json")
    w.WriteHeader(http.StatusCreated)
    json.NewEncoder(w).Encode(user)
}
```

## Table-driven tests
```go
func TestAdd(t *testing.T) {
    tests := []struct {
        name     string
        a, b     int
        expected int
    }{
        {"positive", 1, 2, 3},
        {"negative", -1, -2, -3},
        {"zero", 0, 0, 0},
    }

    for _, tt := range tests {
        t.Run(tt.name, func(t *testing.T) {
            got := Add(tt.a, tt.b)
            if got != tt.expected {
                t.Errorf("Add(%d, %d) = %d, want %d", tt.a, tt.b, got, tt.expected)
            }
        })
    }
}
```

## Key idioms
- Accept interfaces, return structs
- `context.Context` as first param on all I/O functions
- Use `slog` for structured logging (stdlib since Go 1.21)
- `sync.Once` for lazy initialization
- Close channels from the sender, not the receiver
- Prefer `errors.Is` / `errors.As` over string matching
