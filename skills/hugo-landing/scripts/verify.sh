#!/usr/bin/env bash
# Verifies a scaffolded site: leftover tokens, npm install, production build,
# and an optional dev-server smoke test.
set -euo pipefail

usage() {
  cat <<'EOF'
Usage: verify.sh --dir <site-dir> [--smoke]

Checks for leftover __TOKENS__, verifies translation parity across languages
(every page and i18n file must exist AND be translated in every language),
installs Node dependencies, runs a production Hugo build, and with --smoke
starts a dev server and curls the homepage. Exits non-zero on any failure.
Hugo build warnings are printed for follow-up.
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

echo "==> Checking translation parity across languages"
DEFAULT_LANG=$(sed -n "s/^defaultContentLanguage *= *['\"]\([^'\"]*\)['\"].*/\1/p" config/_default/hugo.toml | head -1)
DEFAULT_LANG=${DEFAULT_LANG:-en}
PARITY_FAIL=0
LANG_COUNT=0
for LANG_DIR in content/*/; do
  [[ -d "$LANG_DIR" ]] || continue
  LANG=$(basename "$LANG_DIR")
  LANG_COUNT=$((LANG_COUNT + 1))
  [[ "$LANG" == "$DEFAULT_LANG" ]] && continue

  # Every default-language page must exist in this language, translated
  # (not a byte-identical copy left by add-language.sh).
  while IFS= read -r REL; do
    if [[ ! -f "content/$LANG/$REL" ]]; then
      echo "error: content/$LANG/$REL is missing — page not translated to '$LANG'" >&2
      PARITY_FAIL=1
    elif cmp -s "content/$DEFAULT_LANG/$REL" "content/$LANG/$REL"; then
      echo "error: content/$LANG/$REL is identical to content/$DEFAULT_LANG/$REL — still untranslated" >&2
      PARITY_FAIL=1
    fi
  done < <(cd "content/$DEFAULT_LANG" && find . -name '*.md' | sed 's|^\./||')

  # No page may exist in this language without a counterpart in the default
  # language (all content must exist in all languages).
  while IFS= read -r REL; do
    if [[ ! -f "content/$DEFAULT_LANG/$REL" ]]; then
      echo "error: content/$LANG/$REL has no counterpart in content/$DEFAULT_LANG — translate it to every language" >&2
      PARITY_FAIL=1
    fi
  done < <(cd "content/$LANG" && find . -name '*.md' | sed 's|^\./||')

  # UI strings: i18n/<lang>.toml must exist and not be an untranslated stub.
  if [[ ! -f "i18n/$LANG.toml" ]]; then
    echo "error: i18n/$LANG.toml is missing" >&2
    PARITY_FAIL=1
  elif cmp -s "i18n/$DEFAULT_LANG.toml" "i18n/$LANG.toml"; then
    echo "error: i18n/$LANG.toml is identical to i18n/$DEFAULT_LANG.toml — translate the UI strings" >&2
    PARITY_FAIL=1
  fi
done
if [[ "$PARITY_FAIL" == "1" ]]; then
  echo "error: translation parity check failed — every page must be translated into every language" >&2
  exit 1
fi
if [[ "$LANG_COUNT" -gt 1 ]]; then echo "    ok ($LANG_COUNT languages in sync)"; else echo "    ok (single language)"; fi

echo "==> Installing Node dependencies"
if [[ -f package-lock.json ]]; then npm ci --no-audit --no-fund; else npm install --no-audit --no-fund; fi

echo "==> Linting (npm run lint — same as CI)"
npm run lint

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
  # GitHub Pages project sites serve under a subpath — curl the baseURL path,
  # not always /
  BASE_PATH=$(sed -n "s/^baseURL *= *['\"]https\{0,1\}:\/\/[^/'\"]*\(\/[^'\"]*\)['\"].*/\1/p" config/_default/hugo.toml | head -1)
  BASE_PATH=${BASE_PATH:-/}
  [[ "$BASE_PATH" == */ ]] || BASE_PATH="${BASE_PATH}/"
  hugo server --port "$PORT" --renderToMemory >/dev/null 2>&1 &
  SERVER_PID=$!
  trap 'kill "$SERVER_PID" 2>/dev/null || true' EXIT
  for _ in $(seq 1 20); do
    sleep 0.5
    if curl -sf "http://localhost:$PORT$BASE_PATH" >/dev/null; then break; fi
  done
  curl -sf "http://localhost:$PORT$BASE_PATH" | grep -qi '<html' || { echo "error: homepage did not render at $BASE_PATH" >&2; exit 1; }
  kill "$SERVER_PID" 2>/dev/null || true
  trap - EXIT
  echo "    homepage responds"
fi

echo "==> Verification passed"
