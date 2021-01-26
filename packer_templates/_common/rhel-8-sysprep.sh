#!/bin/bash

# required rpms for oracle and supporting configuration

echo "Installing required rpms for oracle and supporting configuration"
dnf install -yyy \
  autofs \
  bc \
  binutils \
  elfutils-libelf \
  elfutils-libelf-devel \
  fontconfig-devel \
  glibc \
  glibc-devel \
  ksh \
  libaio \
  libaio-devel \
  libgcc \
  libibverbs \
  libnsl \
  libnsl2 \
  libnsl2-devel \
  librdmacm \
  libstdc++ \
  libstdc++-devel \
  libX11 \
  libXau \
  libxcb \
  libXi \
  libXrender \
  libXtst \
  make \
  net-tools \
  nfs-utils \
  smartmontools \
  strace \
  sudo \
  sysstat \
  unzip \
  xauth \
  xorg-x11-utils \
  zip

# install centos 7 packages
dnf install -yyy http://mirror.centos.org/centos/7/os/x86_64/Packages/compat-libstdc++-33-3.2.3-72.el7.x86_64.rpm
dnf install -yyy http://mirror.centos.org/centos/7/os/x86_64/Packages/compat-libcap1-1.10-7.el7.x86_64.rpm
# update sysctl.conf
echo "Updating /etc/sysctl.conf"

cat <<EOF >> /etc/sysctl.conf
fs.aio-max-nr=1048576
fs.file-max=6815744
kernel.panic_on_oops=1
kernel.sem=250 32000 100 128
kernel.shmall=1073741824
kernel.shmmax=4398046511104
kernel.shmmni=4096
net.core.rmem_default=262144
net.core.rmem_max=4194304
net.core.wmem_default=262144
net.core.wmem_max=1048576
net.ipv4.conf.all.rp_filter=2
net.ipv4.conf.default.rp_filter=2
net.ipv4.ip_local_port_range=9000 65500
EOF

echo "Updating /etc/chrony.conf"

cat<<EOF > /etc/chrony.conf
server 10.1.0.1 iburst
driftfile /var/lib/chrony/drift
makestep 1.0 3
rtcsync
allow 10.1.0.0/24
local stratum 10
logdir /var/log/chrony
EOF

echo "Updating /etc/auto.master"
cat<<EOF >> /etc/auto.master
/nfs /etc/auto.nfs --timeout=180
EOF

echo "Creating /etc/auto.nfs"
cat<<EOF > /etc/auto.nfs
orasoft -fstype=nfs,ro,soft,intr 10.1.0.2:/data/orasoft
EOF

echo "Enabling autofs"
systemctl enable autofs

echo "Creating /orasoft link pointing to /nfs/orasoft"
ln -s /nfs/orasoft /orasoft

groupadd -g 2690 vrk
useradd -g vrk -c vrk -d /home/vrk -m -s /bin/bash -u 2690 vrk
echo "vrk ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/vrk
chmod 440 /etc/sudoers.d/vrk
mkdir -p ~vrk/.ssh
curl -s https://raw.githubusercontent.com/vinayakrk/assets/main/id_rsa.pub -o ~vrk/.ssh/authorized_keys
chown -R vrk:vrk ~vrk/.ssh
chmod 700 ~vrk/.ssh
chmod 600 ~vrk/.ssh/authorized_keys

