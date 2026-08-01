#!/usr/bin/env bash
set -euo pipefail
LOG_FILE="/var/log/enterprise-python-cicd-platform/restore.log"
mkdir -p "$(dirname "$LOG_FILE")"
log() {
  echo "[$(date -u +'%Y-%m-%dT%H:%M:%SZ')] $*" | tee -a "$LOG_FILE"
}
log "Restoring backup"
if [ -f /tmp/enterprise-python-cicd-platform-backup.tgz ]; then
  tar -xzf /tmp/enterprise-python-cicd-platform-backup.tgz -C .
fi
log "Restore complete"
