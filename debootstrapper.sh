#!/bin/bash
set -euo pipefail

# Bootstrap a base stretch install
mkdir /bs
cd /bs
debootstrap --arch=amd64 stretch rootfs
mkdir rootfs/tmp/extras
# Copy the apt setup over, and get it installed
cp /kokoro/git/cros-container-guest-tools/results/cros-apt-config-deb.deb rootfs/tmp/extras/
chroot /bs/rootfs /bin/sh -c "apt-get install -y apt-transport-https && dpkg -i tmp/extras/*.deb && apt-get update"
# Install the guest utils metapackage, fetching from the google repo
chroot /bs/rootfs /bin/sh -c "apt-get install -y cros-guest-tools"
rm -r rootfs/tmp/extras
# Clean up the guest space
chroot /bs/rootfs /bin/sh -c "apt-get autoremove && apt-get clean && rm -rf /var/lib/apt/lists/*"
# Copy the overlay options over the top
cp -r /kokoro/stretch-overlay/* rootfs/
# Copy the lxd metadata
cp /kokoro/metadata.yaml .
# Package up the result
mkdir -p /kokoro/result
tar -zcf /kokoro/result/stretch.tgz metadata.yaml rootfs

echo "--> done, image at result/stretch.tgz"