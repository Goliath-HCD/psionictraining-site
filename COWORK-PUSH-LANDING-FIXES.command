#!/bin/bash
# Commit + push landing page improvements to GitHub → auto-deploys to Vercel
set -e
cd "$(dirname "$0")"

# Remove any stale git locks
rm -f .git/HEAD.lock .git/index.lock

# Stage and commit
git add index.html
git commit --author="Goliath HCD <goliath.hcd@gmail.com>" \
  -m "feat: landing page improvements — 3-instructor CTA, MailerLite form, audio badges, mobile nav fix

- CTA section: Lyra + Akash + Veil overlapping trio replaces single Akash photo
- Newsletter: live MailerLite signup form (psionicresearch.com list) replaces 'launching soon'
- Instructor cards: visible pulsing audio badge replaces hidden hover-only play hint
- Mobile nav: hide logo text on <480px so Start Training Free button is fully visible
- CTA copy updated to mention all 3 instructors" || echo "(nothing new to commit)"

git push origin main

echo ""
echo "Done. Vercel will auto-deploy psionictraining.com in ~30s."
echo "Check: https://psionictraining.com"
