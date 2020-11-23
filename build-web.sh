#!/bin/bash

# Build pipeline for Flutter Web
# Place this file next to your pubspec.yaml file

APP_DIR="$(
  cd -P "$(dirname "${BASH_SOURCE[0]}")"
  pwd
)"

FLUTTER_DIR="${APP_DIR}/flutter"
FLUTTER_BIN="${FLUTTER_DIR}/bin/flutter"

echo "👋 Building inside of: \n    "$APP_DIR

if cd $FLUTTER_DIR; then
  echo "📦 Cahed version of Flutter Beta found!"
  echo "👀 Checking for updates..."
  git pull && cd ..
else
  echo "🦋 Download and setup Flutter Beta"
  git clone https://github.com/flutter/flutter.git

  echo "🧪 Checking out beta release for web utils"
  $FLUTTER_BIN channel beta
  $FLUTTER_BIN upgrade
  echo "✅🧪 Beta version of Flutter installed!"
fi

mkdir -p $APP_DIR/build/web/assets

echo "👷‍♀️🛠 Building Flutter app for web"
$FLUTTER_BIN config --enable-web
$FLUTTER_BIN build web --release

echo "🚚🖼 Copying graphic assets to expected folder"
cp -R $APP_DIR/assets/. $APP_DIR/build/web/assets

echo "✅🦋 Flutter for web build pipeline complete!"

