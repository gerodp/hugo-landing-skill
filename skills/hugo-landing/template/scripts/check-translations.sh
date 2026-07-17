#!/usr/bin/env bash
# Translation parity check: every page and i18n file must exist AND be
# translated (not a byte-identical copy) in every language. Run from the
# site root. Used by the pre-commit hook, CI, and the hugo-landing skill's
# verify.sh. Exits non-zero listing every violation.
set -euo pipefail

if [[ ! -f config/_default/hugo.toml ]]; then
  echo "error: run from the site root (config/_default/hugo.toml not found)" >&2
  exit 1
fi

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
if [[ "$LANG_COUNT" -gt 1 ]]; then echo "translations ok ($LANG_COUNT languages in sync)"; else echo "translations ok (single language)"; fi
