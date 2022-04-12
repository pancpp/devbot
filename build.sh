#!/bin/bash

set -euo pipefail

TOP_DIR="$(realpath "$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)")"
cd "${TOP_DIR}"

docker build -t pancpp/devbot:latest .
