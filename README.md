# Installing HAProx 1.8.X on EC2 Amazon Linux 2

## Packages to install:
 * git
 * gcc
 * openssl-devel
 * systemd-devel

## Clone source repository
cd /opt
git clone https://git.haproxy.org/git/haproxy-1.8.git/

cd /opt/haproxy-1.8
make TARGET=linux2628 USE_PCRE=1 USE_OPENSSL=1 USE_ZLIB=1 USE_SYSTEMD=1
make install
cd contrib/systemd
make
cp haproxy.service /lib/systemd/system

#amazon-linux-extras install nginx1.12
#amazon-linux-extras install vim
