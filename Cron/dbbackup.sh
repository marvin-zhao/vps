#!/bin/sh
/usr/local/mysql/bin/mysqldump -uroot -p blog > /home/www/dbbackup/blog-$(date +%Y%m%d -d "-1 day").sql
/usr/local/mysql/bin/mysqldump -uroot -p me > /home/www/dbbackup/me-$(date +%Y%m%d -d "-1 day").sql
cd /home/www/dbbackup/
if [ -f /home/www/dbbackup/sql-$(date +%Y%m%d -d "-1 day").tar.gz ];then
	echo -e "sql-$(date +%Y%m%d -d "-1 day").tar.gz exist\n"
	rm -f /home/www/dbbackup/sql-$(date +%Y%m%d -d "-1 day").tar.gz
	tar cvzf sql-$(date +%Y%m%d -d "-1 day").tar.gz *-$(date +%Y%m%d -d "-1 day").sql >/dev/null
	rm -f /home/www/dbbackup/*-$(date +%Y%m%d -d "-1 day").sql
else
	tar cvzf sql-$(date +%Y%m%d -d "-1 day").tar.gz *-$(date +%Y%m%d -d "-1 day").sql >/dev/null
	rm -f /home/www/dbbackup/*-$(date +%Y%m%d -d "-1 day").sql
fi
expiredday=`date +%Y%m%d -d "-14 day"`
if [ -f /home/www/dbbackup/sql-$expiredday.tar.gz ];then
	rm -f /home/www/dbbackup/sql-$expiredday.tar.gz
fi
