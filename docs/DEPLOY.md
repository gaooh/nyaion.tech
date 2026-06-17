# デプロイ手順（nyaiontech 公開ポータル / nyaion.tech）

このリポ（`gaooh/nyaion.tech`）の静的ポータルを **公開**サイトとして Cloudflare Pages に配信する手順。

> **社内 `_portal/` とは別物**。
> - 本サイト = Pages プロジェクト `nyaiontech-site`・**Access なしの一般公開**・ドメイン `nyaion.tech`
> - 社内ポータル = Pages プロジェクト `nyaiontech-portal`・**Cloudflare Access 保護の非公開**（別リポ `gaooh/nyaiontech` の `_portal/`）
> 取り違え・相互リンクしない（要件 [requirements-2026-06.md](./requirements-2026-06.md) §1.4）。

---

## 自動デプロイ（通常運用）

`main` への push で **Cloudflare Pages の Git 連携**が自動ビルド/デプロイする。

- ビルドコマンド: なし（静的 HTML/CSS）
- 出力ディレクトリ: `/`（リポジトリルート）
- 本番ブランチ: `main`

push 後、Cloudflare のビルドが緑になったら `https://nyaion.tech/`（および `nyaiontech-site.pages.dev`）で反映を確認する。

> 出力ディレクトリが `/` のため、`docs/` やリポメタ（README 等）も公開ドメインから取得可能。公開したくない素材を `docs/` に置かないこと。

---

## 初回セットアップ（実施済み・2026-06）

既存の Pages プロジェクト `nyaiontech-site`（カスタムドメイン `nyaion.tech` を保持）に対し、本リポ `gaooh/nyaion.tech` の **Git 連携を接続**した。新規プロジェクト作成・ドメイン付け替えは不要だった。

ダッシュボードでの操作:

1. [Cloudflare dashboard](https://dash.cloudflare.com) → Workers & Pages → `nyaiontech-site` → **Settings** → **Build** / **Git** からリポジトリ `gaooh/nyaion.tech` を接続
2. ビルド設定:
   - Production branch: `main`
   - Framework preset: None
   - Build command: （空）
   - Build output directory: `/`
3. 接続後、`main` への push でビルド完了を `nyaiontech-site.pages.dev` / `https://nyaion.tech/` で確認

> ドメイン `nyaion.tech` は元から `nyaiontech-site` に付与済みのため、DNS・SSL の再設定は不要。

---

## 手動デプロイ（フォールバック）

Git 連携が使えない緊急時のみ。フッターの build マーカーに短縮コミットハッシュを焼き込む。

```sh
# wrangler ログイン済み（アカウント gaooh.dandelion@gmail.com）であること
./deploy.sh
```

`deploy.sh` は公開アセットだけを一時ステージへコピー（`docs/`・リポメタ・`.wrangler` を除外）し、`wrangler pages deploy . --project-name=nyaiontech-site` する。

---

## ローカルプレビュー

```sh
python3 -m http.server 8787
# → http://localhost:8787/
```

---

## ride map の更新

走破エリア地図（`#map`）の更新は、集計スクリプト（リポ外 `~/.config/crew/work/portal-ride-map/`）で `visited.json` を再生成し、`index.html` へ焼き込む。詳細は [README](../README.md) の「Map セクション」と [map-section-2026-06-design.md](./map-section-2026-06-design.md) を参照。焼き込み後に commit/push すれば自動デプロイされる。

---

## トラブルシュート

- **deploy.sh の "uncommitted changes" 警告**: 無視可（`--commit-dirty=true` 指定済み）
- **apex が古いまま**: ドメイン付け替えの DNS 反映待ち。Pages の Custom domains が "Active" か確認
- **CSS 変更が反映されない**: `_headers` の `Cache-Control: no-cache` で再検証させている。ブラウザのハードリロードも試す
