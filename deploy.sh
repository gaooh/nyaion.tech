#!/usr/bin/env bash
# 公開ポータル（nyaion-tech / nyaion.tech）を Cloudflare Pages へ手動デプロイする。
# 通常は main への push で Git 連携が自動デプロイするため、本スクリプトは緊急時の
# フォールバック用。デプロイ時のコミットハッシュをフッターの build マーカーに焼き込む。
# ソースは汚さず、一時ステージにコピーしてから置換・デプロイする。
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
HASH="$(git -C "$ROOT_DIR" rev-parse --short HEAD)"

STAGE="$(mktemp -d)"
trap 'rm -rf "$STAGE"' EXIT

# 公開する静的アセットだけをステージへ（リポメタ・設計ドキュメント・ローカルキャッシュは除外）
rsync -a \
  --exclude '.git' \
  --exclude '.wrangler' \
  --exclude '.gitignore' \
  --exclude 'deploy.sh' \
  --exclude 'wrangler.toml' \
  --exclude 'README.md' \
  --exclude 'docs' \
  "$ROOT_DIR"/ "$STAGE"/

# フッターの build マーカーに短縮コミットハッシュを焼き込む
sed -i '' "s|<span class=\"footer-build\">[^<]*</span>|<span class=\"footer-build\">${HASH}</span>|" "$STAGE/index.html"

cd "$STAGE"
echo "Deploying nyaion-tech at commit ${HASH}"
wrangler pages deploy . --project-name=nyaion-tech --commit-dirty=true
