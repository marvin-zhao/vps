#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

# Check if user is root
if [ $(id -u) != "0" ]; then
    echo "Error: You must be root to run this script, please use root to install lnmp"
    exit 1
fi

clear
echo "========================================================================="
echo "Upgrade Mysql for LNMP,  Written by Licess"
echo "========================================================================="
echo "LNMP is tool to auto-compile & install Nginx+MySQL+PHP on Linux "
echo ""
echo "Upgrade Mysql tool Author:Joysboy"
echo "For more LNMP information please visit http://www.lnmp.org/"
echo "For more Upgrade Tool information please visit http://xfeng.me/"
echo "========================================================================="

nv=`mysql --version 2>&1`
old_mysql_version=`echo $nv | awk -F'[ ,]' '{print $6}'`
#echo $old_mysql_version

if [ "$1" != "--help" ]; then

#set mysql version

	mysql_version=""
	echo "Current Nginx Version:$old_mysql_version"
	echo "Please input mysql version you want:"
	echo "Only for mysql version 5.5.*:"
	echo "You can get version number from http://www.mysql.com/downloads/mysql/"
	read -p "(example: 5.5.19 ):" mysql_version
	if [ "$mysql_version" = "" ]; then
		echo "Error: You must input mysql version!!"
		exit 1
	fi
	echo "==========================="

	echo "You want to upgrade mysql version to $mysql_version"

	echo "==========================="

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
	echo "Press any key to start...or Press Ctrl+c to cancel"
	char=`get_char`

echo "============================check files=================================="
if [ -s mysql-$mysql_version.tar.gz ]; then
  echo "mysql-$mysql_version.tar.gz [found]"
  else
  echo "Error: mysql-$mysql_version.tar.gz not found!!!download now......"
  wget -c http://dev.mysql.com/get/Downloads/MySQL-5.5/mysql-$mysql_version.tar.gz/from/http://mirror.services.wisc.edu/mysql/ 
  dl_status=`echo $?`
  if [ $dl_status = "0" ]; then
	echo "Download mysql-$mysql_version.tar.gz successfully!"
  else
	echo "WARNING!May be the mysql version you input was wrong,please check!"
	echo "Nginx Version input was:"$mysql_version
	sleep 5
	exit 1
  fi
fi

if [ -s /usr/local/bin/cmake -o -s /usr/bin/cmake ];then
  echo "cmake [found]"
  else
  echo "Error: cmake not found!!! install now....."
  wget -c http://www.cmake.org/files/v2.8/cmake-2.8.7.tar.gz
  dl_status=`echo $?`
  if [ $dl_status = "0" ]; then
	echo "Download cmake-2.8.7.tar.gz successfully!"
	tar xvf cmake-2.8.7.tar.gz
	cd cmake-2.8.7/
	./configure
	gmake
	make install
	cd ..
	if [ -s /usr/bin/cmake ];then
		echo "Install cmake successfully!"
	else
		echo "Error install cmake..."
		sleep 5
		exit 1
	fi
  else
	echo "Error download cmake-2.8.7.tar.gz"
	sleep 5
	exit 1
  fi
fi
echo "============================install mysql=================================="
rm -rf mysql-$mysql_version/

tar zxvf mysql-$mysql_version.tar.gz
cd mysql-$mysql_version/
cmake -DCMAKE_INSTALL_PREFIX=/usr/local/mysql \
-DWITH_READLINE=1 \
-DWITH_SSL=system \
-DWITH_ZLIB=system \
-DENABLED_LOCAL_INFILE=1 \
-DEXTRA_CHARSETS=all \
-DDEFAULT_CHARSET=utf8 \
-DDEFAULT_COLLATION=utf8_general_ci \
-DWITH_EMBEDDED_SERVER=1 \
-DMYSQL_UNIX_ADDR=/tmp/mysqld.sock \
-DMYSQL_USER=mysql
make

/etc/init.d/mysql stop
mv /usr/local/mysql/ /usr/local/mysql.old
make install
cp -a /usr/local/mysql.old/var/* /usr/local/mysql/data
chown -R mysql.mysql /usr/local/mysql/data
chgrp -R mysql /usr/local/mysql/.
mv /etc/init.d/mysql /etc/init.d/mysql.old -f
cp support-files/mysql.server /etc/init.d/mysql
chmod 755 /etc/init.d/mysql

cat > /etc/ld.so.conf.d/mysql.conf<<EOF
/usr/local/mysql/lib
/usr/local/lib
EOF
ldconfig

rm -f /usr/lib/mysql
rm -f /usr/include/mysql
rm -f /usr/bin/mysql
rm -f /usr/bin/myisamchk
rm -f /usr/bin/mysqldump
ln -s /usr/local/mysql/bin/mysql /usr/bin/mysql
ln -s /usr/local/mysql/bin/myisamchk /usr/bin/myisamchk
ln -s /usr/local/mysql/bin/mysqldump /usr/bin/mysqldump
ln -s /usr/local/mysql/lib /usr/lib/mysql
ln -s /usr/local/mysql/include /usr/include/mysql

/etc/init.d/mysql start
pid=`ps -ef|grep mysqld_safe|grep -v grep|awk '{print $2}'`
if [ "$pid" == "" ]; then
	echo "Error Insatll Mysql...."
	cd ..
	sleep 5
	exit 1
fi
echo "Upgrade completed!"
echo "Program will display Mysql Version......"
mysql --version
cd ../

echo "========================================================================="
echo "You have successfully upgrade from $old_mysql_version to $mysql_version"
echo "========================================================================="
echo "LNMP is tool to auto-compile & install Nginx+MySQL+PHP on Linux "
echo "========================================================================="
echo ""
echo "Upgrade Mysql tool Author:Joysboy"
echo "For more Upgrade Tool information please visit http://xfeng.me/"
echo "For more information please visit http://www.lnmp.org/"
echo ""
echo "========================================================================="
fi
