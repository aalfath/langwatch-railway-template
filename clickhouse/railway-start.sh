#!/bin/bash
# Railway mounts volumes owned by root, but this image runs ClickHouse as uid 101.
# Hand the volume to uid 101 (once), then drop to it and run the image's own entrypoint.
set -euo pipefail
DATA=/var/lib/clickhouse
if [ "$(id -u)" = "0" ]; then
  mkdir -p "$DATA"
  if [ "$(stat -c %u "$DATA")" != "101" ]; then
    chown -R 101:101 "$DATA"
  fi
  exec setpriv --reuid=101 --regid=101 --clear-groups /usr/bin/tini -- /scripts/entrypoint-wrapper.sh "$@"
fi
exec /usr/bin/tini -- /scripts/entrypoint-wrapper.sh "$@"
