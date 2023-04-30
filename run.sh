#!/bin/sh

set -e

echo "Downloading model(s)"
python3 download_models.py

echo "Building app..."
cd /build && make build

echo "Running local-ai on port 8080 ..."
/local-ai "$@" 2>&1 | logger -t local-ai
