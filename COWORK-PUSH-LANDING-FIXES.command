#!/bin/bash
# Commit + push landing page improvements to GitHub → auto-deploys to Vercel
set -e
cd "$(dirname "$0")"

PAT="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"

# Ensure PAT is in remote URL for autonomous future pushes
git remote set-url origin "https://goliath-hcd:${PAT}@github.com/Goliath-HCD/psionictraining-site.git"

# Remove any stale git locks
rm -f .git/HEAD.lock .git/index.lock

# Stage and commit
git add index.html
git commit --author="Goliath HCD <goliath.hcd@gmail.com>" \
  -m "feat: landing page improvements — 3-instructor CTA, MailerLite form, mobile nav fix

- CTA section: Lyra + Akash + Veil overlapping trio replaces single Akash photo
- Newsletter: live MailerLite signup form (psionicresearch.com list) replaces 'launching soon'
- Mobile nav: hide logo text on <480px so Start Training Free button is fully visible
- CTA copy updated to mention all 3 instructors" || echo "(nothing new to commit)"

git push origin main

echo ""
echo "Done. Vercel will auto-deploy psionictraining.com in ~30s."
echo "Check: https://psionictraining.com"
