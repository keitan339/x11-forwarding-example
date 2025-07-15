FROM ubuntu:22.04

ARG USER_NAME
ARG USER_UID
ARG USER_GID

# 検証用のX11アプリをインストール
RUN apt-get update -y\
    && apt-get install x11-apps -y

# 非rootユーザーの作成と設定
RUN if [ -z "${USER_NAME}" ] || [ -z "${USER_UID}" ] || [ -z "${USER_GID}" ]; then \
        echo "Error: USER_NAME and USER_UID and USER_GID must be set" && exit 1; \
    fi \
    && groupadd --gid ${USER_GID} ${USER_NAME} \
    && useradd --uid ${USER_UID} --gid ${USER_GID} -m ${USER_NAME} --shell /bin/bash

# 開発ユーザでの作業
USER ${USER_NAME}