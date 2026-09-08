#!/usr/bin/env bash
set -euxo pipefail

npm install --global --prefix "${PREFIX}" --ignore-scripts --omit=dev --install-links .

export PNPM_CONFIG_PM_ON_FAIL=ignore
pnpm install --prod --ignore-scripts
pnpm-licenses generate-disclaimer --prod --output-file=third-party-licenses.txt
