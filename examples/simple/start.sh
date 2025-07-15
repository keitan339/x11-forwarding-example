#!/bin/bash

# このスクリプトが存在するディレクトリに移動する
cd "$(dirname "$0")"

# すでに同名のコンテナがあれば削除する
if [ -n "$(docker-compose ps -q)" ]; then
  docker-compose down
fi

# コンテナイメージのビルド
docker-compose build

# コンテナの起動
docker-compose up -d

# xeyesの実行
docker exec x11-forwarding-simple-example xeyes
