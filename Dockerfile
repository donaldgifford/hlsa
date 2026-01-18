# Build stage
FROM golang:1.25-alpine AS builder

WORKDIR /app

# Install git for version info
RUN apk add --no-cache git

# Copy go mod files
COPY go.mod go.sum ./
RUN go mod download

# Copy source code
COPY . .

# Build with version info
ARG VERSION=dev
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo \
    -ldflags "-X main.Version=${VERSION}" \
    -o hlsa ./cmd/hlsa

# Runtime stage
FROM alpine:latest

RUN apk --no-cache add ca-certificates tzdata

WORKDIR /app

# Copy binary from builder
COPY --from=builder /app/hlsa .

# Copy config if needed
COPY --from=builder /app/dev/config.dev.yaml ./config.yaml

EXPOSE 8080

ENTRYPOINT ["./hlsa"]
