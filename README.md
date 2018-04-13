# Installing HAProx 1.8.X on Amazon EC2

## Amazon Linux 2

### Packages to install:
 * git
 * gcc
 * openssl-devel
 * systemd-devel

### Clone source repository
cd /opt
git clone https://git.haproxy.org/git/haproxy-1.8.git/

cd /opt/haproxy-1.8
make TARGET=linux2628 USE_PCRE=1 USE_OPENSSL=1 USE_ZLIB=1 USE_SYSTEMD=1
make install
cd contrib/systemd
make
cp haproxy.service /lib/systemd/system

### Some additional packages for testing and troubleshooting
amazon-linux-extras install nginx1.12
amazon-linux-extras install vim

# Ubuntu 16.04 HAProxy steps

apt-get install software-properties-common
add-apt-repository ppa:vbernat/haproxy-1.8
apt-get update
apt-get install haproxy


