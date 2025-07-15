#!/bin/bash

# このスクリプトが存在するディレクトリに移動する
cd "$(dirname "$0")"

# .envファイルのパス
ENV_FILE=".env"

# .envファイルを初期化（すでにあれば上書き）
> "${ENV_FILE}"

# ユーザ名（固定）
export USER_NAME=developer

# 展開する環境変数を書き込み
echo "USER_NAME=${USER_NAME}" >> "${ENV_FILE}"
echo "HOST_UID=$(id -u)" >> "${ENV_FILE}"
echo "HOST_GID=$(id -g)" >> "${ENV_FILE}"
