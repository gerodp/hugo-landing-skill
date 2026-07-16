# Content model

## Homepage (`content/<lang>/_index.md`)

The homepage is built from front-matter params. Omit a section's params to
remove that section. TOML rule: all scalars ABOVE the `[[array]]` tables.

### Hero (always rendered)

| Param | Notes |
|---|---|
| `heroTitle` | Main headline (falls back to `title`) |
| `heroSubtitle` | Supporting paragraph |
| `heroButton`, `heroButtonLink` | Primary CTA; link can be `#contact` or external |
| `heroSecondaryCta` | Optional link to `#results` (only if case studies exist) |
| `heroName`, `heroRole`, `heroBio` | Right-hand personal panel; without `heroName` the hero falls back to a simpler centered layout |

### Pain points (`#problems`)

| Param | Notes |
|---|---|
| `problemsTitle` | Section heading |
| `[[problemsGroups]]` with `title`, `items[]` | Two-column grouped cards (e.g. per audience) |
| `problemsItems[]` | Flat list alternative to groups |
| `problemsOutro`, `problemsOutroCta` | Closing paragraph + link to `#method` |

### Features grid (`#features`)

| Param | Notes |
|---|---|
| `featuresTitle` | Section heading |
| `[[features]]` with `icon`, `title`, `description` | 3–6 cards; `icon` is an emoji (optional) |

### Method / steps (`#method`)

| Param | Notes |
|---|---|
| `stepsTitle` | Section heading |
| `[[steps]]` with `title`, `duration`, `description` | Numbered step cards |
| `stepsBody` | Markdown alternative to steps |
| `stepsCardsTitle`, `stepsCards[]` | Optional principle cards row |

### Stats band (`#stats`)

`statsTitle` (optional) + `[[stats]]` with `value` (e.g. "120+"), `label`.
Renders as a slim centered band of big numbers.

### Case studies (`#results`, dark section with carousel)

| Param | Notes |
|---|---|
| `casesTitle` | Section heading |
| `[[caseStudies]]` with `title`, `context`, `bullets[]`, `result` | One card each |
| `casesResultLabel` | Label above the result box (default "Result") |
| `socialProofKicker`, `[[socialProofClients]]` with `name` | Client names strip below carousel |

### Testimonials (`#testimonials`)

| Param | Notes |
|---|---|
| `testimonialsTitle` | Section heading |
| `[[testimonials]]` with `quote`, `name`, `role`, `avatar` | Quote cards; `avatar` is an asset path, falls back to an initial |

### Pricing (`#pricing`)

| Param | Notes |
|---|---|
| `pricingTitle`, `pricingSubtitle` | Section header |
| `pricingHighlightLabel` | Badge on the highlighted tier (default "Most popular") |
| `[[pricingTiers]]` | `name`, `price`, `period`, `description`, `features[]`, `cta`, `ctaLink` (default `#contact`), `highlighted` (bool) |

### About (`#about`)

| Param | Notes |
|---|---|
| `aboutTitle` | Section heading |
| `[[aboutBioLines]]` with `line` | Paragraphs (markdown supported) |
| `aboutPortrait` | Asset path (e.g. `images/about-portrait.jpg`); omit for no photo |

Social chips come from `params.social.{linkedin,github,twitter}` in hugo.toml.

### Team (`#team`)

`teamTitle` + `[[team]]` with `name`, `role`, `photo` (asset path, falls back
to an initial), and optional `linkedin`/`github`/`twitter` URLs per member.
Mostly for company/agency sites.

### Blog preview (`#blog`)

| Param | Notes |
|---|---|
| `blogTitle` | Required to render the section |
| `blogTags[]` with `name`, `tag` | Tag filter chips |
| `featuredPost` | Page path to pin first (e.g. `/blog/my-post`) |
| `blogButtonText` | "View all" button |

### Open source (`#open-source`)

`ossTitle` + `[[ossProjects]]` with `name`, `description`, `url`.

### FAQ (`#faq`)

`faqTitle` + `[[faqItems]]` with `q`, `a` (Markdown supported in answers).
Renders accordions and emits FAQPage JSON-LD automatically — great for rich
snippets. (For FAQs inside blog posts, use the `faq` shortcode instead.)

### Newsletter (`#newsletter`)

| Param | Notes |
|---|---|
| `newsletterTitle` | Required (with `newsletterAction`) to render |
| `newsletterSubtitle`, `newsletterButton`, `newsletterPlaceholder` | Copy |
| `newsletterAction` | Form POST URL — e.g. Buttondown `https://buttondown.com/api/emails/embed-subscribe/<user>`, or the action from a Mailchimp/ConvertKit embed snippet |
| `newsletterEmailField` | `name` attribute of the email input (default `email`) |

### Final CTA (`#contact`)

`contactTitle`, `contactSubtitle`, `bookCallText`. The button links to
`params.bookCallUrl`, else `mailto:params.contactEmail`.

## Blog posts (`content/<lang>/blog/*.md`)

```toml
+++
title = 'Post title'
date = 2026-01-15T10:00:00+01:00
draft = false
description = 'Meta description (search snippet + OpenGraph)'
tags = ['guides']
coverImage = 'images/blog/cover.jpg'    # asset path; drives OG image + Article JSON-LD
translationKey = 'unique-key'           # same key across languages links translations
# author override (site params provide the default):
# [author]
# name = 'Name'
# bio = 'One-liner'
# image = 'images/authors/name.jpg'
+++
```

Blog listing lives at `content/<lang>/blog/_index.md` (title, description,
optional `blogTags` for filter chips). Posts paginate 9 per page; tag pages
are generated automatically at `/tags/<tag>/`.

## Shortcodes

- **faq** — JSON array of `{"q", "a"}`; renders `<details>` accordions and
  emits FAQPage JSON-LD. Answers support Markdown.

  ```
  {{</* faq */>}}
  [ {"q": "Question?", "a": "Answer with **markdown**."} ]
  {{</* /faq */>}}
  ```

- **stat-grid** — `{"items": [{"value": "97%", "label": "..."}], "footnote": "..."}`.
- **timeline** — JSON array of `{"date", "label", "description", "current": true, "tag": "You are here"}`.

## Site params (hugo.toml) quick reference

| Param | Purpose |
|---|---|
| `brandName` | Header brand text (falls back to title) |
| `description` | Default meta description |
| `author`, `authorImage` | Default post author |
| `contactEmail`, `bookCallUrl` | Contact CTA + footer email |
| `logo`, `shareImage` | Organization JSON-LD logo; default OG image |
| `themeColor`, `googleFont` | Browser theme color; Google Font family spec |
| `social.{linkedin,github,twitter}` | About chips + JSON-LD sameAs |
| `jsonld.{personName,jobTitle,knowsAbout}` | Optional Person entity (personal brands) |
| `analytics.{provider,id,host,domain}` | umami / plausible / ga4 |
| `footer.{servicesTitle,services,links,copyright}` | Footer columns |
| `footer.hideMadeWith` | `true` hides the "Made with Hugo Landing Skill" credit |
| `noindex`, `noindexInDev` | Robots control |
| `languagedomains`, `domaindefaultlangs` | ADVANCED: serve languages from different domains (see multilingual.md) |
