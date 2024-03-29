#!/bin/bash
set -e
# Read named command line arguments into an args variable
while getopts f:p: flag
do
    case "${flag}" in
        f) FILE=${OPTARG};;
        p) START_PATH=${OPTARG};;
    esac
done

if [ -z "$FILE" ]; then
    echo "Error: file name argument (-f or --file) is required."
    exit 1
fi

if [ ! -d "$START_PATH" ]; then
    echo "Error: starting path argument (-p or --path) is not a directory or does not exist."
    exit 1
fi

# Search for file in all parent directories recursively
CURRENT_PATH="$(readlink -f "$START_PATH")"
while [ "$CURRENT_PATH" != "/" ]; do
    RESULT="$(find "$CURRENT_PATH" -maxdepth 1 -name "$FILE" -type f -print -quit)"
    if [ -n "$RESULT" ]; then
        break
    fi
    CURRENT_PATH="$(dirname "$CURRENT_PATH")"
done

# Print search result
echo "Found the file here -> $RESULT"


echo "file_path=$(echo $RESULT)" >> $GITHUB_OUTPUT

