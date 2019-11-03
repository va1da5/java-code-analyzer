#!/usr/bin/env bash


if (( $# != 3 ))
then
  echo "[?] Usage: $0 <project-path> <decompiled-code-path> <report-path>"
  exit 1
fi

PROJECT_PATH=$1
DECOMPILED_PATH=$2
REPORT_PATH=$3

if [[ ! "$1" = /* ]]; then
    PROJECT_PATH=$PWD/$1
fi

if [[ ! "$2" = /* ]]; then
    DECOMPILED_PATH=$PWD/$1
fi

if [[ ! "$3" = /* ]]; then
    REPORT_PATH=$PWD/$1
fi

docker run -it --rm \
    -v "$PROJECT_PATH":/project/src\
    -v "$DECOMPILED_PATH":/project/decompiled \
    -v "$REPORT_PATH":/project/reports \
    -e USERID=$(id -u $USER) \
    --name java-project-analysis \
    $USER/java-project-analysis:latest

