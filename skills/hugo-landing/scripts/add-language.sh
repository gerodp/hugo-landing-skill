#!/usr/bin/env bash
# Adds the structural parts of a new language to a scaffolded site:
# content dir stubs, i18n file stub, and a [languages.<code>] config block.
# Translating the stub values is the caller's (Claude's) job afterwards.
set -euo pipefail

usage() {
  cat <<'EOF'
Usage: add-language.sh --dir <site-dir> --code <lang-code> --name <Native Language Name> [--weight N] [--from <lang-code>]

Example: add-language.sh --dir ./mysite --code es --name Español --weight 2

Creates content/<code>/ (copies of --from content, default en, to be translated),
i18n/<code>.toml (copy of the --from strings), and appends a [languages.<code>]
menu/config block to config/_default/hugo.toml. Idempotent: exits if the
language already exists.
EOF
}

DIR="" CODE="" NAME="" WEIGHT="" FROM="en"
while [[ $# -gt 0 ]]; do
  case "$1" in
    --dir) DIR="$2"; shift 2 ;;
    --code) CODE="$2"; shift 2 ;;
    --name) NAME="$2"; shift 2 ;;
    --weight) WEIGHT="$2"; shift 2 ;;
    --from) FROM="$2"; shift 2 ;;
    -h|--help) usage; exit 0 ;;
    *) echo "error: unknown argument: $1" >&2; usage; exit 1 ;;
  esac
done

[[ -n "$DIR" && -n "$CODE" && -n "$NAME" ]] || { usage; exit 1; }
CONFIG="$DIR/config/_default/hugo.toml"
[[ -f "$CONFIG" ]] || { echo "error: not a scaffolded site (missing $CONFIG)" >&2; exit 1; }
[[ -d "$DIR/content/$FROM" ]] || { echo "error: source language content not found: content/$FROM" >&2; exit 1; }

if grep -q "^\s*\[languages\.$CODE\]" "$CONFIG"; then
  echo "language '$CODE' already configured, nothing to do"
  exit 0
fi

if [[ -z "$WEIGHT" ]]; then
  WEIGHT=$(( $(grep -c '^\s*\[languages\.[a-zA-Z-]*\]$' "$CONFIG") + 1 ))
fi

echo "==> Creating content/$CODE (copied from content/$FROM — translate these files)"
mkdir -p "$DIR/content/$CODE"
(cd "$DIR/content/$FROM" && tar cf - .) | (cd "$DIR/content/$CODE" && tar xf -)

echo "==> Creating i18n/$CODE.toml (copy of $FROM strings — translate the values)"
cp "$DIR/i18n/$FROM.toml" "$DIR/i18n/$CODE.toml"

echo "==> Appending [languages.$CODE] block to config (translate the menu names)"
cat >> "$CONFIG" <<EOF

# --- added by add-language.sh: translate menu names below ---
[languages.$CODE]
  languageName = '$NAME'
  contentDir = 'content/$CODE'
  weight = $WEIGHT
  [languages.$CODE.menus]
    [[languages.$CODE.menus.main]]
      name = 'Home'
      pageRef = '/'
      weight = 10
    [[languages.$CODE.menus.main]]
      name = 'How I work'
      url = '/#method'
      weight = 20
    [[languages.$CODE.menus.main]]
      name = 'Results'
      url = '/#results'
      weight = 30
    [[languages.$CODE.menus.main]]
      name = 'About'
      url = '/#about'
      weight = 40
    [[languages.$CODE.menus.main]]
      name = 'Blog'
      url = '/#blog'
      weight = 50
    [[languages.$CODE.menus.main]]
      name = 'Contact'
      url = '/#contact'
      weight = 60
EOF

echo "done: language '$CODE' added. Now translate content/$CODE/, i18n/$CODE.toml and the menu names in $CONFIG."
