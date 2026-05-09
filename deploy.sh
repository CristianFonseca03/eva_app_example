#!/usr/bin/env zsh
set -e

REPO=$(gh repo view --json nameWithOwner -q '.nameWithOwner')
BASE_HREF="/${REPO#*/}/"

echo "→ build web (base-href: $BASE_HREF)"
fvm flutter build web --base-href "$BASE_HREF"

echo "→ deploy a gh-pages"
git worktree add /tmp/gh-pages-deploy gh-pages 2>/dev/null || {
  git branch -D gh-pages 2>/dev/null || true
  git worktree add --orphan -B gh-pages /tmp/gh-pages-deploy
}

cp -r build/web/. /tmp/gh-pages-deploy/
cd /tmp/gh-pages-deploy
git add -A
git commit -m "deploy: $(date '+%Y-%m-%d %H:%M')"
git push origin gh-pages --force

cd -
git worktree remove /tmp/gh-pages-deploy --force

echo "✓ https://$(echo $REPO | tr '/' '.').github.io/${REPO#*/}/"
