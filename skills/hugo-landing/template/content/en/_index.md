+++
date = '2026-01-01T09:00:00+00:00'
draft = false
title = '__SITE_NAME__ — Example headline for your landing page'
description = 'One or two sentences that describe the value you deliver. This is the meta description for the homepage.'

# NOTE (TOML): all scalar params must stay ABOVE the [[array]] tables below,
# otherwise they get nested inside the last array entry.
#
# Every section below is optional: remove its params and it disappears from
# the homepage. See the hugo-landing skill's reference/content-model.md.

# === HERO ===
heroName = 'Your Name'
heroRole = 'Your Role'
heroBio = '''One or two lines of credibility: years of experience, what you have built, who you have helped.'''
heroTitle = 'A headline that names the problem you solve for your customers.'
heroSubtitle = '''A supporting paragraph that explains how you solve it and what makes your approach different. Keep it to two or three sentences.'''
heroButton = 'Book an intro call'
heroButtonLink = '#contact'
heroSecondaryCta = 'See results'

# === PROBLEMS / PAIN POINTS ===
problemsTitle = 'Sound familiar?'
problemsOutro = '''If you recognize yourself in any of these situations, keep reading to see how I work.'''
problemsOutroCta = 'See how I work'

# === HOW I WORK / METHOD ===
stepsTitle = 'How I work'
stepsCardsTitle = 'Principles'
stepsCards = ['Hands-on', 'Data driven', 'Transparent']

# === CASE STUDIES ===
casesTitle = 'Case studies'
casesResultLabel = 'Result'

# === SOCIAL PROOF ===
socialProofKicker = 'Clients'

# === ABOUT ===
aboutTitle = 'About me'
# aboutPortrait = 'images/about-portrait.jpg'   # theme/site asset path

# === BLOG ===
blogTitle = 'Blog'
blogButtonText = 'View all articles'
# featuredPost = '/blog/my-pinned-post'
# blogTags = [
#   { name = 'Guides', tag = 'guides' },
#   { name = 'News', tag = 'news' },
# ]

# === FINAL CTA / CONTACT ===
contactTitle = 'Ready to talk?'
contactSubtitle = '''30 minutes, no strings attached. You will leave with at least one actionable idea.'''
bookCallText = 'Book your call'

# === ARRAYS (keep at the end) ===

[[problemsGroups]]
title = 'For founders'
items = [
  'Example pain point your customers experience, in their own words.',
  'Another concrete situation that makes them look for help.',
  'A third pain point — three per group works well.',
]

[[problemsGroups]]
title = 'For teams'
items = [
  'A pain point from a second audience segment.',
  'Something they struggle with that you can fix.',
  'One more, phrased as they would say it.',
]

[[steps]]
title = 'Diagnose'
duration = '2–3 weeks'
description = '''Describe the first step of your engagement: what you analyze, what the client gets at the end (report, roadmap, workshop).'''

[[steps]]
title = 'Implement'
duration = '2–3 months'
description = '''Describe how you execute: how you work with the team, what changes, how progress is measured.'''

[[steps]]
title = 'Support'
duration = 'ongoing'
description = '''Describe the optional long-term relationship: retainers, advisory, follow-up.'''

[[socialProofClients]]
name = 'Client One'
url = ''
[[socialProofClients]]
name = 'Client Two'
url = ''
[[socialProofClients]]
name = 'Client Three'
url = ''

[[caseStudies]]
title = 'Case study headline: the transformation you delivered'
context = 'Problem: one sentence describing the situation the client was in before you arrived.'
bullets = [
  'What you did, step one',
  'What you did, step two',
  'What you did, step three',
]
result = '''The measurable outcome, ideally with a number: 2× faster delivery, 40% cost reduction.'''

[[caseStudies]]
title = 'A second case study'
context = 'Problem: another client situation.'
bullets = [
  'Concrete action taken',
  'Another concrete action',
]
result = '''The outcome, in one sentence.'''

[[aboutBioLines]]
line = 'First paragraph of your bio: experience, companies, credentials.'
[[aboutBioLines]]
line = 'Second paragraph: how you think about your work, what drives your approach.'
[[aboutBioLines]]
line = 'Third paragraph: something personal or a link to a [side project](https://example.com).'
+++
