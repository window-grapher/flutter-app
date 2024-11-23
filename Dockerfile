# ベースイメージ
FROM ubuntu:22.04

# 環境変数の設定
ENV DEBIAN_FRONTEND=noninteractive
ENV JAVA_HOME=/usr/lib/jvm/java-19-openjdk-amd64
ENV PATH="$JAVA_HOME/bin:/opt/flutter/bin:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$PATH"
ENV ANDROID_HOME=/opt/android-sdk
ENV FLUTTER_GIT_URL=https://github.com/flutter/flutter.git

# Combine PATH environment variables
ENV PATH="$JAVA_HOME/bin:/opt/flutter/bin:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$PATH"

# 必要なパッケージをインストール
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    git \
    unzip \
    zip \
    openjdk-19-jdk \
    wget \
    ca-certificates \
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
    gnupg \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Chrome installation
RUN wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | gpg --dearmor -o /usr/share/keyrings/google-chrome.gpg \
    && echo "deb [arch=amd64 signed-by=/usr/share/keyrings/google-chrome.gpg] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list \
    && apt-get update \
    && apt-get install -y google-chrome-stable \
    && rm -rf /var/lib/apt/lists/*

# Javaのバージョン確認
RUN java -version

# Install Flutter from stable channel
RUN git clone https://github.com/flutter/flutter.git /opt/flutter \
    && cd /opt/flutter \
    && git config --global --add safe.directory /opt/flutter \
    && flutter channel stable \
    && flutter upgrade \
    && flutter --version \
    && ln -s /opt/flutter/bin/* /usr/local/bin/

# Set correct permissions and ownership
RUN chown -R root:root /opt/flutter \
    && chmod -R 755 /opt/flutter

# Flutterバージョン確認
RUN flutter --version

# Android SDKのインストール
RUN mkdir -p $ANDROID_HOME/cmdline-tools && \
    wget https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip -O /cmdline-tools.zip && \
    unzip /cmdline-tools.zip -d $ANDROID_HOME/cmdline-tools && \
    mv $ANDROID_HOME/cmdline-tools/cmdline-tools $ANDROID_HOME/cmdline-tools/latest && \
    rm /cmdline-tools.zip

# SDKと必要なツールのインストール
RUN yes | sdkmanager --licenses && \
    sdkmanager "platform-tools" "platforms;android-34" "build-tools;34.0.0"

# Switch Flutter to stable channel and upgrade
RUN flutter channel stable && flutter upgrade

# Create necessary directories and set up user
RUN mkdir -p /app /home/flutter \
    && groupadd -r flutter \
    && useradd --no-log-init -r -g flutter flutter \
    && chown -R flutter:flutter /home/flutter \
    && chown -R flutter:flutter /app \
    && chown -R flutter:flutter /opt/flutter \
    && chmod -R 755 /opt/flutter

# Set Git configurations for flutter user
USER flutter
RUN git config --global --add safe.directory /opt/flutter

# Set working directory
WORKDIR /app

# Initialize Flutter project with proper permissions
RUN flutter doctor \
    && flutter create . \
    && flutter pub get

# Switch back to root for any remaining setup
USER root

# デフォルトコマンド
CMD ["bash"]
