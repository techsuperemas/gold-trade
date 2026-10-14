# Gold Ledger Flow

Private lot-flow dashboard for the Gold Trading Ledger, hosted on Vercel.

## Deploy (once)

```bash
cd gold-ledger-flow
bash setup.sh
```

This logs in to Vercel, creates project `gold-flow-v35yoj`, stores the secrets from `.env.setup`, and deploys to production. Delete `.env.setup` afterwards.

Later updates: `npx vercel deploy --prod`.

## How privacy works

- The page itself holds no data. All ledger data comes from `/api/ledger`, which returns 401 without a valid session.
- Login (`/api/login`) checks `SITE_PASSWORD` and sets an HttpOnly, Secure, SameSite=Strict cookie signed with `AUTH_SECRET`, valid 7 days. **Lock** clears it.
- Wrong passwords are slowed down. Pages send `noindex` and cannot be embedded in other sites.
- To change the password: `npx vercel env rm SITE_PASSWORD production`, `npx vercel env add SITE_PASSWORD production`, then redeploy. Changing `AUTH_SECRET` logs everyone out.

## Live data from the sheet (optional, recommended)

Until this is done, the site shows the embedded snapshot of 14 Oct 2026.

1. Open the Gold Trading Ledger sheet → **Extensions → Apps Script**.
2. Replace the editor contents with `apps-script/Code.gs` and save.
3. **Project Settings → Script Properties → Add**: name `KEY`, value = `APPS_SCRIPT_KEY` from `.env.setup`.
4. **Deploy → New deployment → Web app**. Execute as: **Me**. Who has access: **Anyone**. Authorize, copy the URL ending in `/exec`.
5. In this folder:
   ```bash
   npx vercel env add APPS_SCRIPT_URL production   # paste the /exec URL
   npx vercel deploy --prod
   ```

The web app returns nothing without the key, and only the Vercel server knows the key. The badge in the header switches from **Snapshot** to **Live**; data refreshes every 60 s, or immediately with **Refresh**.

## Files

- `public/index.html` — the dashboard (Canvas renderer, no data inside)
- `api/ledger.js`, `api/login.js`, `api/logout.js` — protected endpoints
- `lib/build.js` — turns sheet tabs into the lineage graph (columns matched by header name)
- `data/snapshot.js` — fallback data, bundled into the function, never served as a file
- `apps-script/Code.gs` — the sheet-side endpoint
