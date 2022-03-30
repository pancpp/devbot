#!/bin/bash

set -euo pipefail

TOP_DIR="$( cd "$(dirname "$0")" ; pwd -P )"
cd "${TOP_DIR}"

docker build -t pancpp/devbot:latest .
