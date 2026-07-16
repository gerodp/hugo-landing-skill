#!/usr/bin/env bash
# Verifies a scaffolded site: leftover tokens, npm install, production build,
# and an optional dev-server smoke test.
set -euo pipefail

usage() {
  cat <<'EOF'
Usage: verify.sh --dir <site-dir> [--smoke]

Checks for leftover __TOKENS__, installs Node dependencies, runs a production
Hugo build, and with --smoke starts a dev server and curls the homepage.
Exits non-zero on any failure. Hugo build warnings are printed for follow-up.
EOF
}

DIR="" SMOKE=0
while [[ $# -gt 0 ]]; do
  case "$1" in
    --dir) DIR="$2"; shift 2 ;;
    --smoke) SMOKE=1; shift ;;
    -h|--help) usage; exit 0 ;;
    *) echo "error: unknown argument: $1" >&2; usage; exit 1 ;;
  esac
done
[[ -n "$DIR" ]] || { usage; exit 1; }
cd "$DIR"

echo "==> Checking for leftover template tokens"
if grep -rn -e '__SITE_NAME__' -e '__SITE_URL__' -e '__PACKAGE_NAME__' -e '__HUGO_VERSION__' . \
    --exclude-dir=node_modules --exclude-dir=.git --exclude-dir=public 2>/dev/null; then
  echo "error: unsubstituted tokens found (see above)" >&2
  exit 1
fi
echo "    ok"

echo "==> Installing Node dependencies"
if [[ -f package-lock.json ]]; then npm ci --no-audit --no-fund; else npm install --no-audit --no-fund; fi

echo "==> Production build (hugo --gc --minify)"
BUILD_LOG=$(mktemp)
if ! hugo --gc --minify 2>&1 | tee "$BUILD_LOG"; then
  echo "error: hugo build failed" >&2
  exit 1
fi
if grep -iE '^(WARN|WARNING)' "$BUILD_LOG" >/dev/null; then
  echo "note: build produced warnings (listed above) — fix deprecations before shipping" >&2
fi

if [[ "$SMOKE" == "1" ]]; then
  echo "==> Smoke test: hugo server"
  PORT=1414
  hugo server --port "$PORT" --renderToMemory >/dev/null 2>&1 &
  SERVER_PID=$!
  trap 'kill "$SERVER_PID" 2>/dev/null || true' EXIT
  for _ in $(seq 1 20); do
    sleep 0.5
    if curl -sf "http://localhost:$PORT/" >/dev/null; then break; fi
  done
  curl -sf "http://localhost:$PORT/" | grep -qi '<html' || { echo "error: homepage did not render" >&2; exit 1; }
  kill "$SERVER_PID" 2>/dev/null || true
  trap - EXIT
  echo "    homepage responds"
fi

echo "==> Verification passed"
