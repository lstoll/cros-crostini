# README

Some script to support getting into running crostini apps

### I just wanna try it out!

*Enable the feature*
1. Switch to the dev channel (beta also ok if m66).
1. Put into developer mode. This is only needed to enable the feature flag
1. "Enable debugging features" when setting up post switch/wipe, so you can SSH in.
1. Open a crosh window (CTRL+ALT+T)
```
shell
sudo su
cp /etc/chrome_dev.conf /usr/local/
mount --bind /usr/local/chrome_dev.conf /etc/chrome_dev.conf
echo "--enable-features=Crostini" >> /etc/chrome_dev.conf
restart ui
exit
```
**Note: after a reboot you will need to `shell; sudo mount --bind /usr/local/chrome_dev.conf /etc/chrome_dev.conf`**

*Use it*
1. Launch crosh (ctrl-alt-t)
1. Create crostini VM `vmc start dev`. This'll download the termina component, and open a shell.
1. Fetch the stretch image created by this repo `curl -Lo /tmp/stretch.tgz http://github.com/lstoll/cros-crostini/releases/download/0.1/stretch.tgz`
1. Install it into lxd `lxc image import /tmp/stretch.tgz --alias stretch`
1. Create the container, set it up, use it:

```
lxc launch stretch stretch
lxc exec stretch -- useradd -u 1000 \
    -s "/bin/bash" \
    -m "lstoll"
groups="audio cdrom dialout floppy plugdev sudo users video"
for group in ${groups}; do
    lxc exec stretch -- usermod -aG "${group}" lstoll
done

# Keep user session running in container even if logged out
lxc exec stretch --  loginctl enable-linger lstoll

# Launch a session inside the container
lxc exec stretch -- /bin/login -f lstoll
```

You're now inside a stretch environment, that is wired up properly for network/gui apps. Install stuff, run it, windows should just come up on the desktop

### What is happening

This is build out of a few things
* crosvm/termina - a hypervisor for chromeos, and an OS image that's based on chromeos with lxd installed.
* crostini - seems like branding for running dev-ish apps inside a container inside the above VM.

Wayland is mapped across a virtio rig, which makes for decent performance. The stretch image has this + xwl in it, so normal X apps just work

Some notable things to look at:
* crosvm, the hypervisor: https://chromium.googlesource.com/chromiumos/platform/crosvm/
* termina board: https://chromium.googlesource.com/chromiumos/overlays/board-overlays/+/master/project-termina/
* * setup scripts https://chromium.googlesource.com/chromiumos/overlays/board-overlays/+/master/project-termina/chromeos-base/termina-lxd-scripts/files/
* container guest tools: https://chromium.googlesource.com/chromiumos/containers/cros-container-guest-tools/
* virtwl patched items: https://chromium.googlesource.com/chromiumos/containers/cros-container-virtwl/
* xwl: https://chromium.googlesource.com/chromiumos/containers/xwl/
* gtk theme: https://chromium.googlesource.com/chromiumos/containers/adapta-gtk-theme/

This repo just has a couple scripts that build a stretch lxd image via debootstrap with the right guest packages, presumably this will be served up by google with some GUI before release.
