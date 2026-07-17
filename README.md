# hugo-landing — a Claude Code skill for scaffolding Hugo landing pages

🌐 Project website: [hugolanding.com](https://hugolanding.com)

A [Claude Code](https://claude.com/claude-code) plugin that scaffolds
production-ready **Hugo landing page + blog** sites in minutes:

- **Landing page** built from front-matter params: hero, pain points,
  features grid, method/steps, stats band, case-study carousel, testimonials,
  pricing tiers, about, team, blog preview, open-source projects, FAQ (with
  FAQPage JSON-LD), newsletter signup, final CTA — every section optional.
- **Blog** with pagination, tags, RSS, reading time, prev/next navigation.
- **SEO**: canonical URLs, OpenGraph, Twitter cards, JSON-LD graph
  (WebSite/Organization/WebPage/Article, optional Person, FAQPage via
  shortcode), sitemap, robots.txt, hreflang.
- **Multilingual**: any languages, added with one script call + translation.
- **Styling**: Tailwind CSS via PostCSS; swap the whole brand color with one
  line in `tailwind.config.js`.
- **Analytics**: Umami, Plausible or GA4 (production builds only), plus
  attribute-driven custom event tracking.
- **CI/CD**: pick GitHub Pages (Actions), Cloudflare Pages, Netlify or AWS
  Amplify at scaffold time; a lint+build CI workflow is always included.

## Install

As a plugin:

```
/plugin marketplace add gerodp/hugo-landing-skill
/plugin install hugo-landing
```

Or copy the skill directly:

```sh
cp -R skills/hugo-landing ~/.claude/skills/
```

## Use

In Claude Code:

```
/hugo-landing my-new-site
```

or just ask: *"Create a landing page with Hugo for my consulting business"*.
Claude interviews you (name, languages, color, sections, deploy target,
analytics), runs the deterministic scaffold scripts, writes your copy, and
verifies the site builds cleanly.

## What's inside

```
skills/hugo-landing/
├── SKILL.md            # the procedure Claude follows
├── scripts/            # deterministic steps (bash, no dependencies)
│   ├── scaffold.sh     # copy template + substitute tokens + deploy target + git init
│   ├── add-language.sh # structural parts of adding a language
│   ├── resolve-hugo-version.sh
│   └── verify.sh       # token check + npm install + build + smoke test
├── reference/          # docs Claude consults on demand
│   ├── content-model.md
│   ├── multilingual.md
│   └── deploy.md
└── template/           # complete, buildable Hugo site (theme "landing")
```

The template builds standalone; a weekly [canary
workflow](.github/workflows/canary.yml) scaffolds and builds it against the
**latest Hugo release**, so incompatibilities with new Hugo versions surface
as CI failures (and an auto-filed issue) instead of user bug reports.

## Requirements

- Hugo ≥ 0.146 (standard edition is fine)
- Node.js ≥ 20 (Tailwind/PostCSS pipeline)
- git

## License

[MIT](LICENSE)
