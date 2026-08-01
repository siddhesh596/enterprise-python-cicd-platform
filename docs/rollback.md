# Rollback Guide

## Triggering a rollback

Use the rollback script when a deployment fails or health checks fail:

```bash
bash scripts/rollback.sh
```

## Jenkins rollback

The Jenkins pipeline calls the rollback script automatically on failure.

## Manual rollback steps

1. Stop the current containers
2. Restore the previous release
3. Run health checks
4. Verify the application endpoints
