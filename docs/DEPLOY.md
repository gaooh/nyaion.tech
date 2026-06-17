# デプロイ手順（nyaiontech 公開ポータル / nyaion.tech）

このリポ（`gaooh/nyaion.tech`）の静的ポータルを **公開**サイトとして Cloudflare Pages に配信する手順。

> **社内 `_portal/` とは別物**。
> - 本サイト = Pages プロジェクト `nyaion-tech`・**Access なしの一般公開**・ドメイン `nyaion.tech`
> - 社内ポータル = Pages プロジェクト `nyaiontech-portal`・**Cloudflare Access 保護の非公開**（別リポ `gaooh/nyaiontech` の `_portal/`）
> 取り違え・相互リンクしない（要件 [requirements-2026-06.md](./requirements-2026-06.md) §1.4）。

---

## 自動デプロイ（通常運用）

`main` への push で **Cloudflare Pages の Git 連携**が自動ビルド/デプロイする。

- ビルドコマンド: なし（静的 HTML/CSS）
- 出力ディレクトリ: `/`（リポジトリルート）
- 本番ブランチ: `main`

push 後、Cloudflare のビルドが緑になったら `https://nyaion.tech/`（および `*.nyaion-tech.pages.dev`）で反映を確認する。

> 出力ディレクトリが `/` のため、`docs/` やリポメタ（README 等）も公開ドメインから取得可能。公開したくない素材を `docs/` に置かないこと。

---

## 初回セットアップ（ダッシュボード手動作業）

### 1. Git 連携プロジェクトを作成

1. [Cloudflare dashboard](https://dash.cloudflare.com) → Workers & Pages → **Create** → Pages → **Connect to Git**
2. リポジトリ `gaooh/nyaion.tech` を選択
3. 設定:
   - Project name: `nyaion-tech`
   - Production branch: `main`
   - Framework preset: None
   - Build command: （空）
   - Build output directory: `/`
4. **Save and Deploy** → 初回ビルド完了を `*.nyaion-tech.pages.dev` で確認

### 2. カスタムドメイン `nyaion.tech` を付け替え

旧サイト（直接アップロード型 `nyaiontech-site`）から本プロジェクトへドメインを移す。

1. 旧 `nyaiontech-site` → Custom domains から `nyaion.tech` を **削除**
2. 新 `nyaion-tech` → Custom domains → **Set up a custom domain** → `nyaion.tech` を追加
3. 同アカウントの Zone のため、apex の DNS（CNAME flattening）と SSL 証明書は自動設定される
4. 数分後に `https://nyaion.tech/` で本サイトと有効な HTTPS を確認

### 3. 旧プロジェクトの整理（任意）

ドメイン移行後、旧 `nyaiontech-site`（直接アップロード型）は削除してよい。

> Cloudflare の制約: 直接アップロード型プロジェクトは Git 連携へ切替不可。このため新規 Git 連携プロジェクト（`nyaion-tech`）を別途作成している。

---

## 手動デプロイ（フォールバック）

Git 連携が使えない緊急時のみ。フッターの build マーカーに短縮コミットハッシュを焼き込む。

```sh
# wrangler ログイン済み（アカウント gaooh.dandelion@gmail.com）であること
./deploy.sh
```

`deploy.sh` は公開アセットだけを一時ステージへコピー（`docs/`・リポメタ・`.wrangler` を除外）し、`wrangler pages deploy . --project-name=nyaion-tech` する。

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
