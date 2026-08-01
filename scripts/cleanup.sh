#!/usr/bin/env bash
set -euo pipefail
LOG_FILE="/var/log/enterprise-python-cicd-platform/cleanup.log"
mkdir -p "$(dirname "$LOG_FILE")"
log() {
  echo "[$(date -u +'%Y-%m-%dT%H:%M:%SZ')] $*" | tee -a "$LOG_FILE"
}
log "Cleaning up temporary files"
rm -f /tmp/enterprise-python-cicd-platform-backup.tgz
log "Cleanup complete"
