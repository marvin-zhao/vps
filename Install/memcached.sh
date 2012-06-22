#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

# Check if user is root
if [ $(id -u) != "0" ]; then
    echo "Error: You must be root to run this script, please use root to install lnmp"
    exit 1
fi

clear
printf "=======================================================================\n"
printf "Install Memcached for LNMP V0.9  ,  Written by Licess \n"
printf "=======================================================================\n"
printf "LNMP is a tool to auto-compile & install Nginx+MySQL+PHP on Linux \n"
printf "This script is a tool to install memcached for lnmp \n"
printf "\n"
printf "For more information please visit http://www.lnmp.org \n"
printf "=======================================================================\n"
cur_dir=$(pwd)

	get_char()
	{
	SAVEDSTTY=`stty -g`
	stty -echo
	stty cbreak
	dd if=/dev/tty bs=1 count=1 2> /dev/null
	stty -raw
	stty echo
	stty $SAVEDSTTY
	}
	echo ""
	echo "Press any key to start install Memcached..."
	char=`get_char`

printf "=========================== install memcached ======================\n"

wget -c http://soft.vpser.net/lib/libevent/libevent-2.0.13-stable.tar.gz
tar zxvf libevent-2.0.13-stable.tar.gz
cd libevent-2.0.13-stable/
./configure --prefix=/usr/local/libevent
make&& make install
cd ../

echo "/usr/local/libevent/lib/" >> /etc/ld.so.conf
ln -s /usr/local/libevent/lib/libevent-2.0.so.5  /lib/libevent-2.0.so.5
ldconfig

wget -c http://soft.vpser.net/web/memcached/memcached-1.4.7.tar.gz
tar zxvf memcached-1.4.7.tar.gz
cd memcached-1.4.7/
./configure --prefix=/usr/local/memcached
make &&make install
cd ../

ln /usr/local/memcached/bin/memcached /usr/bin/memcached

cp conf/memcached-init /etc/init.d/memcached
chmod +x /etc/init.d/memcached
useradd -s /sbin/nologin nobody

if [ -s /etc/debian_version ]; then
update-rc.d -f memcached defaults
elif [ -s /etc/redhat-release ]; then
chkconfig --level 345 memcached on
fi

echo "Copy Memcached PHP Test file..."
cp conf/memcached.php /home/wwwroot/memcached.php

echo "Starting Memcached..."
/etc/init.d/memcached start

printf "===================== install Memcached completed =====================\n"
printf "Install Memcached completed,enjoy it!\n"
printf "You Can visit Memcached PHP Test file: http://ip/memcached.php\n"
printf "=======================================================================\n"
printf "Install Memcached for LNMP V0.9  ,  Written by Licess \n"
printf "=======================================================================\n"
printf "LNMP is a tool to auto-compile & install Nginx+MySQL+PHP on Linux \n"
printf "This script is a tool to install Memcached for lnmp \n"
printf "\n"
printf "For more information please visit http://www.lnmp.org \n"
printf "=======================================================================\n"