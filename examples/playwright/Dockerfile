FROM ubuntu:22.04

ARG USER_NAME
ARG USER_UID
ARG USER_GID

ARG NODE_VERSION=22.17.0

ENV LANG=C.UTF-8
ENV LANGUAGE=C.UTF-8
ENV LC_ALL=C.UTF-8
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Tokyo

# 日本語環境化のためのパッケージ導入
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    tzdata  \
    locales \
    && locale-gen ja_JP.UTF-8 \
    # 不要なパッケージの削除とキャッシュのクリア (イメージサイズ削減のため)
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

# 基本パッケージ導入
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    sudo \
    curl \
    wget \
    ca-certificates \
    gnupg \
    software-properties-common \
    build-essential \
    # 不要なパッケージの削除とキャッシュのクリア (イメージサイズ削減のため)
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

# NodeJSのインストール
RUN ARCH= && dpkgArch="$(dpkg --print-architecture)" \
    && case "${dpkgArch##*-}" in \
         amd64) ARCH='x64';; \
         ppc64el) ARCH='ppc64le';; \
         s390x) ARCH='s390x';; \
         arm64) ARCH='arm64';; \
         armhf) ARCH='armv7l';; \
         i386) ARCH='x86';; \
         *) echo "unsupported architecture"; exit 1 ;; \
       esac \
    && curl -fsSLO --compressed "https://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}-linux-${ARCH}.tar.xz" \
    && tar -xJf "node-v${NODE_VERSION}-linux-${ARCH}.tar.xz" -C /usr/local --strip-components=1 --no-same-owner \
    && rm node-v${NODE_VERSION}-linux-${ARCH}.tar.xz \
    && ln -s /usr/local/bin/node /usr/local/bin/nodejs

# Playwrightに必要なパッケージの導入
RUN npx -y playwright install-deps

# 利用シェルをbashに変更
RUN echo "dash dash/sh boolean false" | debconf-set-selections \
    && dpkg-reconfigure dash || true

# 非rootユーザーの作成と設定
RUN if [ -z "${USER_NAME}" ] || [ -z "${USER_UID}" ] || [ -z "${USER_GID}" ]; then \
        echo "Error: USER_NAME and USER_UID and USER_GID must be set" && exit 1; \
    fi \
    && groupadd --gid ${USER_GID} ${USER_NAME} \
    && useradd --uid ${USER_UID} --gid ${USER_GID} -m ${USER_NAME} --shell /bin/bash \
    && echo ${USER_NAME} ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/${USER_NAME} \
    && chmod 0440 /etc/sudoers.d/${USER_NAME}

# 開発ユーザでの作業
USER ${USER_NAME}

# 日本語設定
RUN echo "# ロケール設定" >> ~/.bashrc \
    && echo "export LANG=ja_JP.UTF-8" >> ~/.bashrc \
    && echo "export LC_ALL=ja_JP.UTF-8" >> ~/.bashrc \
    && echo "export LANGUAGE=ja_JP.UTF-8" >> ~/.bashrc\
    && echo "" >> ~/.bashrc

# プロンプト設定
RUN echo "# ターミナル設定" >> ~/.bashrc \
    && echo "export PS1='${debian_chroot:+($debian_chroot)}\[\033[01;34m\]\w\[\033[00m\]\$ '" >> ~/.bashrc \
    && echo "" >> ~/.bashrc

# 作業ディレクトリの設定
WORKDIR /workspace
