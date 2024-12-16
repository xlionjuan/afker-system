#!/bin/bash

set -ouex pipefail

RELEASE="$(rpm -E %fedora)"

# https://github.com/blue-build/modules/blob/bc0cfd7381680dc8d4c60f551980c517abd7b71f/modules/rpm-ostree/rpm-ostree.sh#L16
echo "Creating symlinks to fix packages that install to /opt"
# Create symlink for /opt to /var/opt since it is not created in the image yet
mkdir -p "/var/opt"
ln -s "/var/opt"  "/opt"


# Add xlion-rustdesk-rpm-repo.repo to /etc/yum.repos.d/
curl -fsSl https://xlionjuan.github.io/rustdesk-rpm-repo/nightly.repo | tee /etc/yum.repos.d/xlion-rustdesk-rpm-repo.repo


# Add cloudflare-warp.repo to /etc/yum.repos.d/
curl -fsSl https://pkg.cloudflareclient.com/cloudflare-warp-ascii.repo | tee /etc/yum.repos.d/cloudflare-warp.repo


# Install
dnf5 install -y install cloudflare-warp htop plasma-workspace-x11 ntpd-rs rustdesk

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/39/x86_64/repoview/index.html&protocol=https&redirect=1

# this installs a package from fedora repos


# this would install a package from rpmfusion
# rpm-ostree install vlc

#### Example for enabling a System Unit File

systemctl enable rustdesk.service
systemctl enable warp-svc.service

systemctl disable chronyd
systemctl enable ntpd-rs

# CachyOS Kernel
#dnf5 -y remove kernel kernel-core kernel-modules kernel-modules-core kernel-modules-extra zram-generator-defaults
dnf5 copr enable -y bieszczaders/kernel-cachyos-lto
dnf5 copr enable -y bieszczaders/kernel-cachyos-addons
#rpm-ostree install kernel-cachyos-lto
dnf5 -y install scx-scheds cachyos-settings uksmd
#systemctl enable scx.service
#systemctl enable uksmd.service