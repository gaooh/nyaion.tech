#!/usr/bin/env bash
# Cloudflare Pages（Git 連携）のビルドで実行する。
# フッターの build マーカーへ短縮コミットハッシュを焼き込み、手動 deploy.sh と同じ表示にする。
# Cloudflare 側では Build command に `bash build.sh`、Build output directory は `/` を設定する。
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Cloudflare Pages がビルド環境に注入するフルコミット SHA。
# ローカル実行時は git から取得し、いずれも取れなければ dev のまま据え置く。
SHA="${CF_PAGES_COMMIT_SHA:-$(git -C "$ROOT_DIR" rev-parse HEAD 2>/dev/null || echo dev)}"
SHORT_LEN=7  # git の短縮ハッシュ長に合わせる（deploy.sh の rev-parse --short と同等）
MARKER="${SHA:0:${SHORT_LEN}}"

# <span class="footer-build">…</span> の中身だけ置換する（プレースホルダ文字列はこの 1 箇所のみ）。
# BSD/GNU 双方で動くよう sed -i は使わず一時ファイル経由にする。
TARGET="$ROOT_DIR/index.html"
TMP="$(mktemp)"
sed "s|\(class=\"footer-build\">\)[^<]*|\1${MARKER}|" "$TARGET" > "$TMP"
mv "$TMP" "$TARGET"

echo "Injected build marker: ${MARKER}"
