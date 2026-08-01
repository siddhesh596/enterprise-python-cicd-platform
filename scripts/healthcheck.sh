#!/usr/bin/env bash
set -euo pipefail
LOG_FILE="/var/log/enterprise-python-cicd-platform/healthcheck.log"
mkdir -p "$(dirname "$LOG_FILE")"
log() {
  echo "[$(date -u +'%Y-%m-%dT%H:%M:%SZ')] $*" | tee -a "$LOG_FILE"
}
log "Checking application health"
if curl -fsS http://localhost:8000/health >/dev/null; then
  log "Application is healthy"
else
  log "Application health check failed"
  exit 1
fi
