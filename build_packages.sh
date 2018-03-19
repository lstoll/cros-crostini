#!/bin/bash
set -euo pipefail

echo "--> fetching code"
mkdir -p git
if [ ! -d git/cros-container-guest-tools ]; then
    (cd git && git clone https://chromium.googlesource.com/chromiumos/containers/cros-container-guest-tools)
fi
(cd git/cros-container-guest-tools && git fetch && git reset --hard origin/master && git clean -fdx)

echo "--> building base builder docker image"
docker build -t chromeoshack:builder -f Dockerfile.builder .

dockerbuild() {
    docker run --rm -v $(pwd):/kokoro -e KOKORO_ARTIFACTS_DIR=/kokoro chromeoshack:builder sh -c "cd /kokoro/git/$1 && ./kokoro/build.sh"
}

echo "--> building cros-container-guest-tools"
dockerbuild cros-container-guest-tools
