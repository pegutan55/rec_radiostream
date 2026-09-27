#!/bin/bash

pid=$$
date=`date '+%Y-%m-%d-%H_%M'`
outdir="."

if [ $# -le 1 ]; then
  echo "usage : $0 channel_name duration(minuites) [outputdir] [prefix]"
  exit 1
fi

if [ $# -ge 2 ]; then
  channel=$1
  DURATION=`expr $2 \* 60 + 15`
fi
if [ $# -ge 3 ]; then
  outdir=$3
fi
PREFIX=${channel}
if [ $# -ge 4 ]; then
  PREFIX=$4
fi

#
# set channel
#
case $channel in
  "NHK1")
    aspx="https://simul.drdi.st.nhk/live/3/joined/master.m3u8"
    ;;
  "NHK2")
    aspx="https://simul.drdi.st.nhk/live/4/joined/master.m3u8"
    ;;
  "FM")
    aspx=$(python3 - << 'EOF'
import sqlite3
import json

# 外部設定ファイルを読み込み
with open('config.json', 'r', encoding='utf-8') as f:
    config = json.load(f)

# DB接続とクエリ実行
conn = sqlite3.connect(config['db_path'])
cursor = conn.cursor()

# 例: 対象テーブルから1件取得
cursor.execute(f"SELECT name FROM {config['table_name']} WHERE id = 1")
row = cursor.fetchone()

conn.close()

# シェルに渡したい値を print で標準出力に出力する
if row:
    print(row[0])
EOF
)
    ;;
  "NHK1_SAPPORO")
    aspx="https://nhkradioikr1-i.akamaihd.net/hls/live/512098/1-r1/1-r1-01.m3u8"
    ;;
  "NHK2_SAPPORO")
    aspx="https://nhkradioakr2-i.akamaihd.net/hls/live/511929/1-r2/1-r2-01.m3u8"
    ;;
  "FM_SAPPORO")
    aspx="https://nhkradioikfm-i.akamaihd.net/hls/live/512100/1-fm/1-fm-01.m3u8"
    ;;
  "NHK1_SENDAI")
    aspx="https://nhkradiohkr1-i.akamaihd.net/hls/live/512075/1-r1/1-r1-01.m3u8"
    ;;
  "NHK2_SENDAI")
    aspx="https://nhkradioakr2-i.akamaihd.net/hls/live/511929/1-r2/1-r2-01.m3u8"
    ;;
  "FM_SENDAI")
    aspx="https://nhkradiohkfm-i.akamaihd.net/hls/live/512076/1-fm/1-fm-01.m3u8"
    ;;
  "NHK1_NAGOYA")
    aspx="https://nhkradiockr1-i.akamaihd.net/hls/live/512072/1-r1/1-r1-01.m3u8"
    ;;
  "NHK2_NAGOYA")
    aspx="https://nhkradioakr2-i.akamaihd.net/hls/live/511929/1-r2/1-r2-01.m3u8"
    ;;
  "FM_NAGOYA")
    aspx="https://nhkradiockfm-i.akamaihd.net/hls/live/512074/1-fm/1-fm-01.m3u8"
    ;;
  "NHK1_OSAKA")
    aspx="https://nhkradiobkr1-i.akamaihd.net/hls/live/512291/1-r1/1-r1-01.m3u8"
    ;;
  "NHK2_OSAKA")
    aspx="https://nhkradioakr2-i.akamaihd.net/hls/live/511929/1-r2/1-r2-01.m3u8"
    ;;
  "FM_OSAKA")
    aspx="https://nhkradiobkfm-i.akamaihd.net/hls/live/512070/1-fm/1-fm-01.m3u8"
    ;;
  "NHK1_HIROSHIMA")
    aspx="https://nhkradiofkr1-i.akamaihd.net/hls/live/512086/1-r1/1-r1-01.m3u8"
    ;;
  "NHK2_HIROSHIMA")
    aspx="https://nhkradioakr2-i.akamaihd.net/hls/live/511929/1-r2/1-r2-01.m3u8"
    ;;
  "FM_IROSHIMA")
    aspx="https://nhkradiofkfm-i.akamaihd.net/hls/live/512087/1-fm/1-fm-01.m3u8"
    ;;
  "NHK1_MATSUYAMA")
    aspx="https://nhkradiozkr1-i.akamaihd.net/hls/live/512103/1-r1/1-r1-01.m3u8"
    ;;
  "NHK2_MATSUYAMA")
    aspx="https://nhkradioakr2-i.akamaihd.net/hls/live/511929/1-r2/1-r2-01.m3u8"
    ;;
  "FM_MATSUYAMA")
    aspx="https://nhkradiozkfm-i.akamaihd.net/hls/live/512106/1-fm/1-fm-01.m3u8"
    ;;
  "NHK1_FUKUOKA")
    aspx="https://nhkradiolkr1-i.akamaihd.net/hls/live/512088/1-r1/1-r1-01.m3u8"
    ;;
  "NHK2_FUKUOKA")
    aspx="https://nhkradioakr2-i.akamaihd.net/hls/live/511929/1-r2/1-r2-01.m3u8"
    ;;
  "FM_FUKUOKA")
    aspx="https://nhkradiolkfm-i.akamaihd.net/hls/live/512097/1-fm/1-fm-01.m3u8"
    ;;
  *)
    echo "failed channel"
    exit 1
    ;;
esac

ffmpeg -loglevel quiet -y -t ${DURATION} -i ${aspx} -acodec libmp3lame -ab 128k "${outdir}/${PREFIX}_${date}.mp3"
#avconv -loglevel quiet -y -t ${DURATION} -i ${aspx} -acodec mp3 -ab 128k "${outdir}/${PREFIX}_${date}.mp3"
