#!/bin/bash
set -euo pipefail

echo "Activating feature 'helix-editor'"
echo "Installing version ${VERSION}"

cd /tmp
curl -fsSLO https://github.com/helix-editor/helix/releases/download/${VERSION}/helix-${VERSION}-x86_64-linux.tar.xz
tar xJf helix-${VERSION}-x86_64-linux.tar.xz
rm -f helix-${VERSION}-x86_64-linux.tar.xz
mkdir -p  ${_CONTAINER_USER_HOME}/.local/bin
mv helix-${VERSION}-x86_64-linux/hx ${_CONTAINER_USER_HOME}/.local/bin
mkdir -p  ${_CONTAINER_USER_HOME}/.config/helix
mv helix-${VERSION}-x86_64-linux/runtime ${_CONTAINER_USER_HOME}/.config/helix
rm -rf helix-${VERSION}-x86_64-linux

echo "Helix ${VERSION} installed as ${_CONTAINER_USER_HOME}/.local/bin/hx"