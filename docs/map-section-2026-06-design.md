# 設計書：ポータル「Map / 走った場所」セクション（2026-06）

公開ポータル（リポジトリルートの静的サイト）の About 直下に、**自転車で走った場所を塗り分けた日本地図＋世界地図**の全幅セクションを新設し、暫定の「Data (2024)」ブロックを置き換える。

- 対象サイト: リポジトリルートの `index.html`（公開・`nyaion.tech` / `nyaiontech-site.pages.dev`）
- 関連: [README](../README.md) / [requirements-2026-06](./requirements-2026-06.md)
- ブレスト経緯: 仮データだった About 右の「Data」を見直し、走破エリアのコロプレス地図に差し替える要望。

## 目的・成功条件

- 「どこを自転車で走ったか」が一目で伝わる、塗りつぶしの日本地図・世界地図を表示する。
- 旧「Data」ブロック（仮の数値）を撤去し、地図＋カウントに置き換える。
- サイトの**零依存（実行時 JS なし・外部 API なし）**方針を維持する。

## 確定事項（ブレスト結果）

| 項目 | 決定 |
|---|---|
| データ元 | **Strava 一括エクスポート**（`activities/*.gpx[.gz]` 群）から集計 |
| レイアウト | About の下に**全幅セクション新設**、日本｜世界を**横並び**（狭幅で縦積み） |
| 地図表現 | リアルな地理 SVG の**コロプレス**（走った地域を塗る） |
| 塗り色 | **さび朱 `--stamp` #c1492f**（走った地域）。未踏はごく薄い面＋細い輪郭 |
| カウント | **出す**（例「27 / 47 都道府県」「5 の国・地域」） |
| 実装方式 | インライン SVG＋クラス塗り。集計は中央venvの作業スクリプト |

## アーキテクチャ（2 ユニット）

### 1. 集計スクリプト（オフライン・`g-work-script` で生成）
- 入力: Strava 一括エクスポートの GPX 群（`activities/`）。`.gpx` と `.gpx.gz` 両対応。
- 処理:
  1. 各 GPX のトラック点を間引きサンプリング（例: 1 点/Nトラックポイント＋始点）。
  2. **点‑in‑ポリゴン**判定で、点がどの都道府県／国に入るかを求める。
     - 日本: 都道府県境界 GeoJSON（パブリックドメイン/CC0。ISO `JP-01`…`JP-47`）。
     - 世界: Natural Earth（**パブリックドメイン**）国境 GeoJSON（ISO A2/A3）。
  3. 走った地域コードの集合を求める。
- 出力: `visited.json`（`{"jp": ["JP-07","JP-20",...], "world": ["JP","ZA",...], "counts": {...}}`）。
- ライブラリは信頼性の高いもののみ（例: `shapely`＋`gpxpy`、または `fiona`）。
- 注: 走破集計はあくまでサイト表示用。プライバシー上、生 GPX はリポにコミットしない（集計結果のみ反映）。

### 2. 表示（リポジトリルートの `index.html` ＋ `styles.css`）
- About セクション（`#about`）直下に新セクション `#map` を追加:
  ```html
  <section class="section" id="map">
    <div class="section-head"><span class="stamp-sq"></span><h2>Map</h2><span class="sub">走った場所</span></div>
    <div class="maps">
      <figure class="map-fig">
        <div class="map-svg"> … 日本(都道府県) inline SVG … </div>
        <figcaption>27 / 47 都道府県</figcaption>
      </figure>
      <figure class="map-fig">
        <div class="map-svg"> … 世界(国) inline SVG … </div>
        <figcaption>5 の国・地域</figcaption>
      </figure>
    </div>
  </section>
  ```
- 各 `<path>` は `id`（ISO コード）を持ち、走った地域に `class="on"` を付与（スクリプト出力 `visited.json` を基にビルド時/手作業で焼き込み）。
- CSS（`styles.css`）:
  - `.map-svg path { fill: var(--paper-fill); stroke: var(--line); stroke-width: .5; }`（未踏）
  - `.map-svg path.on { fill: var(--stamp); }`（走った）
  - `.maps { display:grid; grid-template-columns: repeat(auto-fit, minmax(300px,1fr)); gap: clamp(20px,4vw,40px); }`
  - `figcaption` はステンシル（`--font-stencil`）でカウント表示。
- 旧「Data (2024)」ブロック（About 右カラム）は撤去。About を 1 カラム（プロフィール）主体に整える（`about-grid` の調整、または右カラム削除）。
- ナビ整理: デッドリンクの `Ride Notes`(`#`) を `#map` に向ける（任意・推奨）。
- アクセシビリティ: 各 inline SVG に `role="img"` と `aria-label`（例「自転車で走った都道府県の地図。27/47。」）。装飾境界は `aria-hidden` 不要だが、color のみに依存しないようカウントを併記。

## データ・段取り（2 フェーズ）

- **Phase 1（エクスポート待ちでも着手可）**: 地図 SVG とセクション/CSS を実装。塗りは note 由来の暫定（福島=JP-07、長野=JP-20、南アフリカ=ZA など）で仮表示し、`figcaption` は「集計中」または暫定値。
- **Phase 2（Strava エクスポート受領後）**: 集計スクリプトを実行→ `visited.json` → SVG の `on` クラスとカウントを実値へ差し替え→再デプロイ。

### Strava 一括エクスポート手順（ユーザー作業）
Strava → 設定 → マイアカウント → 「アカウントのデータをエクスポート」→ アーカイブをリクエスト。数時間後にメールで zip が届く。`activities/` フォルダを渡す（または zip パスを共有）。

## ライセンス・著作権

- 世界地図: Natural Earth（パブリックドメイン）。
- 日本地図: パブリックドメイン/CC0 の都道府県境界（出典明記。例: Natural Earth admin-1、または CC0 公開の日本 GeoJSON）。
- 採用前に各データのライセンスを確認し、必要なら出典を README に明記。`_portal/`（社内）は対象外。

## スコープ外（YAGNI）

- ホバー툴 tip・ズーム・クリック等の対話機能（零依存方針優先）。
- 走行ルートの線描画（塗り分けのみ）。
- 自動更新（当面は手動再集計＋再デプロイ。将来 Strava API 自動化は別タスク）。

## 検証

1. 集計スクリプト: 小さな GPX サンプルで `visited.json` が妥当（既知の都道府県/国が出る）かをユニット確認。
2. 表示: `python3 -m http.server` ＋ ヘッドレス Chrome で日本/世界地図の塗り・カウント・横並び→縦積み（狭幅）・配色（さび朱）を目視。
3. 本番: `wrangler pages deploy` 後、`nyaion.tech` で地図表示と崩れがないこと、旧「Data」が消えていることを確認。
