# X11のForwardingサンプル

## 概要

sshで接続したサーバ上にあるDockerコンテナ上で動くX11のGUIアプリを、接続元のローカル端末で表示するための手順です。  

## 検証環境

### ローカル端末

- OS： Windows11
- sshクライアント（下記のいずれも確認）
  - OpenSSH + コマンドプロンプト
  - OpenSSH + PowerShell
  - VS Code + Extension(Remote SSH)
- X Server: VcXsrv

### ssh接続先サーバ

- OS: Ubuntu22.04
- Docker: 28.3.1

## ステップ１（ssh接続先のX11 GUIアプリの表示）

Dockerコンテナ上で動くX11のGUIアプリの表示の前に、まずはssh接続したサーバ上のX11のGUIアプリをローカル端末に表示できるようにします。

ポイントは以下の通りです。

- ssh接続においてX11のフォワード設定を行う。
- X11の表示ディスプレイの設定ため、環境変数設定を行う。
- ローカル端末（sshの接続元）でX11のWindow表示を行うため、「VcXsrv」をインストールする。

### 手順

1. ローカル端末（sshの接続元）のssh設定（~/.ssh/config）にX11の転送設定を入れる。

    - 設定する内容は以下の通り。

        ```yaml
        　　ForwardAgent yes
            ForwardX11 yes
            ForwardX11Trusted yes
            ForwardX11Timeout 596h
        ```

    - 全体の設定例は以下の通り。

        ```yaml
        Host hoge
            User fuga
            IdentityFile ~/.ssh/piyo

            ForwardAgent yes
            ForwardX11 yes
            ForwardX11Trusted yes
            ForwardX11Timeout 596h
        ```

2. ローカル端末（sshの接続元）に環境変数を設定する。

    ```bat
    DISPLAY=localhost:0.0
    ```

3. [VcXsrv](https://sourceforge.net/projects/vcxsrv)をインストールする。

4. VcXsrvを起動する。

5. ssh接続先サーバにsshする。

6. ssh接続先サーバでssh先でGUIアプリを起動し、ローカル端末に表示（転送）されることを確認する。

    ```sh
    xeyes
    ```

## ステップ２（ssh接続先のDockerコンテナのX11 GUIアプリの表示）

続いて、ssh接続先のDockerコンテナ上のX11 GUIアプリをローカル端末（sshの接続元）で表示できるようにします。

ポイントはDockerコンテナ起動時の設定で、以下の通りです。

- ネットワークをホストにする。
- 環境変数にDISPLAYを設定する。値はDockerホスト（ssh接続先サーバ）の環境変数のDISPLAYの値。
- ~/.XauthorityをDockerホスト（ssh接続先サーバ）の.Xauthorityとマウントする。

### DockerComposeの設定

```yaml
services:
  ubuntu:
    build:
      context: ./
      dockerfile: Dockerfile
      args:
        USER_NAME: ${USER_NAME}
        USER_UID: ${HOST_UID}
        USER_GID: ${HOST_GID}
    container_name: x11-forwarding-simple-example
    user: "${HOST_UID}:${HOST_GID}"
    network_mode: host # ネットワークモードをhostに設定
    environment:
      - DISPLAY=${DISPLAY} # Dockerホスト(ssh接続先サーバ)の環境変数値と同期
    volumes:
      - ~/.Xauthority:/home/developer/.Xauthority # Dockerホスト(ssh接続先サーバ)のファイルをマウント
    init: true
    command: sleep infinity
```

### サンプル

#### xeyesの実行

Dockerfileおよびdocker-compose.yamlのサンプルは[./examples/simple](./examples/simple)にあります。

確認手順は以下の通りです。

```sh
# 環境変数ファイル（ユーザID等）の作成
./env.sh

# イメージのビルド、起動、x11アプリの実行
./start.sh
```

#### playwrightのuiモードの実行

Dockerfileおよびdocker-compose.yamlのサンプルは[./examples/playwright](./examples/playwright)にあります。

確認手順は以下の通りです。

```sh
# 環境変数ファイル（ユーザID等）の作成
./env.sh

# イメージのビルド、起動、x11アプリの実行
./start.sh
```
