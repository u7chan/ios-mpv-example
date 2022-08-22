#!/bin/sh

if ! which mint >/dev/null; then
  echo 'warning: Mint not installed. Please install mint from https://github.com/yonaskolb/Mint'
  exit 1
fi

DST_FILE_NAME="OutputMocks.swift"
TARGET_DIR=$1

if [ -z "$TARGET_DIR" ]; then
  echo "usage: "
  echo "  arg1: <target_dir>"
  exit 1
fi

rm -f $TARGET_DIR/$DST_FILE_NAME
mint run mockolo --sourcedirs $TARGET_DIR --mock-final --destination $TARGET_DIR/$DST_FILE_NAME
