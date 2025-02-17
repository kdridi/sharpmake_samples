#!/usr/bin/env bash

set -e

cd $(dirname $0)
PROJECT_NAME=$(basename $(pwd))

cd ..
ROOT_DIR=$(pwd)

TMP_DIR=$ROOT_DIR/tmp
mkdir -p $TMP_DIR

PROJECT_DIR=$ROOT_DIR/$PROJECT_NAME

echo "ROOT_DIR: $ROOT_DIR"
echo "PROJECT_NAME: $PROJECT_NAME"
echo "PROJECT_DIR: $PROJECT_DIR"
echo "TMP_DIR: $TMP_DIR"

SHARPMAKE_PLATFORM=Linux
SHARPMAKE_VERSION=0.76.0
SHARPMAKE_ENGINE=net6.0

cd $TMP_DIR
if [ ! -d sharpmake ]; then
    wget -c "https://github.com/ubisoft/Sharpmake/releases/download/${SHARPMAKE_VERSION}/Sharpmake-${SHARPMAKE_ENGINE}-${SHARPMAKE_PLATFORM}-${SHARPMAKE_VERSION}.zip"
    mkdir -p sharpmake
    unzip Sharpmake-${SHARPMAKE_ENGINE}-${SHARPMAKE_PLATFORM}-${SHARPMAKE_VERSION}.zip -d sharpmake
    chmod a+x sharpmake/Sharpmake.Application
    rm Sharpmake-${SHARPMAKE_ENGINE}-${SHARPMAKE_PLATFORM}-${SHARPMAKE_VERSION}.zip
fi
SHARPMAKE_BIN=$TMP_DIR/sharpmake/Sharpmake.Application

cd $PROJECT_DIR
$SHARPMAKE_BIN  "/sources(@'main.sharpmake.cs')"

make -C generated/Linux/make -f basics.make
bin/Linux/Debug/basics

rm -rf generated bin