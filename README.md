# Installing HAProx 1.8.X on EC2

## Packages to install:
 * git
 * gcc
 * openssl-devel
 * pcre-devel

## Clone source repository
cd /opt
git clone https://git.haproxy.org/git/haproxy-1.8.git/

make TARGET=linux2628 USE_PCRE=1 USE_OPENSSL=1 USE_ZLIB=1
make install
