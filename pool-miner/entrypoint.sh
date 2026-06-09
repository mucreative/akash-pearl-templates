#!/usr/bin/env bash
set -euo pipefail

PEARL_POOL_URL="${PEARL_POOL_URL:-}"
PEARL_POOL_HOST="${PEARL_POOL_HOST:-sg1.alphapool.tech}"
PEARL_POOL_PORT="${PEARL_POOL_PORT:-5566}"
PEARL_WORKER="${PEARL_WORKER:-akash-$(hostname)}"
HEALTH_PORT="${HEALTH_PORT:-8080}"

if [ -z "${PEARL_ADDRESS:-}" ]; then
  echo "Missing required env: PEARL_ADDRESS" >&2
  exit 1
fi

if [ -z "${PEARL_POOL_URL}" ]; then
  PEARL_POOL_URL="${PEARL_POOL_HOST}:${PEARL_POOL_PORT}"
fi

log() {
  printf '%s %s\n' "$(date -u '+%Y-%m-%dT%H:%M:%SZ')" "$*"
}

log "Pearl pool miner starting"
log "Pool: ${PEARL_POOL_URL}"
log "Worker: ${PEARL_WORKER}"

start_health_server() {
  while true; do
    {
      printf 'HTTP/1.1 200 OK\r\n'
      printf 'Content-Type: text/plain\r\n'
      printf 'Content-Length: 3\r\n'
      printf '\r\n'
      printf 'ok\n'
    } | nc -l -p "${HEALTH_PORT}" -q 1 >/dev/null 2>&1 || true
  done
}

start_health_server &
log "Health endpoint listening on port ${HEALTH_PORT}"

if command -v nvidia-smi >/dev/null 2>&1; then
  log "Detected GPU:"
  nvidia-smi --query-gpu=name,compute_cap,memory.total --format=csv,noheader,nounits || true
fi

cmd=(
  /usr/local/bin/alpha-miner
  --pool "${PEARL_POOL_URL}"
  --address "${PEARL_ADDRESS}"
  --worker "${PEARL_WORKER}"
)

if [ -n "${PEARL_EXTRA_ARGS:-}" ]; then
  read -r -a extra_args <<< "${PEARL_EXTRA_ARGS}"
  cmd+=("${extra_args[@]}")
fi

log "Starting alpha-miner"
exec "${cmd[@]}"
