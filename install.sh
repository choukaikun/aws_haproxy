#!/usr/bin/env 

# Install dependant packages

sudo yum install -y gcc openssl-devel systemd-devel

cd /opt
sudo git clone https://git.haproxy.org.org/git/haproxy-1.8.git/

cd /opt/haproxy-1.8
sudo make TARGET=linux2628 USE_PCRE=1 USE_OPENSSL=1 USE_ZLIB=1 USE_SYSTEMD=1
sudo make install

cd contrib/systemd
sudo make
sudo cp haproxy.service /lib/systemd/system

mkdir -p /etc/haproxy
mkdir -p /var/lib/haproxy
mkdir /run/haproxy

systemctl enable haproxy
systemctl start haproxy
