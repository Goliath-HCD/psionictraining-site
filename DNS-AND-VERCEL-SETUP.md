# Subdomain split — setup checklist

This is the one-time setup for the marketing/app split. After this, the architecture is:

- **psionictraining.com** (root) → marketing site (this folder)
- **app.psionictraining.com** → the React app (`~/Dev/psionicassist`)
- **psionicassist.com** → 301 redirect to psionictraining.com (already configured)

Estimated time: 30 minutes of David clicks + 1-15 minutes DNS propagation.

---

## Step 1 — Push both repos (you do this first, before any cloud changes)

Two scripts, run them in this order:

1. `~/Dev/psionicassist/COWORK-PUSH-SUBDOMAIN-FIXES.command` — pushes the API/auth changes
2. `~/Dev/psionic/psionictraining-site/COWORK-DEPLOY-MARKETING.command` — pushes the updated marketing HTML

Vercel will auto-deploy each from GitHub. The psionicassist deploy goes live immediately (nothing user-visible changes yet — env vars still point at psionictraining.com).

---

## Step 2 — Create a Vercel project for the marketing site

In the Vercel dashboard (logged in as Goliath HCD):

1. Click "Add New" → "Project"
2. Import the GitHub repo: `Goliath-HCD/psionictraining-site`
3. Framework preset: **Other** (it's static HTML — no build step)
4. Build command: leave empty
5. Output directory: `.` (root)
6. Click "Deploy"

You should see a deployment URL like `psionictraining-site-abc123.vercel.app`. Open it — should look like the new marketing site with the pricing block.

**Project name in Vercel:** `psionictraining-marketing` (keeps it distinct from `psionicassist` which is the app).

---

## Step 3 — Connect domains

You have two domain operations to do:

### 3a. Add app.psionictraining.com to the EXISTING psionicassist Vercel project

In Vercel dashboard:
1. Open the `psionicassist` project (the existing one)
2. Settings → Domains
3. Add domain: `app.psionictraining.com`
4. Vercel shows you a CNAME record to add at DreamHost

### 3b. Move psionictraining.com (root) from psionicassist project to the new marketing project

In Vercel dashboard:
1. Open the existing `psionicassist` project
2. Settings → Domains
3. Find `psionictraining.com` (and `www.psionictraining.com` if present) → **Remove** from this project
4. Open the new `psionictraining-marketing` project
5. Settings → Domains
6. Add: `psionictraining.com` AND `www.psionictraining.com`
7. Vercel may show a "Verify Ownership" step — follow it

**Order matters:** remove from old project first, then add to new project. If you try to add to the new project while it's still on the old one, Vercel will error.

---

## Step 4 — DreamHost DNS

Go to DreamHost panel → Domains → Manage DNS for `psionictraining.com`.

You need ONE new record:

| Name | Type | Value |
|------|------|-------|
| `app` | CNAME | `cname.vercel-dns.com` |

That makes `app.psionictraining.com` resolve to Vercel.

For the root `psionictraining.com`, the existing A/CNAME records should already point at Vercel (they were configured during the migration). Verify they're still there:
- `@` should be A record `76.76.21.21` OR CNAME `cname.vercel-dns.com`
- `www` should be CNAME `cname.vercel-dns.com`

If they're missing, add them.

DNS propagation: usually 1-2 minutes for DreamHost. Sometimes up to 15.

---

## Step 5 — Update env vars on the existing psionicassist Vercel project

In Vercel dashboard → psionicassist project → Settings → Environment Variables.

Add or update:

| Variable | Value | Environments |
|----------|-------|--------------|
| `VITE_APP_URL` | `https://app.psionictraining.com` | Production, Preview |

Then click "Redeploy" on the latest production deployment so the new env var takes effect.

---

## Step 6 — Update Supabase auth redirect URLs

Supabase dashboard → Authentication → URL Configuration:

1. **Site URL:** change to `https://app.psionictraining.com`
2. **Redirect URLs (additional):** add both:
   - `https://app.psionictraining.com/**`
   - `https://psionictraining.com/**` (keep — for any auth flow that bounces through marketing)

---

## Step 7 — Update Stripe success/cancel URLs

If you have any Stripe products/prices configured with hardcoded `success_url` or `cancel_url`, update them to use `app.psionictraining.com`. Most likely these are constructed dynamically in `api/create-checkout.js` and don't need a dashboard change — they'll pick up the new `VITE_APP_URL` env var automatically.

Stripe webhook URL: should already be pointing at `https://app.psionictraining.com/api/stripe-webhook` (or will be once DNS is live). Check at Stripe Dashboard → Developers → Webhooks. Update if it still says `psionictraining.com/api/stripe-webhook`.

---

## Step 8 — Smoke test

Open all of these in incognito tabs and verify each one works:

- [ ] `https://psionictraining.com` → marketing site loads, pricing block visible, "Hear Lyra" voice plays
- [ ] `https://psionictraining.com/#pricing` → scrolls to pricing
- [ ] Click "Start as Operative" → lands on `https://app.psionictraining.com/login`
- [ ] `https://app.psionictraining.com` → app loads, login UI visible
- [ ] Log in with a test account → reaches dashboard with 3 instructor blocks
- [ ] `https://psionicassist.com` → 301 redirects to `psionictraining.com`
- [ ] `https://psionicassist.com/app` → 301 redirects to `app.psionictraining.com/app` (this may need a small redirect update on the old domain config if it isn't already path-preserving)

If everything green, ping me and I'll close the task list.

---

## Troubleshooting

**"Domain is already in use" error in Vercel:** You forgot to remove psionictraining.com from the old project first. Go back to Step 3b.

**Voice on marketing site doesn't play:** TTS CORS allowlist is set, but the env vars on the API need to be live. Did you redeploy after setting VITE_APP_URL? (Step 5 last line.)

**Auth bounces to wrong domain after login:** Supabase Site URL still says `psionictraining.com`. Fix at Step 6.

**SSL certificate warning on app.psionictraining.com:** Vercel auto-provisions SSL on domain add, but it can take 1-2 minutes. Wait, then refresh.
