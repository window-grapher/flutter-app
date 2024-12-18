FROM ubuntu:22.04

# 環境変数設定
ENV DEBIAN_FRONTEND=noninteractive
ENV ANDROID_HOME=/opt/android-sdk
ENV ANDROID_SDK_ROOT=$ANDROID_HOME
ENV FLUTTER_HOME=/opt/flutter
ENV FLUTTER_VERSION=3.24.3
ENV JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64
ENV PATH="$JAVA_HOME/bin:$FLUTTER_HOME/bin:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$PATH"

# 必要パッケージインストール
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    git \
    unzip \
    zip \
    wget \
    ca-certificates \
    gnupg \
    lsb-release \
    lib32stdc++6 \
    lib32z1 \
    clang \
    cmake \
    ninja-build \
    pkg-config \
    libgtk-3-dev \
    libblkid-dev \
    liblzma-dev \
    xz-utils \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Google Chromeのインストール
RUN wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | gpg --dearmor -o /usr/share/keyrings/google-chrome.gpg \
    && echo "deb [arch=amd64 signed-by=/usr/share/keyrings/google-chrome.gpg] http://dl.google.com/linux/chrome/deb/ stable main" \
       > /etc/apt/sources.list.d/google-chrome.list \
    && apt-get update \
    && apt-get install -y google-chrome-stable \
    && rm -rf /var/lib/apt/lists/*

# Java 21インストール
RUN apt-get update && apt-get install -y --no-install-recommends openjdk-21-jdk \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
RUN java -version

# Flutterを指定バージョンでインストール
RUN git clone https://github.com/flutter/flutter.git $FLUTTER_HOME \
    && cd $FLUTTER_HOME \
    && git fetch --tags \
    && git checkout $FLUTTER_VERSION \
    && git config --global --add safe.directory /opt/flutter \
    && flutter --version

# Android SDKコマンドラインツールのインストール
RUN mkdir -p $ANDROID_HOME/cmdline-tools && \
    wget https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip -O /cmdline-tools.zip && \
    unzip /cmdline-tools.zip -d $ANDROID_HOME/cmdline-tools && \
    mv $ANDROID_HOME/cmdline-tools/cmdline-tools $ANDROID_HOME/cmdline-tools/latest && \
    rm /cmdline-tools.zip

# SDKとビルドツールのインストール (ライセンス同意付き)
RUN yes | sdkmanager --licenses && \
    sdkmanager "platform-tools" "platforms;android-34" "build-tools;34.0.0" "platforms;android-33"

# Flutterツールセットアップ
RUN flutter precache \
    && flutter doctor -v \
    && flutter channel stable && flutter upgrade

# flutterユーザー作成
RUN groupadd -r flutter && useradd --no-log-init -r -g flutter flutter && \
    mkdir -p /app /home/flutter && \
    chown -R flutter:flutter /home/flutter /app /opt/flutter

USER flutter
WORKDIR /app

# flutter doctorとサンプルプロジェクト作成
RUN flutter doctor && \
    flutter create . && \
    flutter pub get

# rootユーザーに戻す
USER root

# デフォルトコマンド
CMD ["/bin/bash"]
