#!/bin/sh
set -e

/gatus &
GATUS_PID=$!

trap "kill $GATUS_PID 2>/dev/null" TERM INT

exec caddy run --config /etc/caddy/Caddyfile --adapter caddyfile
