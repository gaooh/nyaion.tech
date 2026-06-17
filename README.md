# nyaiontech ポータル（BASE / 秘密基地版・静的サイト）

屋号 **nyaiontech** の公開ポータル。Claude Design のハンドオフ「nyaiontech Portal - Base.dc.html」を、依存ゼロの静的 HTML/CSS として再現したもの。

- 要件・IA・ワイヤー仕様の正本: [`docs/requirements-2026-06.md`](docs/requirements-2026-06.md)
- デザイン出典: 採用案「**Base（秘密基地）**」（クラフト紙の地＋ドットパターン／ブランドブルー `#2563EB` を主アクセント、さび朱 `#c1492f` を基地スタンプの第2アクセント／Two-tone ロゴ `nyaion/tech`（ロゴタイプ Rubik Bold ／ `nyaion` 濃紺 `#111827`・`/tech` ブランドブルー `#2563EB`）＋耳欠け「n」モノグラム ＋ `BASE` ステンシルタグ）
- 旧「Research Lab」版から差し替え済み（基地＝ワークショップのメタファ、青写真パネル、ステンシルの番号表記）

## 構成

| ファイル | 役割 |
|---|---|
| `index.html` | 1 ページのポータル本体（Header / Hero=トラックからブルベまで、CSSから物理サーバまで。＋青写真パネル / Workshop=つくっているもの / Logbook=作業ノート / About=基地主について / Footer） |
| `styles.css` | デザイントークン（CSS 変数）＋各セクション。`style-hover` 等の Design Component 独自記法は実 CSS の `:hover` に変換済み |

ビルド不要。ブラウザで `index.html` を開けば表示できる。フォントは Google Fonts（Rubik〔ロゴタイプ〕 / Space Grotesk / Noto Sans JP / Zen Kaku Gothic New / Space Mono / Caveat / Stardos Stencil）。

## ローカルプレビュー

```bash
# このディレクトリで簡易サーバを起動
python3 -m http.server 8787
# → http://localhost:8787/
```

## 実装メモ（プロトタイプからの差分・意図）

- **アクセント色**: 主アクセントはブランド指定の Tech ブルー `#2563EB`（`styles.css` の `--accent`）。第2アクセントの「基地スタンプ」さび朱 `#c1492f` は `--stamp` で集約し、Hero/セクション見出しの角印・`BASE` タグ・設計図スタンプ・更新バーのタグに使う。
- **地のパターン**: クラフト紙色 `#e7ddc9` に `radial-gradient` の 5px ドット（`--bg-dot`）を敷く。
- **青写真パネル（設計図）**: ダーク紺 `#15233f` ＋方眼の格子、わずかな回転とマスキングテープ風の装飾で「設計図」を表現。Plan/Actual → Better Performance → Result/Experience の図と `Record → Review → Improve` のフロー。
- **見出し／タグライン**: H1 は「トラックからブルベまで、CSSから物理サーバまで。」（自転車の多分野 × コードの多レイヤーの幅広さ＝つくり手 gaooh の bio「幅広さがモットー」を前面化）。タグライン（`.tagline`）は英語 `Whatever looks fun, I ride it as far as it goes.`（おもしろそうなものに手を出して行けるところまで行く、という好奇心・遊び心）。「持久系の道具」「基地」という語は前面に出さない方針（基地感は青写真パネル／`BASE No.01`／モノグラムで醸す）。英語片は `lang="en"` を付与。
- **画像スロット**: Design Component の `image-slot` は、暗色の差し替え用プレースホルダ（`.slot`）に置換。ロゴ／顔写真／フッターのシルエットは、実素材ができたら `<div class="slot ...">` を `<img>` に差し替える。Beaconlog アイコンは差し替え済み（`brand/beaconlog-icon.png`）。
- **favicon**: 耳欠け「n」モノグラム（01案）を inline SVG で設定。ヘッダーの `.monogram-mark` と同一パス。
- **月／肉球アイコン**: 単純な円形・角丸の CSS シェイプのみで構成（複雑な手描き SVG は作らない方針）。

## 表現ガード（[requirements §3.5](docs/requirements-2026-06.md) 準拠）

Beaconlog 関連の文言はプロトタイプ時点で禁則を回避済み。編集時も以下を厳守する。

- 禁則の言い換え例: 「失敗を防ぐ／減らす」→「前回の補給を見返せます」、「改善サイクル」→「ふりかえり」、実在大会名→「次のロングライド 出場準備」
- 未 shipped 機能（横断集計・CSV・連携・英語 UI 等）を現在形で書かない
- ブランド名は `Beaconlog` 1 語に統一

## 実データ／サンプルの別

**実データに差し替え済み（2026-06）**:

- ソーシャルリンク: X（個人）`https://x.com/gaooh`、note `https://note.com/gaooh`、Substack `https://gaooh.substack.com/`、GitHub `https://github.com/gaooh`
- Beaconlog アイコン: App Store 公式アイコン（512px）を `brand/beaconlog-icon.png` に取得して使用
- 作業ノート（Logbook）と Hero の更新バー: `note.com/gaooh` の **RSS 最新記事**を手動スナップショットしたもの（新しい順 5 本）。**記事を追加したら本 HTML も手動更新が必要**（将来は RSS 取り込みの自動化余地あり）。
- 個人発信（note/Substack/X 個人）の実体は別リポ `gaooh/skogkatt` 管轄。本ポータルは外部リンクするだけ。

**まだサンプル（公開前に差し替え推奨）**:

- プロフィール顔写真・ロゴ・フッターのシルエット（画像スロット）と favicon
- 「Keeper of Rest」「Cat Log」の公開可否・名称

## Map セクション（走った場所のコロプレス地図）

About 直下の `#map` セクション。旧「Data (2024)」ブロックを置き換えたもの。自転車で走った都道府県（日本）と国（世界）をさび朱で塗り分ける。ナビ「Ride Notes」は `#map` に向けている。

- **地図データ**: Natural Earth Vector（**パブリックドメイン**）。世界＝`ne_110m_admin_0_countries`、日本都道府県＝`ne_10m_admin_1_states_provinces`（`iso_3166_2` = `JP-01`…`JP-47`）。各 `<path>` の `id` は ISO コード、走った地域に `class="on"`。
- **集計結果（正本）**: [`visited.json`](visited.json)。Strava 一括エクスポートの全ライド（バーチャルライド除く）を点-in-ポリゴン集計したもの。地域コードとカウントのみ（生 GPS はプライバシー上コミットしない）。
- **現状（2026-06、Strava 集計済み）**: 自転車で走った **26 / 47 都道府県**、**4 の国・地域**（日本・韓国・シンガポール・南アフリカ）。
  - 注: シンガポール（SG）は Natural Earth 110m にポリゴンが無く、Strava 集計では隣接する MY に落ちていた。実際は SG のみのため手動補正し、SG ポリゴンは 50m から同投影で生成して `#SG` を点灯（`visited.json` の `world` も SG に修正）。
- **生成・集計スクリプト**: `~/.config/crew/work/portal-ride-map/`（中央venv・g-work-script 規約）。3 モード。
  - 集計（増分キャッシュ）: `cd ~/.config/crew/work/portal-ride-map && just run aggregate --export <Export.zip> --out ./out`
    - `activities.csv` の「アクティビティタイプ」でライドのみ抽出。`.fit/.fit.gz/.gpx/.gpx.gz/.tcx/.tcx.gz` 対応。
    - 解析結果はアクティビティ単位で `cache/activities.json`（リポ外）に保存し、再実行時はファイルサイズ一致の既知分をスキップ（全件再スキャンを避ける）。`--force` で全件再解析。
    - 出力 `out/visited.json`（`{jp, world, counts}`）。
  - SVG 生成: `just run gen-svg --out ./out --visited "$(python3 -c 'import json;d=json.load(open("out/visited.json"));print(",".join(d["jp"]+d["world"]))')"`
  - 焼き込み（冪等）: `just run bake --html <この index.html の絶対パス> --svg-dir ./out`（2 つの `map-svg`・`map-count`・`map-note` を置換。実行時 JS ゼロ）。
- 設計は [`docs/map-section-2026-06-design.md`](docs/map-section-2026-06-design.md)。更新時は上記 3 コマンド（aggregate → gen-svg → bake）を順に実行し、commit/push すれば Git 連携で自動再デプロイされる。

## デプロイ / 公開状況

- 本リポ（`gaooh/nyaion.tech`）は **Cloudflare Pages の Git 連携**で配信する。`main` への push で自動ビルド/デプロイされる（ビルド不要・出力ディレクトリ `/`）。
- 公開用 Cloudflare Pages プロジェクト: `nyaion-tech`（**Access なしの一般公開**。社内 `_portal/` の `nyaiontech-portal` とは別物）
- カスタムドメイン `nyaion.tech`（apex）。接続・付け替えはダッシュボード手動作業。手順とフォールバック（`deploy.sh` / `wrangler`）は [`docs/DEPLOY.md`](docs/DEPLOY.md) を参照。
- 注意: 出力ディレクトリが `/` のため、`docs/` やリポメタ（README 等）も公開ドメインから取得可能になる。公開したくない素材を `docs/` に置かない。

## 関連の確認待ち（要件 §7）

実装リポの最終的な置き場、ドメイン `nyaion.tech` の割当などは要件ドキュメントの保留事項を参照。
