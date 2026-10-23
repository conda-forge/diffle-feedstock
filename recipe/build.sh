#!/usr/bin/env bash
set -euxo pipefail

# The Rust binary embeds the web client from dist/client
npm ci --ignore-scripts
npm run build

export CARGO_PROFILE_RELEASE_STRIP=symbols
export CARGO_PROFILE_RELEASE_LTO=fat

if [[ "${target_platform}" == "linux-ppc64le" ]]; then
  # rustc links with rust-lld, which can't handle the inline PLT relocations GCC emits with -fno-plt on ppc64le
  export CFLAGS="${CFLAGS//-fno-plt/}"
fi

cargo auditable install --locked --no-track --bins --root "${PREFIX}" --path crates/diffle
cargo-bundle-licenses --format yaml --output THIRDPARTY.yml

# Pixi: prevent CONDA_PREFIX from leaking into sandboxed processes
mkdir -p "${PREFIX}/etc/pixi/diffle"
touch "${PREFIX}/etc/pixi/diffle/global-ignore-conda-prefix"

mkdir -p $PREFIX/share/zsh/site-functions $PREFIX/share/bash-completion/completions $PREFIX/share/fish/vendor_completions.d
# When cross-compiling, run the target binary through the emulator
${CROSSCOMPILING_EMULATOR:-} $PREFIX/bin/diffle completion --shell zsh > $PREFIX/share/zsh/site-functions/_diffle
${CROSSCOMPILING_EMULATOR:-} $PREFIX/bin/diffle completion --shell bash > $PREFIX/share/bash-completion/completions/diffle
${CROSSCOMPILING_EMULATOR:-} $PREFIX/bin/diffle completion --shell fish > $PREFIX/share/fish/vendor_completions.d/diffle.fish
