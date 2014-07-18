#!/bin/bash
logs_names=(xfeng.me)
num=${#logs_names[@]}
for((i=0;i<num;i++));do
mkdir -p /home/wwwroot/awstats/${logs_names[i]}
date |tee >> /tmp/awstats.log
/usr/local/awstats/tools/awstats_buildstaticpages.pl -update  \
-config=${logs_names[i]} -lang=cn -dir=/home/wwwroot/awstats/${logs_names[i]}  \
-awstatsprog=/usr/local/awstats/wwwroot/cgi-bin/awstats.pl |tee >> /tmp/awstats.log
chown -R www.www /home/wwwroot/awstats/${logs_names[i]}
done
