#!/bin/bash

set -ouex pipefail

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/43/x86_64/repoview/index.html&protocol=https&redirect=1


dnf install -y cockpit cockpit-files cockpit-ostree cockpit-podman

cat << 'EOF' > /etc/yum.repos.d/rancher-k3s-common.repo
[rancher-k3s-common-stable]
name=Rancher K3s Common (Stable for CoreOS)
baseurl=https://rpm.rancher.io/k3s/stable/common/coreos/noarch
enabled=1
gpgcheck=1
repo_gpgcheck=0
gpgkey=https://rpm.rancher.io/public.key
EOF

dnf install -y container-selinux k3s-selinux

export INSTALL_K3S_SKIP_SELINUX_RPM=true
export INSTALL_K3S_BIN_DIR=/usr/bin
export INSTALL_K3S_SKIP_SELINUX_RPM=true
export INSTALL_K3S_SKIP_ENABLE=true
export INSTALL_K3S_SKIP_START=true
curl -sfL https://get.k3s.io | INSTALL_K3S_BIN_DIR=/usr/bin sh -


systemctl enable podman.socket
