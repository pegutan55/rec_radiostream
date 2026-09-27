# rec_radiostream

ラジオのライブ配信を録音し、MP3 ファイルとして保存するためのシェルスクリプト。
配信は HLS (`.m3u8`) で取得し、FFmpeg で MP3 に変換する。

matchy256 さんの rec_nhk.sh をベースに
別で取得していたラジオストリームのURLを利用するように改良。
https://gist.github.com/matchy256/9515cecbea40918add594203dc61406c 

## 必要なもの

- Bash
- [FFmpeg](https://ffmpeg.org/)
- Python 3
- Python 標準ライブラリの `sqlite3` と `json`（`FM` を録音する場合のみ）

## セットアップ
別出しの `config.json` に SQLite データベースとテーブルを設定する。
ここからラジオストリームのURLを取得し、録音を行う。
`config.json` は `config.sample.json` を元に作成すること。

```sh
cp config.sample.json config.json
```

設定例:

```json
{
  "db_path": "/path/to/radiostream.sqlite3",
  "table_name": "my_table"
}
```

## 使い方

```sh
./rec_radiostream.sh <channel_name> <duration_minutes> [output_directory] [prefix]
```

| パラメーター | 説明 | 備考 |
| :--- | :--- | :--- |
| channel_name | 録音チャンネル | 下記の対応チャンネルを参照。FMを指定した場合のみ、DBよりURLを取得 |
| duration_minutes | 録音時間（分） |  |
| output_directory | 録音データの出力先ディレクトリ |  |
| prefix | 録音データに付与されるプレフィックス | aaa_2026-09-27-21_36.mp3 |


## 出力ファイル

出力ファイルは次の形式で作成される。

```text
<output_directory>/<prefix>_YYYY-MM-DD-HH_MM.mp3
```

`prefix` を省略した場合はチャンネル名が使われる。音声は MP3、ビットレートは 128 kbps です。

## 対応チャンネル

- `NHK1`, `NHK2`, `FM`
- `NHK1_SAPPORO`, `NHK2_SAPPORO`, `FM_SAPPORO`
- `NHK1_SENDAI`, `NHK2_SENDAI`, `FM_SENDAI`
- `NHK1_NAGOYA`, `NHK2_NAGOYA`, `FM_NAGOYA`
- `NHK1_OSAKA`, `NHK2_OSAKA`, `FM_OSAKA`
- `NHK1_HIROSHIMA`, `NHK2_HIROSHIMA`, `FM_IROSHIMA`
- `NHK1_MATSUYAMA`, `NHK2_MATSUYAMA`, `FM_MATSUYAMA`
- `NHK1_FUKUOKA`, `NHK2_FUKUOKA`, `FM_FUKUOKA`

チャンネル名は大文字・アンダースコアを含めて、上記の表記どおりに指定すること。

## 注意事項

- 放送局側の配信 URL が変更・終了した場合、このスクリプトでは録音できなくなることがある。
    - FMを指定した時以外は、古いURLの可能性あり
- 配信の利用や録音は、各サービスの利用規約および著作権法に従ってください。
- `config.json` には環境依存のパスが含まれるため、Git 管理対象外。共有するときは `config.sample.json` を使用すること。
