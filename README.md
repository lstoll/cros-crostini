# README

**Note**: Currently (Apr 6 '18) only works on Pixelbooks.

### I just wanna try it out!

*Enable the feature*
1. Switch to the dev channel (this is different to developer mode!). Ref https://support.google.com/chromebook/answer/1086915?hl=en. The latest builds now "just work" (>= 67.0.3383.0)

*Use it*
1. Launch crosh (ctrl-alt-t)
1. Create crostini VM `vmc start dev`. This'll download the termina component, and open a shell.
1. Launch a container `run_container.sh --container_name=stretch --user=<username> --shell`

You're now inside a stretch environment, that is wired up properly for network/gui apps. Install stuff, run it, windows should just come up on the desktop

### What is happening

This is build out of a few things
* crosvm/termina - a hypervisor for chromeos, and an OS image that's based on chromeos with lxd installed.
* crostini - seems like branding for running dev-ish apps inside a container inside the above VM.

Wayland is mapped across a virtio rig, which makes for decent performance. The stretch image has this + somellier in it, so normal X apps just work

Some notable things to look at:
* crosvm, the hypervisor: https://chromium.googlesource.com/chromiumos/platform/crosvm/
* termina board: https://chromium.googlesource.com/chromiumos/overlays/board-overlays/+/master/project-termina/
* * setup scripts https://chromium.googlesource.com/chromiumos/overlays/board-overlays/+/master/project-termina/chromeos-base/termina-lxd-scripts/files/
* container guest tools: https://chromium.googlesource.com/chromiumos/containers/cros-container-guest-tools/
* virtwl patched items: https://chromium.googlesource.com/chromiumos/containers/cros-container-virtwl/
* sommelier (x->wayland): https://chromium.googlesource.com/chromiumos/containers/sommelier
* gtk theme: https://chromium.googlesource.com/chromiumos/containers/adapta-gtk-theme/
