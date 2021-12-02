#!/usr/bin/env bash

ROOT_DIR=${0%/*}
TMP_DIR="$ROOT_DIR/tmp"
JS_WAKU_DIR="$TMP_DIR/js-waku"
JS_WAKU_DOC_DIR="$TMP_DIR/js-waku/build/docs"

echo "ROOT_DIR: $ROOT_DIR"
echo "TMP_DIR: $TMP_DIR"
echo "JS_WAKU_DIR: $JS_WAKU_DIR"
echo "JS_WAKU_DOC_DIR: $JS_WAKU_DOC_DIR"

if ! [[ -d "$TMP_DIR" ]]; then
  mkdir "$TMP_DIR"
fi
cd "$TMP_DIR" || exit 1

if ! [[ -d "js-waku" ]]; then
  git clone https://github.com/status-im/js-waku.git
fi

cd "$JS_WAKU_DIR" || exit 1
LATEST_TAG=$(git describe --abbrev=0 --tag | tr -d '\n')

if [[ -z "$LATEST_TAG" ]]; then
  echo "Issue retrieving latest js-waku tag"
  exit 1
fi

JS_WAKU_TARGET_DIR="$ROOT_DIR/src/api/js-waku/$LATEST_TAG"
echo "JS_WAKU_TARGET_DIR: $JS_WAKU_TARGET_DIR"

if [[ -d "$JS_WAKU_TARGET_DIR" ]]; then
  echo "Documentation for 'js-waku@$LATEST_TAG' is already present, skipping retrieval"
else
  echo "Retrieving documentation for 'js-waku@$LATEST_TAG'"

  git checkout "$LATEST_TAG" || echo "Failed to checkout $LATEST_TAG"

  npm install || echo "Failed to run npm install"

  # Make typedoc generate markdown files
  npm add --save-dev typedoc-plugin-markdown || echo "Failed to install typedoc-plugin-markdown"
  npm run doc:html || echo "Failed to generate docs"

  if ! [[ -d "$JS_WAKU_DOC_DIR" ]]; then
    echo "$JS_WAKU_DOC_DIR is missing"
    exit 1
  fi

  cp -Rp "$JS_WAKU_DOC_DIR" "$JS_WAKU_TARGET_DIR"
fi

# Need to index all files in SUMMARY.md
# Use the command below to print and then copy a pre-formatted list

echo "-----------------------------------------------------------------------------------"
echo "### All files must be referenced in SUMMARY.md to be present in the generated HTML"
echo "### The output below lists all the files, you may need to add a number of README.md"
echo "### at the root of all directories."
echo ""

cd "$ROOT_DIR/src/" || exit 1
find "api/js-waku/$LATEST_TAG" | sed -r 's/^(.*\/)([a-zA-Z._]+)\.md$/- [\2](\1\2.md)/'
