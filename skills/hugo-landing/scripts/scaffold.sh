#!/usr/bin/env bash
# Scaffolds a new Hugo landing+blog site from the embedded template.
# Deterministic steps only: copy, token substitution, deploy-target selection, git init.
set -euo pipefail

usage() {
  cat <<'EOF'
Usage: scaffold.sh --dir <target-dir> --name <site-name> --url <https://example.com/> \
                   --deploy <github-pages|netlify|cloudflare|amplify> \
                   [--hugo-version X.Y.Z] [--package-name <npm-name>] [--no-blog]

Copies the template into <target-dir>, substitutes __SITE_NAME__/__SITE_URL__/
__PACKAGE_NAME__/__HUGO_VERSION__ tokens, installs the chosen deploy target's
config, and runs git init. Refuses to write into a non-empty directory.

--no-blog: ship no blog at all — removes the blog content, archetype, blog
layouts and tag pages, the Blog menu entry, the homepage blog params, and the
blog make targets.
EOF
}

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
TEMPLATE_DIR="$SCRIPT_DIR/../template"

TARGET="" NAME="" URL="" DEPLOY="" HUGO_VERSION="" PACKAGE_NAME="" NO_BLOG=0
while [[ $# -gt 0 ]]; do
  case "$1" in
    --dir) TARGET="$2"; shift 2 ;;
    --name) NAME="$2"; shift 2 ;;
    --url) URL="$2"; shift 2 ;;
    --deploy) DEPLOY="$2"; shift 2 ;;
    --hugo-version) HUGO_VERSION="$2"; shift 2 ;;
    --package-name) PACKAGE_NAME="$2"; shift 2 ;;
    --no-blog) NO_BLOG=1; shift ;;
    -h|--help) usage; exit 0 ;;
    *) echo "error: unknown argument: $1" >&2; usage; exit 1 ;;
  esac
done

[[ -n "$TARGET" && -n "$NAME" && -n "$URL" && -n "$DEPLOY" ]] || { usage; exit 1; }
[[ -d "$TEMPLATE_DIR" ]] || { echo "error: template dir not found: $TEMPLATE_DIR" >&2; exit 1; }

case "$DEPLOY" in
  github-pages|netlify|cloudflare|amplify) ;;
  *) echo "error: --deploy must be one of: github-pages, netlify, cloudflare, amplify" >&2; exit 1 ;;
esac

case "$URL" in
  http://*|https://*) ;;
  *) echo "error: --url must start with http:// or https://" >&2; exit 1 ;;
esac
# Hugo baseURL convention: trailing slash
[[ "$URL" == */ ]] || URL="${URL}/"

if [[ -z "$HUGO_VERSION" ]]; then
  HUGO_VERSION=$("$SCRIPT_DIR/resolve-hugo-version.sh")
fi

if [[ -z "$PACKAGE_NAME" ]]; then
  PACKAGE_NAME=$(echo "$NAME" | tr '[:upper:]' '[:lower:]' | sed -E 's/[^a-z0-9]+/-/g; s/^-+|-+$//g')
fi

if [[ -e "$TARGET" ]] && [[ -n "$(ls -A "$TARGET" 2>/dev/null)" ]]; then
  echo "error: target directory is not empty: $TARGET" >&2
  exit 1
fi
mkdir -p "$TARGET"

echo "==> Copying template to $TARGET"
(cd "$TEMPLATE_DIR" && tar cf - .) | (cd "$TARGET" && tar xf -)

echo "==> Installing deploy target: $DEPLOY"
(cd "$TARGET/deploy/$DEPLOY" && tar cf - .) | (cd "$TARGET" && tar xf -)
rm -rf "$TARGET/deploy"

if [[ "$NO_BLOG" == "1" ]]; then
  echo "==> Removing blog (--no-blog)"
  rm -rf "$TARGET/content/en/blog" \
         "$TARGET/archetypes/blog.md" \
         "$TARGET/themes/landing/layouts/blog" \
         "$TARGET/themes/landing/layouts/taxonomy.html" \
         "$TARGET/themes/landing/layouts/term.html"
  # No tag pages without a blog
  perl -pi -e "s/^theme = 'landing'\$/theme = 'landing'\ndisableKinds = ['taxonomy', 'term']/" \
    "$TARGET/config/_default/hugo.toml"
  # Drop the Blog menu entry
  perl -0pi -e "s/[ \t]*\[\[languages\.en\.menus\.main\]\]\n[ \t]*name = 'Blog'\n[ \t]*url = '\/#blog'\n[ \t]*weight = \d+\n//" \
    "$TARGET/config/_default/hugo.toml"
  # Drop the homepage blog section params
  perl -0pi -e "s/# === BLOG ===.*?(?=# === )//s" "$TARGET/content/en/_index.md"
  # Drop the blog make targets and their help lines
  perl -0pi -e "s/new-post:\n\thugo new content [^\n]*\n\n//; s/publish:\n\tfind content [^\n]*\n\n//; s/[ \t]*\@echo \"  make (new-post|publish)[^\n]*\n//g; s/new-post publish //" \
    "$TARGET/Makefile"
fi

echo "==> Substituting tokens (hugo: $HUGO_VERSION, package: $PACKAGE_NAME)"
export SUB_NAME="$NAME" SUB_URL="$URL" SUB_PKG="$PACKAGE_NAME" SUB_HUGO="$HUGO_VERSION"
grep -rl -e '__SITE_NAME__' -e '__SITE_URL__' -e '__PACKAGE_NAME__' -e '__HUGO_VERSION__' "$TARGET" \
  --exclude-dir=node_modules --exclude-dir=.git 2>/dev/null | while IFS= read -r file; do
  perl -pi -e '
    s/__SITE_NAME__/$ENV{SUB_NAME}/g;
    s/__SITE_URL__/$ENV{SUB_URL}/g;
    s/__PACKAGE_NAME__/$ENV{SUB_PKG}/g;
    s/__HUGO_VERSION__/$ENV{SUB_HUGO}/g;
  ' "$file"
done

if [[ ! -d "$TARGET/.git" ]]; then
  echo "==> Initializing git repository"
  git -C "$TARGET" init -q
fi
# Activate the tracked pre-commit hook (lint + build before every commit)
git -C "$TARGET" config core.hooksPath .githooks
chmod +x "$TARGET/.githooks/pre-commit"

cat <<EOF

Scaffold complete: $TARGET
  Site name:    $NAME
  Base URL:     $URL
  Deploy:       $DEPLOY
  Hugo version: $HUGO_VERSION (pinned in CI config)

Next (handled by the hugo-landing skill):
  1. Customize content/en/_index.md and config/_default/hugo.toml params
  2. Add extra languages with add-language.sh
  3. Run verify.sh to install deps and build
EOF
