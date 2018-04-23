#!/usr/bin/env bash

SCRIPT_DIR=$(pwd)
# Install dependant packages

echo "=== Installing dependant packages ==="
yum install -y gcc openssl-devel systemd-devel

echo "=== Cloning HAProxy GIT repository ==="
if [ ! -d /opt/apps/unix ]; then
  mkdir -p /opt/apps/unix
fi

cd /opt/apps/unix
git clone https://git.haproxy.org/git/haproxy-1.8.git/

echo "=== Building haproxy binary from source ==="
cd /opt/apps/unix/haproxy-1.8

make TARGET=linux2628 USE_PCRE=1 USE_PCRE_JIT=1 USE_OPENSSL=1 USE_ZLIB=1 USE_SYSTEMD=1
make install

echo "=== Create haproxy user and group ==="
groupadd -g 65188 haproxy
useradd -g haproxy -M -d /var/lib/haproxy -s /sbin/nologin -u 65188 haproxy

echo "=== Adding haproxy to systemd ==="
cd /opt/apps/unix/haproxy-1.8/contrib/systemd
make
cp haproxy.service /lib/systemd/system

echo "=== Seting up /run/haproxy directory settings ==="
cp ${SCRIPT_DIR}/etc/tmpfiles.d/haproxy.conf /etc/tmpfiles.d
systemd-tmpfiles --create

echo "=== Some setup before starting haproxy ==="
mkdir -p /etc/haproxy
cp ${SCRIPT_DIR}/etc/haproxy.cfg /etc/haproxy/

mkdir -p /var/lib/haproxy/dev
cp ${SCRIPT_DIR}/etc/rsyslog.d/49-haproxy.conf /etc/rsyslog.d/

echo "=== Enabling and starting the haproxy service ==="
systemctl enable haproxy
systemctl start haproxy

echo "=== Restarting rsyslog ==="
selinuxenabled && setenforce 0
systemctl restart rsyslog

echo "=== Installing NGINX ==="
yum --enablerepo rhui-REGION-rhel-server-rhscl install -y rh-nginx112
sed -i -e "s/80 d/8080 d/g" /etc/opt/rh/rh-nginx112/nginx/nginx.conf
systemctl enable rh-nginx112-nginx
systemctl start rh-nginx112-nginx
sleep 5

echo "=== Local test ==="
curl localhost

echo "=== Log file ==="
cat /var/log/haproxy.log
