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

# playwright-uiの実行
docker exec x11-forwarding-playwright-example /bin/bash -c "npm ci && npm run setup && npm run test-ui"
