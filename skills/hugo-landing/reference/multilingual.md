# Multilingual setup

Any set of languages is supported. The default (lowest-weight) language is
served at `/`, others under `/<code>/`. hreflang alternates plus `x-default`
(pointing to the default language) are emitted automatically for translated
pages; single-language sites emit none.

## Adding a language

```sh
scripts/add-language.sh --dir <site> --code <xx> --name "<Native Name>" [--weight N] [--from en]
```

The script creates `content/<xx>/` (copies of the source language to
translate), `i18n/<xx>.toml` (stub), and appends a `[languages.<xx>]` config
block. Then YOU translate:

1. **`content/<xx>/`** — every file. Keep `translationKey` in blog posts equal
   across languages so Hugo links them.
2. **`i18n/<xx>.toml`** — the 10 UI strings (below).
3. **Menu names** in the appended `[languages.<xx>.menus]` block, plus
   language-specific params if wanted:

   ```toml
   [languages.xx.params]
     description = '...'
     [languages.xx.params.footer]
       servicesTitle = '...'
       services = ['...']
   ```

## Translation completeness

Every page must exist, translated, in every language. The scaffolded site
ships `scripts/check-translations.sh`, which fails if any language is
missing a `.md` file present in the default language (or has one the
default language lacks), if any file is a byte-identical copy of its
default-language source, or if an `i18n/<xx>.toml` is missing/identical to
the default one. It runs in three places: the skill's `verify.sh`, the
site's pre-commit hook, and the site's CI workflow — untranslated content
never reaches a push. When adding new content later, always create it in
all languages at once.

## i18n keys

`readMore, previous, next, minRead, noPosts, postsAbout, allLabel,
lastUpdated, backToHome, madeWith`

Ready-made translations for common languages (write others yourself — they
are 10 short strings):

```toml
# es.toml
[readMore]
other = 'Leer más'
[previous]
other = 'Anterior'
[next]
other = 'Siguiente'
[minRead]
other = 'min de lectura'
[noPosts]
other = 'Aún no hay artículos.'
[postsAbout]
other = 'Artículos sobre'
[allLabel]
other = 'Todos'
[lastUpdated]
other = 'Última actualización:'
[backToHome]
other = 'Volver al inicio'
[madeWith]
other = 'Hecho con'
```

```toml
# fr.toml
[readMore]
other = 'Lire la suite'
[previous]
other = 'Précédent'
[next]
other = 'Suivant'
[minRead]
other = 'min de lecture'
[noPosts]
other = "Pas encore d'articles."
[postsAbout]
other = 'Articles sur'
[allLabel]
other = 'Tous'
[lastUpdated]
other = 'Dernière mise à jour :'
[backToHome]
other = "Retour à l'accueil"
[madeWith]
other = 'Créé avec'
```

```toml
# de.toml
[readMore]
other = 'Weiterlesen'
[previous]
other = 'Zurück'
[next]
other = 'Weiter'
[minRead]
other = 'Min. Lesezeit'
[noPosts]
other = 'Noch keine Artikel.'
[postsAbout]
other = 'Artikel über'
[allLabel]
other = 'Alle'
[lastUpdated]
other = 'Zuletzt aktualisiert:'
[backToHome]
other = 'Zurück zur Startseite'
[madeWith]
other = 'Erstellt mit'
```

```toml
# it.toml
[readMore]
other = 'Leggi di più'
[previous]
other = 'Precedente'
[next]
other = 'Successivo'
[minRead]
other = 'min di lettura'
[noPosts]
other = 'Ancora nessun articolo.'
[postsAbout]
other = 'Articoli su'
[allLabel]
other = 'Tutti'
[lastUpdated]
other = 'Ultimo aggiornamento:'
[backToHome]
other = 'Torna alla home'
[madeWith]
other = 'Realizzato con'
```

```toml
# pt.toml
[readMore]
other = 'Ler mais'
[previous]
other = 'Anterior'
[next]
other = 'Seguinte'
[minRead]
other = 'min de leitura'
[noPosts]
other = 'Ainda não há artigos.'
[postsAbout]
other = 'Artigos sobre'
[allLabel]
other = 'Todos'
[lastUpdated]
other = 'Última atualização:'
[backToHome]
other = 'Voltar ao início'
[madeWith]
other = 'Feito com'
```

## Advanced: one site, multiple domains

To serve different languages from different domains (e.g. Spanish on
`example.es`, everything else on `example.com`), set:

```toml
[params.languagedomains]
  es = "https://example.es"
  en = "https://example.com"

[params.domaindefaultlangs]
  "https://example.es" = "es"
  "https://example.com" = "en"
```

Canonical URLs, hreflang and the language switcher then use the mapped
domains (see `themes/landing/layouts/_partials/cross-domain-url.html`). You
must build and deploy the site once per domain (e.g. one hosting project per
domain with different `baseURL`) and configure DNS accordingly. Leave these
params unset for the normal single-domain setup.
