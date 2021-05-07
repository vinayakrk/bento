#!/bin/bash

# required rpms for oracle and supporting configuration

echo "Installing required rpms for oracle and supporting configuration"
yum install -yyy \
  autofs \
  bc \
  bind-utils \
  binutils \
  compat-libcap1 \
  compat-libstdc++-33 \
  compat-libstdc++-33.i686 \
  gcc \
  gcc-c++ \
  glibc \
  glibc-devel \
  glibc-devel.i686 \
  glibc.i686 \
  ksh \
  libaio \
  libaio-devel \
  libaio-devel.i686 \
  libaio.i686 \
  libgcc \
  libgcc.i686 \
  libselinux-python \
  libstdc++ \
  libstdc++-devel \
  libstdc++-devel.i686 \
  libstdc++.i686 \
  libX11 \
  libX11.i686 \
  libXau \
  libXau.i686 \
  libxcb \
  libxcb.i686 \
  libXext \
  libXext.i686 \
  libXi \
  libXi.i686 \
  libXtst \
  libXtst.i686 \
  lsof \
  make \
  net-tools \
  nfs-utils \
  perl-Data-Dumper \
  perl-ExtUtils-MakeMaker \
  psmisc \
  python \
  python-configshell \
  python-rtslib \
  python-six \
  smartmontools \
  strace \
  sudo \
  sysstat \
  unixODBC \
  unixODBC-devel \
  unzip \
  xauth \
  xorg-x11-utils \
  yum-utils \
  zip \
  zlib-devel \
  zlib-devel.i686

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

echo "Updating /etc/auto.master"
cat<<EOF >> /etc/auto.master
/nfs /etc/auto.nfs --timeout=180
EOF

echo "Creating /etc/auto.nfs"
cat<<EOF > /etc/auto.nfs
orasoft -fstype=nfs,ro,soft,intr 10.1.0.2:/data/orasoft
EOF

echo "Creating /orasoft link pointing to /nfs/orasoft"
ln -s /nfs/orasoft /orasoft

echo "Enabling autofs"
chkconfig autofs on

groupadd -g 2690 vrk
useradd -g vrk -c vrk -d /home/vrk -m -s /bin/bash -u 2690 vrk
echo "vrk ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/vrk
chmod 440 /etc/sudoers.d/vrk
mkdir -p ~vrk/.ssh
curl -s https://raw.githubusercontent.com/vinayakrk/assets/main/id_rsa.pub -o ~vrk/.ssh/authorized_keys
chown -R vrk:vrk ~vrk/.ssh
chmod 700 ~vrk/.ssh
chmod 600 ~vrk/.ssh/authorized_keys

