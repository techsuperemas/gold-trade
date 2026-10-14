#!/usr/bin/env bash
# One-time setup: creates the private Vercel project, stores the secrets, deploys to production.
# Needs Node 18+ installed. A browser window opens once for the Vercel login.
set -euo pipefail
cd "$(dirname "$0")"
source ./.env.setup
PROJECT="gold-flow-v35yoj"
V="npx --yes vercel@latest"

$V whoami >/dev/null 2>&1 || $V login
$V project add "$PROJECT" >/dev/null 2>&1 || true
$V link --yes --project "$PROJECT"

for KEY in SITE_PASSWORD AUTH_SECRET APPS_SCRIPT_KEY; do
  $V env rm "$KEY" production --yes >/dev/null 2>&1 || true
  printf '%s' "${!KEY}" | $V env add "$KEY" production --sensitive
done

$V deploy --prod
echo
echo "Done. Open the production URL above and unlock with the password from .env.setup."
echo "Delete .env.setup afterwards; the secrets now live in Vercel."
