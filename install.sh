#!/usr/bin/env bash

SCRIPT_DIR=$(pwd)
# Install dependant packages

echo "=== Installing dependant packages ==="
sudo yum install -y gcc openssl-devel systemd-devel

echo "=== Cloning HAProxy GIT repository ==="
if [ ! -d /opt/apps ]; then
  mkdir /opt/apps
fi

cd /opt/apps/unix
sudo git clone https://git.haproxy.org/git/haproxy-1.8.git/

echo "=== Building haproxy binary from source ==="
cd /opt/apps/haproxy-1.8
#sed -i -e 's/doc\/haproxy/share\/doc\/haproxy/g' Makefile # Fix install-man area

sudo make TARGET=linux2628 USE_PCRE=1 USE_OPENSSL=1 USE_ZLIB=1 USE_SYSTEMD=1
sudo make PREFIX=/usr install

echo "=== Create haproxy user and group ==="
groupadd haproxy
useradd -g haproxy haproxy

echo "=== Adding haproxy to systemd ==="
sudo cp haproxy.service /lib/systemd/system

echo "=== Seting up /run/haproxy directory settings ==="
cp -p ${SCRIPT_DIR}/etc/temp.d/haproxy /etc/temp.d

echo "=== Some setup before starting haproxy ==="
mkdir -p /etc/haproxy
mkdir -p /var/lib/haproxy

echo "=== Enabling and starting the haproxy service ==="
systemctl enable haproxy
systemctl start haproxy
