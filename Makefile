.PHONY: build test lint run clean dev-up dev-down

# Variables
APP_NAME := hlsa
VERSION := $(shell git describe --tags --always --dirty 2>/dev/null || echo "dev")
BUILD_TIME := $(shell date -u '+%Y-%m-%d_%H:%M:%S')
LDFLAGS := -ldflags "-X main.Version=$(VERSION) -X main.BuildTime=$(BUILD_TIME)"

# Build
build:
	go build $(LDFLAGS) -o bin/$(APP_NAME) ./cmd/hlsa

# Test
test:
	go test -v -race -coverprofile=coverage.out ./...

# Coverage report
coverage: test
	go tool cover -html=coverage.out

# Lint
lint:
	golangci-lint run

# Run locally
run:
	go run ./cmd/hlsa

# Clean build artifacts
clean:
	rm -rf bin/
	rm -f coverage.out

# Install development tools
tools:
	go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest

# Docker development environment
dev-up:
	docker compose -f dev/docker-compose.yaml up -d

dev-down:
	docker compose -f dev/docker-compose.yaml down

# Docker build
docker-build:
	docker build -t $(APP_NAME):$(VERSION) .

docker-run:
	docker run -p 8080:8080 $(APP_NAME):$(VERSION)
