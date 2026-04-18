# Gemini 画像生成 指示書
## LP用画像 ①〜③

**対象モデル**: Gemini 2.0 Pro（Imagen 3 経由）  
**使用方法**: [gemini.google.com](https://gemini.google.com) を開き、下記プロンプトをそのまま貼り付けて送信

> **注意**: 画像生成には Gemini Advanced（有料プラン）が必要な場合があります。

---

## ① ヒーロー メインビジュアル

**配置場所**: ヒーローセクション右側（テキストの横）  
**用途**: LPの第一印象を決める最重要ビジュアル  
**推奨サイズ**: 縦長 9:16 または正方形 1:1

### Gemini プロンプト（英語）

```
A slim, healthy and confident Japanese woman in her 30s, 
standing in a bright and airy studio with soft natural light. 
She is smiling warmly, wearing stylish pastel athletic wear 
in light pink or white. Full body shot. 
The background is clean white or very light pink with subtle bokeh. 
The overall mood is feminine, uplifting, and aspirational. 
High quality, photorealistic, magazine-style photography. 
No text, no watermarks.
```

### 日本語メモ

- モデルは日本人女性（30代）を指定
- 服装はパステルピンク or ホワイトのスポーツウェア
- 背景は白 or 薄ピンクでLP背景色と馴染むように
- 生成後、LP右側に配置し `border-radius` で角丸処理を推奨

---

## ② ビフォーアフター 追加写真

**配置場所**: お客様の声セクション（既存写真の横に並べる）  
**用途**: 実績の説得力を高める複数枚展示  
**推奨サイズ**: 正方形 1:1

> ⚠️ **重要**: AIは体型変化の直接的なビフォーアフター画像を生成できない場合があります（コンテンツポリシー）。  
> 代替として「ライフスタイルの変化」を表現する2枚組で代用することを推奨します。

### Gemini プロンプト A（ビフォー：悩んでいる様子）

```
A Japanese woman in her 30s sitting on a couch at home, 
looking slightly tired and unhappy, wearing casual loose-fitting clothes. 
Soft indoor lighting, natural and realistic. 
The mood is a little heavy and sluggish, representing the "before" 
state of a lifestyle change journey. 
Photorealistic, no text, no watermarks.
```

### Gemini プロンプト B（アフター：自信に満ちた様子）

```
A slim and confident Japanese woman in her 30s, 
smiling brightly in a modern bright room or outdoors in soft sunlight. 
She is wearing stylish casual clothes that fit her well, 
looking energetic and happy. 
The mood is light, joyful, and empowering, representing 
the "after" state of a successful lifestyle transformation. 
High quality photorealistic, magazine-style, no text, no watermarks.
```

### 日本語メモ

- A・B を横並びに配置し、矢印（→）で変化を表現
- 実際のビフォーアフター写真（既存の `LINE_ALBUM_...jpg`）と組み合わせて3枚構成にすると効果的
- 顔が映る場合は掲載前にお客様の許可を確認

---

## ③ CTAバナー 背景画像

**配置場所**: CTAバナーセクション全幅背景  
**用途**: 申し込み意欲を高める感情的なビジュアル  
**推奨サイズ**: 横長 16:9 または 3:1

### Gemini プロンプト（英語）

```
A beautiful and happy Japanese woman in her 30s, 
laughing joyfully with her eyes slightly closed, 
shot from the shoulders up. 
She has a healthy glowing skin and a radiant smile. 
The background is a soft, dark gradient 
(deep plum purple to dark rose, similar to #2B1B2E to #3D1B30). 
Low-key cinematic lighting with a warm pink rim light on her face. 
The mood is triumphant, emotional, and aspirational. 
High quality, photorealistic, cinematic photography. 
No text, no watermarks.
```

### 日本語メモ

- 背景色はLPのCTAセクション色（`#2B1B2E`〜`#3D1B30`）に合わせて暗めに指定済み
- 生成後、CSS で `background-image` に設定し `opacity: 0.3〜0.4` の半透明オーバーレイを重ねる
- テキストの可読性確保のため、明るすぎる画像は避ける

---

## 共通設定・注意事項

| 項目 | 推奨値 |
|------|-------|
| 出力解像度 | 1024px 以上 |
| ファイル形式 | JPG（写真）/ PNG（透過が必要な場合） |
| 保存先 | `デスクトップ/Claude/LP/image/` |

### 再生成のコツ

- 思い通りの結果が出ない場合は末尾に `--v2` や `highly detailed, 8K` を追加
- 人種を明確にしたい場合は `Japanese` を `East Asian` に変更して試す
- 背景を変えたい場合は `background is ...` の部分だけ書き換える

---

*作成日: 2026-04-14*
