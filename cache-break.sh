#!/bin/bash

# Break the cache so new files are loaded by the app.
BUILD_HASH=$((1 + $RANDOM % 100000))
TARGET_FILE=".js"
HASHED_FILE=($TARGET_FILE"?"$BUILD_HASH\")
echo $HASHED_FILE
# awk '{gsub(".js", ".js?${BUILD_HASH}", $0); print}' test.html
# cat test.html | awk -v srch="$TARGET_FILE" -v repl="$HASHED_FILE" '{ sub(srch,repl,$0); print $0 }' >tmp && mv tmp test.html
