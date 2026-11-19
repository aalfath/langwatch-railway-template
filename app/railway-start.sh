#!/bin/bash
# Railway wrapper for the LangWatch app (api). Fixed settings live here, so the
# template only carries references, generated secrets and the admin email.
set -eo pipefail
export NODE_ENV="${NODE_ENV:-production}"
export INSTALL_METHOD="${INSTALL_METHOD:-docker}"
# The api listens on API_PORT, else PORT (Railway sets PORT=5560 in the template).
export API_PORT="${API_PORT:-${PORT:-5560}}"
# Plain ClickHouse with no backup disk: system.backup_log doesn't exist.
export CLICKHOUSE_BACKUP_METRICS_ENABLED="${CLICKHOUSE_BACKUP_METRICS_ENABLED:-false}"
# Only invited addresses and ADMIN_EMAILS may sign up (upstream default is open).
export SIGN_UP_MODE="${SIGN_UP_MODE:-invite_only}"
# Railway's edge and private network: read the caller from X-Forwarded-For only from them.
export TRUSTED_PROXY_ADDRESSES="${TRUSTED_PROXY_ADDRESSES:-10.0.0.0/8,100.64.0.0/10,172.16.0.0/12,192.168.0.0/16,127.0.0.0/8,::1/128,fc00::/7}"
# Browsers and SDKs upload files through LangWatch, so the bucket stays private.
export STORED_OBJECTS_UPLOADS="${STORED_OBJECTS_UPLOADS:-through-langwatch}"
cd /app/apps/api
exec pnpm --silent run start
