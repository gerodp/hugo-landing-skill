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

# === FEATURES GRID ===
featuresTitle = 'What you get'

# === STATS BAND ===
# statsTitle = 'In numbers'   # optional heading

# === HOW I WORK / METHOD ===
stepsTitle = 'How I work'
stepsCardsTitle = 'Principles'
stepsCards = ['Hands-on', 'Data driven', 'Transparent']

# === CASE STUDIES ===
casesTitle = 'Case studies'
casesResultLabel = 'Result'

# === SOCIAL PROOF ===
socialProofKicker = 'Clients'

# === TESTIMONIALS ===
testimonialsTitle = 'What clients say'

# === PRICING ===
pricingTitle = 'Packages'
pricingSubtitle = 'Clear scope, clear price. Custom engagements available.'
pricingHighlightLabel = 'Most popular'

# === ABOUT ===
aboutTitle = 'About me'
# aboutPortrait = 'images/about-portrait.jpg'   # theme/site asset path

# === TEAM ===
# teamTitle = 'The team'   # uncomment with [[team]] entries for company sites

# === FAQ ===
faqTitle = 'Frequently asked questions'

# === NEWSLETTER ===
newsletterTitle = 'Get new articles by email'
newsletterSubtitle = 'No spam, unsubscribe anytime.'
newsletterButton = 'Subscribe'
# Form POST target — replace with your provider's endpoint, e.g.
# Buttondown: https://buttondown.com/api/emails/embed-subscribe/<user>
# Mailchimp:  the form action from your embedded-form snippet
newsletterAction = 'https://example.com/subscribe'
# newsletterEmailField = 'email'   # input name attribute if your provider needs another

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

[[features]]
icon = '⚡'
title = 'Feature one'
description = 'One or two sentences on the benefit this feature delivers.'
[[features]]
icon = '📊'
title = 'Feature two'
description = 'Focus on outcomes, not implementation details.'
[[features]]
icon = '🧩'
title = 'Feature three'
description = 'Three to six features works best in this grid.'

[[stats]]
value = '120+'
label = 'Projects delivered'
[[stats]]
value = '15'
label = 'Years of experience'
[[stats]]
value = '98%'
label = 'Client retention'

[[testimonials]]
quote = 'A short, punchy quote about the results you delivered. Real names and roles make these credible.'
name = 'Jane Doe'
role = 'CTO, Example Corp'
# avatar = 'images/testimonials/jane.jpg'
[[testimonials]]
quote = 'A second quote from a different kind of client, ideally covering a different objection.'
name = 'John Smith'
role = 'Founder, Startup Inc'

[[pricingTiers]]
name = 'Audit'
price = '$2,500'
period = 'one-time'
description = 'A fixed-scope starting point.'
features = ['Deliverable one', 'Deliverable two', 'Deliverable three']
cta = 'Book an audit'
ctaLink = '#contact'
[[pricingTiers]]
name = 'Retainer'
price = '$4,000'
period = '/month'
description = 'Ongoing hands-on engagement.'
features = ['Everything in Audit', 'Weekly working sessions', 'Async support']
cta = 'Get started'
ctaLink = '#contact'
highlighted = true
[[pricingTiers]]
name = 'Custom'
price = 'Let’s talk'
description = 'For larger teams or special scopes.'
features = ['Tailored scope', 'Team training', 'Priority availability']
cta = 'Contact me'
ctaLink = '#contact'

# [[team]]
# name = 'Alex Doe'
# role = 'Co-founder'
# photo = 'images/team/alex.jpg'
# linkedin = 'https://www.linkedin.com/in/example/'

[[faqItems]]
q = 'How do we start?'
a = 'Describe your onboarding: intro call, proposal, kickoff.'
[[faqItems]]
q = 'Do you work remotely?'
a = 'Answer common logistical questions here — each one becomes FAQPage structured data for search engines.'
[[faqItems]]
q = 'What if it does not work out?'
a = 'Handle the risk objection: guarantees, notice periods, exit terms.'

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
