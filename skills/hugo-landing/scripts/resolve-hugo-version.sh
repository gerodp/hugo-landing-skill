#!/usr/bin/env bash
# Prints a Hugo version to pin (X.Y.Z, no leading v).
# Order: locally installed hugo -> latest GitHub release -> fallback.
set -euo pipefail

FALLBACK="0.150.1"

if [[ "${1:-}" == "--help" || "${1:-}" == "-h" ]]; then
  echo "Usage: resolve-hugo-version.sh"
  echo "Prints the Hugo version to pin: local 'hugo version' if installed,"
  echo "otherwise the latest release tag from the GitHub API, otherwise ${FALLBACK}."
  exit 0
fi

if command -v hugo >/dev/null 2>&1; then
  version=$(hugo version | sed -En 's/.*v([0-9]+\.[0-9]+\.[0-9]+).*/\1/p' | head -n1)
  if [[ -n "$version" ]]; then
    echo "$version"
    exit 0
  fi
fi

if command -v curl >/dev/null 2>&1; then
  version=$(curl -fsSL --max-time 10 https://api.github.com/repos/gohugoio/hugo/releases/latest 2>/dev/null \
    | sed -En 's/.*"tag_name": *"v([0-9]+\.[0-9]+\.[0-9]+)".*/\1/p' | head -n1)
  if [[ -n "$version" ]]; then
    echo "$version"
    exit 0
  fi
fi

echo "warning: could not resolve Hugo version, falling back to ${FALLBACK}" >&2
echo "$FALLBACK"
