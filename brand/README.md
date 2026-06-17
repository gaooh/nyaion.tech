# nyaiontech ブランドアセット

[Logo Specification v1.0] を元に手作業でベクター化したロゴ一式（画像生成 AI の再解釈は不使用）。

## ファイル

| ファイル | 用途 |
|---|---|
| `icon.svg` | モノグラム単体（インク `#111827`・透明背景）。明色面向け。 |
| `icon-white.svg` | モノグラム単体（白）。暗色面向け。 |
| `icon-tile.svg` | 角丸タイル（`#111827`）＋白モノグラム。アプリアイコン／favicon ソース。 |
| `logo.svg` | プライマリ横組み（ライト）。`nyaion`＝`#111827` ／ `/`＝カーブ・スラッシュ `#2563EB` ／ `tech`＝`#2563EB`。 |
| `logo-dark.svg` | プライマリ横組み（ダーク）。背景 `#111827` ／ 文字 `#ffffff` ／ `tech`・スラッシュ `#4F8CFF`。 |
| `ogp.html` | SNS 共有画像（OGP 1200×630）のソース。クラフト紙地＋ドットに `logo.svg` を中央配置。`logo.svg` を更新したらインライン SVG を同期する。 |
| `ogp.png` | `ogp.html` をレンダリングした実画像。`../index.html` の `og:image` / `twitter:image` が参照する。 |

## OGP 画像（`ogp.png`）の再生成

`ogp.html` を編集したら、headless Chrome で 1200×630 に焼き直す（`brand/` ディレクトリで実行）。

```sh
"/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" \
  --headless=new --disable-gpu --hide-scrollbars \
  --force-device-scale-factor=1 --window-size=1200,630 \
  --screenshot="$(pwd)/ogp.png" "file://$(pwd)/ogp.html"
# 寸法確認: sips -g pixelWidth -g pixelHeight ogp.png → 1200 × 630
```

> SNS 側はスクレイプ結果を独自キャッシュするため、差し替え後は各 SNS のデバッガ（X Card Validator / Facebook Sharing Debugger 等）で再取得させるか、`og:image` URL に `?v=YYYYMMDD` を付ける。

サイトのヘッダー／favicon はこのモノグラム（S・小さい耳版）を直接インライン使用している（`../index.html`）。

## モノグラム

小文字 `n` の幾何形状（uniform stroke・rounded inner arch）。左の縦線は full のまま（n 感を保つ）、
**左上から小さな耳を外へちょこっと出す**（`S`）。猫耳の連想は控えめで主役にしない。
（初期案の「内側に切り欠く notch」は n 感が落ちたため、外へ出す小さな耳に変更。）

- パス（viewBox `0 0 64 64`）:
  `M15 49 L15 23 L13.5 14 L22 19 C30 12 42 14 49 26 L49 49 L37 49 L37 27 A5 5 0 0 0 27 27 L27 49 Z`

## ロゴタイプ

- テキスト: `nyaion/tech`
- フォント: **Rubik Bold**（少し角丸・強さ・テック感）。配布時は Figma でアウトライン化する。
- スラッシュ: 通常の `/` ではなく 5〜10% 程度のわずかなカーブ（抽象的な尻尾）。大きな曲線・装飾・手書き風は不可。
  サイトでは `.w-slash`（インライン SVG・stroke `#2563EB`）として実装。

## カラー

| 役割 | 値 |
|---|---|
| ink（nyaion・モノグラム） | `#111827` |
| accent（tech・スラッシュ／ライト） | `#2563EB` |
| accent（tech・スラッシュ／ダーク面） | `#4F8CFF` |
| dark 背景 | `#111827` |

## 設計思想

「猫ブランド」でも「研究所ブランド」でもない。持久系競技者が自分のために作った道具が結果として
プロダクトになった、静かな個人開発ブランド。猫要素は主役ではなく隠し味。
