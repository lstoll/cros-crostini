#!/bin/bash
set -euo pipefail

echo "--> building base builder docker image"
docker build -t chromeoshack:builder -f Dockerfile.builder .

echo "--> running debootstrapper.sh inside container"
# privileged for chroot
docker run --rm --privileged -v $(pwd):/kokoro chromeoshack:builder /kokoro/debootstrapper.sh
