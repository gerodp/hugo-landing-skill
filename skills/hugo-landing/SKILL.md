---
name: hugo-landing
description: Scaffold a production-ready Hugo landing page + blog site with Tailwind CSS, full SEO (OpenGraph, Twitter cards, JSON-LD, hreflang), configurable multilingual support, analytics, and CI/CD for GitHub Pages, Cloudflare Pages, Netlify or AWS Amplify. Use when the user wants to create a new landing page, marketing site, personal-brand site, or consultant/product site with Hugo.
argument-hint: [site-name]
---

# Hugo Landing Page + Blog Scaffolder

Creates a complete, buildable Hugo site from the embedded `template/`. The
result is a single-page landing site (hero, pain points, method, case studies,
about, blog preview, CTA — every section optional) plus a blog with pagination,
tags, RSS, and rich structured data.

**Division of labor:** the shell scripts in `scripts/` handle everything
mechanical (copying, token substitution, deploy config, structure). You handle
everything requiring judgment: the interview, copywriting, translations,
branding, and fixing build warnings. Never re-implement what a script does.

## Prerequisites

`hugo` (>= 0.146), `node`/`npm`, and `git` on PATH. If Hugo is missing, tell
the user to install it first (`brew install hugo` / see gohugo.io).

## Procedure

### 1. Interview the user

Ask (AskUserQuestion works well; skip anything already stated):

1. **Site name + base URL** (e.g. "Acme Consulting", `https://acme.example`).
   If they don't have a domain yet and chose GitHub Pages, use
   `https://<user>.github.io/<repo>/`.
2. **Site type**: personal brand / consultant (adds a `Person` entity to
   JSON-LD) vs product/company (Organization only).
3. **Languages**: default language + any extra languages. Any language is
   supported — see `reference/multilingual.md`.
4. **Brand color + font**: any Tailwind palette name or a custom color;
   Google Font family (default Inter).
5. **Homepage sections**: which of pain-points, method/steps, case studies,
   about, blog preview, open-source, final CTA to include. Hero is always on.
6. **Deploy target**: github-pages (default) / cloudflare / netlify / amplify.
7. **Analytics**: umami / plausible / ga4 / none, plus website ID and
   (self-hosted) script host.
8. **Contact CTA**: scheduling link (Cal.com/Calendly) or email.

### 2. Scaffold (deterministic)

```sh
scripts/scaffold.sh --dir <target> --name "<Site Name>" \
  --url <base-url> --deploy <target>
```

This copies the template, substitutes `__SITE_NAME__` / `__SITE_URL__` /
`__PACKAGE_NAME__` / `__HUGO_VERSION__` (Hugo version auto-resolved from the
local install or the latest GitHub release), installs the deploy target's
config, and runs `git init`. It refuses non-empty target directories.

### 3. Write the content (judgment)

Edit `content/en/_index.md` (or the default language's) — the homepage is
entirely front-matter driven. Replace ALL example copy with copy tailored to
the user's business; ask for source material (existing site, LinkedIn, pitch)
rather than inventing facts. Remove the sections the user didn't ask for —
an absent param removes its section. See `reference/content-model.md` for
every param.

Also update in `config/_default/hugo.toml`:

- `params.description`, `params.author`, `params.contactEmail`,
  `params.bookCallUrl`, `params.social.*`
- `params.jsonld.*` for personal-brand sites (personName, jobTitle, knowsAbout)
- `params.analytics.*` per the interview
- `params.footer.*` (services list, links, copyright)
- The menu entries, matching the sections that exist

Replace the example blog post and legal page with real or clearly-placeholder
content per the user's preference. Keep the TOML rule from the template:
**scalar params above `[[array]]` tables** in `_index.md`.

### 4. Extra languages (script + judgment)

For each extra language:

```sh
scripts/add-language.sh --dir <target> --code <xx> --name "<Native Name>"
```

Then translate what the script stubbed: `content/<xx>/` files,
`i18n/<xx>.toml` values, and the menu names in the appended config block.
Translate the ~9 i18n keys yourself — `reference/multilingual.md` has
ready-made TOML for common languages. hreflang + x-default are emitted
automatically once a page has translations.

### 5. Branding

- **Color**: in `tailwind.config.js`, set `primary` to a Tailwind palette
  (`colors.emerald`, `colors.rose`, …) or a custom 50–900 scale. The whole
  theme (utilities and CSS in `themes/landing/assets/css/main.css` via
  `theme()` tokens) follows automatically.
- **Font**: set `params.googleFont` in hugo.toml (css2 family spec) AND the
  matching family name in `tailwind.config.js` `fontFamily.sans`.
- **Favicon**: `static/favicon.svg` is a placeholder — update its letter/color
  minimum, or generate a real set (e.g. realfavicongenerator.net) and extend
  the icon links in `themes/landing/layouts/_partials/head.html`.
- Images referenced from content (`aboutPortrait`, `coverImage`,
  `shareImage`, `authorImage`) live under `assets/` in the site root (or the
  theme) — create the dirs as needed.

### 6. Verify (deterministic + judgment)

```sh
scripts/verify.sh --dir <target> --smoke
```

Runs token check, `npm install`, `hugo --gc --minify`, and a dev-server curl.
**Treat any Hugo WARN/deprecation output as actionable: fix it now**, so the
site is clean against the Hugo version it will build with. Then make the
initial commit yourself (verify.sh doesn't commit). After the first commit you
may enable `enableGitInfo = true` in hugo.toml for git-based lastmod dates.

### 7. Hand over

Tell the user:

- How to run it: `make run` (dev server), `make build`, `make new-post`.
- Deploy setup steps for their target — see `reference/deploy.md` (e.g. for
  GitHub Pages: push to GitHub, then Settings → Pages → Source: GitHub Actions).
- Where to customize further (content model doc, params).
- That analytics only loads in production builds, never `hugo server`.

## Gotchas

- `_index.md` TOML: scalars must stay above `[[array]]` tables.
- The blog section's homepage block needs `blogTitle` set; the featured post
  (`featuredPost`) must be a valid page path or it's ignored.
- Homepage anchors in menus must use the `/#section` form (the menu partial
  makes them work under any baseURL subpath). Section ids: `#problems`,
  `#method`, `#results`, `#about`, `#blog`, `#contact`, `#open-source`.
- Custom analytics events: add `data-analytics-event="name"` (click) or
  `data-analytics-view="name"` (visibility) attributes — no JS needed.
- GitHub Pages project sites (non-root URLs) are handled by the workflow's
  `-b` flag; don't hardcode the repo subpath into baseURL params elsewhere.
