#!/bin/bash
# Railway wrapper for the LangWatch workers. They run `pnpm task upgrade` (Postgres
# and ClickHouse migrations) at boot; the app stays not-ready until that is done.
set -eo pipefail
export NODE_ENV="${NODE_ENV:-production}"
export INSTALL_METHOD="${INSTALL_METHOD:-docker}"
# The workers' health door (/healthz, /readyz). Railway's health check uses PORT.
export WORKER_METRICS_PORT="${WORKER_METRICS_PORT:-${PORT:-2999}}"
export CLICKHOUSE_BACKUP_METRICS_ENABLED="${CLICKHOUSE_BACKUP_METRICS_ENABLED:-false}"
export SIGN_UP_MODE="${SIGN_UP_MODE:-invite_only}"
# A fresh Railway deploy may start the workers before ClickHouse answers.
export CLICKHOUSE_MIGRATE_WAIT_SECONDS="${CLICKHOUSE_MIGRATE_WAIT_SECONDS:-600}"
# Browsers and SDKs upload files through LangWatch, so the bucket stays private.
export STORED_OBJECTS_UPLOADS="${STORED_OBJECTS_UPLOADS:-through-langwatch}"
cd /app/apps/worker
exec pnpm --silent run start
