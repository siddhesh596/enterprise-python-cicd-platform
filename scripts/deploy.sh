#!/usr/bin/env bash
set -euo pipefail

LOG_FILE="/var/log/enterprise-python-cicd-platform/deploy.log"
mkdir -p "$(dirname "$LOG_FILE")"

log() {
  echo "[$(date -u +'%Y-%m-%dT%H:%M:%SZ')] $*" | tee -a "$LOG_FILE"
}

log "Starting deployment"
if ! command -v docker >/dev/null 2>&1; then
  log "Docker is not installed"
  exit 1
fi

log "Building and deploying application"
docker compose -f docker/docker-compose.yml up -d --build
log "Deployment complete"
