#!/usr/bin/env bash
set -euxo pipefail

npm install --global --prefix "${PREFIX}" --ignore-scripts --omit=dev --install-links .

export PNPM_CONFIG_PM_ON_FAIL=ignore
pnpm install --prod --ignore-scripts
pnpm-licenses generate-disclaimer --prod --output-file=third-party-licenses.txt

# Pixi: prevent CONDA_PREFIX from leaking into sandboxed processes
mkdir -p "${PREFIX}/etc/pixi/diffle"
touch "${PREFIX}/etc/pixi/diffle/global-ignore-conda-prefix"

mkdir -p $PREFIX/share/zsh/site-functions $PREFIX/share/bash-completion/completions $PREFIX/share/fish/vendor_completions.d
$PREFIX/bin/diffle completion --shell zsh > $PREFIX/share/zsh/site-functions/_diffle
$PREFIX/bin/diffle completion --shell bash > $PREFIX/share/bash-completion/completions/diffle
$PREFIX/bin/diffle completion --shell fish > $PREFIX/share/fish/vendor_completions.d/diffle.fish
