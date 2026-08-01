#!/usr/bin/env bash
set -euo pipefail

LOG_FILE="/var/log/enterprise-python-cicd-platform/rollback.log"
mkdir -p "$(dirname "$LOG_FILE")"

log() {
  echo "[$(date -u +'%Y-%m-%dT%H:%M:%SZ')] $*" | tee -a "$LOG_FILE"
}

log "Starting rollback"
docker compose -f docker/docker-compose.yml down || true
log "Rollback complete"
