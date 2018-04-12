#!/usr/bin/env bash

# Install dependant packages

echo "=== Installing dependant packages ==="
sudo yum install -y gcc openssl-devel systemd-devel

echo "=== Cloning HAProxy GIT repository ==="
cd /opt
sudo git clone https://git.haproxy.org/git/haproxy-1.8.git/

echo "=== Building haproxy binary from source ==="
cd /opt/haproxy-1.8
sudo make TARGET=linux2628 USE_PCRE=1 USE_OPENSSL=1 USE_ZLIB=1 USE_SYSTEMD=1
sudo make install

echo "=== Adding haproxy to systemd ==="
cd contrib/systemd
sudo make
sudo cp haproxy.service /lib/systemd/system

echo "=== Some setup before starting haproxy ==="
groupadd haproxy
useradd -g haproxy haproxy

mkdir -p /etc/haproxy
mkdir -p /var/lib/haproxy

echo "=== Enabling and starting the haproxy service ==="
systemctl enable haproxy
systemctl start haproxy
