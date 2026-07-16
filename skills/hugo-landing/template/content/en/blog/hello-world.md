+++
title = 'Hello world: your first post'
date = '2026-01-01T10:00:00+00:00'
draft = false
description = 'An example post showing the front matter this theme expects.'
tags = ['guides']
# coverImage = 'images/blog/hello-world.jpg'   # theme/site asset path, used for OpenGraph + article JSON-LD
# translationKey = 'hello-world'               # same key across languages links translations
+++

This is an example post. Replace it with your own writing.

## What you get

Posts support standard Markdown, code blocks, and the theme's shortcodes:

- `faq` — collapsible questions with FAQPage JSON-LD for rich snippets
- `stat-grid` — a responsive grid of highlighted numbers
- `timeline` — a vertical timeline of dated milestones

## FAQ example

{{< faq >}}
[
  {"q": "Does this output structured data?", "a": "Yes — the faq shortcode emits FAQPage JSON-LD automatically."},
  {"q": "Can I use Markdown in answers?", "a": "Yes, answers are rendered through Markdown."}
]
{{< /faq >}}
