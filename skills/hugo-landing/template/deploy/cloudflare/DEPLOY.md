# Deploying to Cloudflare Pages

Cloudflare Pages builds are configured in the dashboard (recommended) or via
the optional GitHub Actions workflow in this directory.

## Dashboard setup (recommended)

1. Push this repository to GitHub/GitLab.
2. In the Cloudflare dashboard: **Workers & Pages → Create → Pages → Connect to Git**.
3. Select the repository and configure:
   - **Build command:** `npm ci && hugo --gc --minify`
   - **Build output directory:** `public`
4. Add environment variables under **Settings → Environment variables**:
   - `HUGO_VERSION` = `__HUGO_VERSION__`
   - `NODE_VERSION` = `22`
5. Deploy. Every push to `main` builds production; every PR gets a preview URL.

## Custom domain

**Custom domains → Set up a custom domain.** Cloudflare handles DNS and TLS
automatically if the domain is on Cloudflare.

## Alternative: GitHub Actions + wrangler

If you prefer deploys from CI (e.g. to control the Hugo install precisely),
use the workflow in `.github/workflows/deploy.yml` next to this file. It needs
two repository secrets: `CLOUDFLARE_API_TOKEN` (Pages:Edit permission) and
`CLOUDFLARE_ACCOUNT_ID`, plus a Pages project created once with:

```sh
npx wrangler pages project create <project-name>
```
