# Homelab Status API

HLSA (Homelab Status API) is a Go service that collects metrics from Prometheus,
stores status snapshots in S3-compatible storage (Garage for local dev,
Cloudflare R2 for production), and serves them via a REST API. The goal is to
provide a lightweight status page backend for homelab infrastructure.
