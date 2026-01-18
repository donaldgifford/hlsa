# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

HLSA (Homelab Status API) is a Go service that collects metrics from Prometheus, stores status snapshots in S3-compatible storage (Garage for local dev, Cloudflare R2 for production), and serves them via a REST API. The goal is to provide a lightweight status page backend for homelab infrastructure.

## Build and Run Commands

```bash
# Run the server
go run ./cmd/hlsa

# Build binary
go build -o hlsa ./cmd/hlsa

# Run tests
go test ./...

# Run a single test
go test -v -run TestName ./path/to/package

# Start local development infrastructure (Garage S3 + Prometheus)
docker compose -f dev/docker-compose.yaml up -d

# Stop local infrastructure
docker compose -f dev/docker-compose.yaml down
```

## Architecture

```
cmd/hlsa/main.go     - Entry point, Echo HTTP server setup, graceful shutdown
config/              - Configuration loading (from dev/config.dev.yaml)
internal/
  api/               - HTTP route handlers
  collector/         - Prometheus metric collection logic
  model/             - Data structures for status snapshots
  scheduler/         - Periodic collection scheduling
  storage/           - S3-compatible storage interface (Garage/R2)
dev/                 - Local development config files
```

## Key Dependencies

- **Echo v4** - HTTP framework (`github.com/labstack/echo/v4`)
- **zerolog** - Structured logging (`github.com/rs/zerolog`)

## Development Environment

Uses [mise](https://mise.jdx.dev/) for tool version management. Run `mise install` to set up Go 1.25.4 and other tools.

Local services available via docker-compose:
- **Garage** (S3-compatible): ports 3900 (S3 API), 3901 (Admin), 3902 (Web)
- **Prometheus**: port 9090
