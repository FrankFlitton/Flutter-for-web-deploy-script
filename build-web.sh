#!/bin/bash

##################################################
#                                                #
# Flutter For Web Build Pipeline                 #
#                                                #
# Place this file next to your pubspec.yaml file #
#                                                #
##################################################

# Reminder to check for updates to the build script.
# Flutter for web is still in beta so expect updates!

CURRENT_VERSION=1.0.1
REMOTE_URL="https://github.com/FrankFlitton/Flutter-for-web-deploy-script"
REMOTE_TAGS="$(git ls-remote --tags $REMOTE_URL)"

REMOTE_HASHES=()
REMOTE_VERSIONS=()

REMOTE_REF_COUNTER=0
for GIT_META in $REMOTE_TAGS; do
  if (($REMOTE_REF_COUNTER % 2)); then
    REMOTE_HASHES+=(
      $(echo $GIT_META | cut -d "/" -f 3)
    )
  fi
  REMOTE_REF_COUNTER=$(($COUNTER + 1))
done

REMOTE_VERSION=${REMOTE_HASHES[((${#REMOTE_HASHES[@]} - 1))]}

vercomp() {
  if [[ $1 == $2 ]]; then
    return 0
  fi
  local IFS=.
  local i ver1=($1) ver2=($2)
  # fill empty fields in ver1 with zeros
  for ((i = ${#ver1[@]}; i < ${#ver2[@]}; i++)); do
    ver1[i]=0
  done
  for ((i = 0; i < ${#ver1[@]}; i++)); do
    if [[ -z ${ver2[i]} ]]; then
      # fill empty fields in ver2 with zeros
      ver2[i]=0
    fi
    if ((10#${ver1[i]} > 10#${ver2[i]})); then
      return 1
    fi
    if ((10#${ver1[i]} < 10#${ver2[i]})); then
      return 2
    fi
  done
  return 0
}

# Display update prompt

UPDATE_PROMPT="🎉🦋 A new version of Flutter For Web Build Script is availible!
\nInstalled: $CURRENT_VERSION. Current: $REMOTE_VERSION.
\nVisit https://github.com/FrankFlitton/Flutter-for-web-deploy-script to update.\n"
NO_UPDATE_PROMPT="👍 You are on the latest version of Flutter For Web Build Script. \n Beginning build now...\n"
vercomp $CURRENT_VERSION $REMOTE_VERSION && echo $NO_UPDATE_PROMPT || echo $UPDATE_PROMPT

# Begin to build the app for prod

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
  git pull --ff-only && cd ..
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

echo "🚚🖼 Copying graphic assets to their expected folders"
cp -R $APP_DIR/build/web/assets/. $APP_DIR/build/web/

echo "✅🦋 Flutter for web build pipeline complete!"
