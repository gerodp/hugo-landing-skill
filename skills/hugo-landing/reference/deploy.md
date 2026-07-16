# Deploy targets

`scaffold.sh --deploy <target>` installs exactly one target's files. All
targets also get `.github/workflows/ci.yml` (lint + build on every PR/push).
The Hugo version is pinned everywhere via the `__HUGO_VERSION__` substitution.

## github-pages (default)

**Files:** `.github/workflows/deploy.yml`

Post-scaffold steps for the user:

1. Push the repo to GitHub.
2. Repo **Settings → Pages → Build and deployment → Source: GitHub Actions**.
3. Push to `main` (or run the workflow manually) — done.
4. Custom domain: Settings → Pages → Custom domain (GitHub writes the CNAME);
   update `baseURL` in `config/_default/hugo.toml` to the custom domain.

Note: for project pages (`user.github.io/repo/`) the workflow passes the
correct base URL via `-b`; no config change needed.

## netlify

**Files:** `netlify.toml`

1. Push to GitHub/GitLab; in Netlify: **Add new site → Import an existing
   project**. Build settings are read from `netlify.toml`.
2. Deploy previews and branch deploys are preconfigured (they build with
   `$DEPLOY_PRIME_URL` as base).
3. Custom domain: Site settings → Domain management; update `baseURL`.

## cloudflare

**Files:** `DEPLOY.md`, `.github/workflows/deploy.yml` (optional wrangler path)

Two options, documented in the scaffolded `DEPLOY.md`:

- **Dashboard (recommended):** connect the Git repo; build command
  `npm ci && hugo --gc --minify`, output `public`, env vars `HUGO_VERSION`
  and `NODE_VERSION=22`.
- **CI deploys:** create the Pages project once with
  `npx wrangler pages project create <name>`, set `CLOUDFLARE_API_TOKEN` +
  `CLOUDFLARE_ACCOUNT_ID` secrets, and replace `<project-name>` in the
  workflow. If using the dashboard path instead, delete
  `.github/workflows/deploy.yml`.

## amplify

**Files:** `amplify.yml`

1. In the AWS console: **Amplify → Create new app → GitHub** and pick the repo;
   `amplify.yml` is detected automatically.
2. Custom domain: Amplify → Domain management (handles DNS + TLS via Route 53
   or external DNS); update `baseURL`.

## Analytics setup reminders

- **Umami:** set `params.analytics = {provider='umami', id='<website-id>'}`;
  add `host` for self-hosted instances (default `https://cloud.umami.is`).
- **Plausible:** `provider='plausible'`; `domain` defaults to the baseURL
  host; add `host` for self-hosted.
- **GA4:** `provider='ga4', id='G-XXXXXXX'`.
- Scripts load in production builds only. Custom events via
  `data-analytics-event` / `data-analytics-view` attributes.
