# psionictraining-site — marketing site

Static marketing site for **Psionic Training**, served at
**https://psionictraining.com**. No build step, no framework: plain HTML/CSS/JS.

| | |
|---|---|
| GitHub | `Goliath-HCD/psionictraining-site` (public), default branch `main` |
| Vercel project | `psionictraining` (team *Goliath-HCD's projects*) |
| Deploys | automatic on push to `main`; branch pushes get a preview URL |
| Output dir | repo root (`.`) — framework preset "Other" |

## Layout

- `index.html` — the whole landing page (hero, pricing, newsletter, CTA)
- `privacy.html`, `terms.html` — legal pages
- `sitemap.xml`, `google*.html` — SEO / Search Console verification
- `assets/` — images, audio, fonts
- `DNS-AND-VERCEL-SETUP.md` — the one-time subdomain-split checklist (historical)

## The wider system

- **psionictraining.com** — this repo (marketing)
- **app.psionictraining.com** — the React app, repo `Goliath-HCD/psionicassist`
- **psionicresearch.com** — the research/content site, repo `Goliath-HCD/psionicresearch-site`
- **psionicassist.com** — 301 redirect to psionictraining.com. Nothing is served
  from it. Do **not** point forms or API calls at `psionicassist.com/api/*`.

## Email capture

MailerLite account `2348934`. The landing page uses the **embed-only** pattern:
a plain `<form>` posted with `fetch()` to
`https://assets.mailerlite.com/jsonp/2348934/forms/<form id>/subscribe`.
The MailerLite Universal script is deliberately *not* loaded here.

- Form `197589709603473326` (`Jz2m8Q`) → group **Psionic Training - Interested**

## Analytics

Vercel Web Analytics via `<script defer src="/_vercel/insights/script.js">`
before `</body>` on every page. The script only returns data once Web Analytics
is enabled for the project in the Vercel dashboard.

## Working on this repo

- Commit each logical change separately; push to a branch and check the Vercel
  preview before merging to `main`.
- Don't add `*.command` push-helper scripts — they were a leftover from the
  retired Goliath/OpenClaw Mac-mini workflow. **Cowork / Claude Code is now the
  executor**, pushing straight to GitHub.
