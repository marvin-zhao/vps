#!/bin/bash
# This script run always
# delete comment cache

log="/home/wwwlogs/xfeng.me.log"
# Nginx logs names here
#while [ -z `ps -ef|grep "nginx: master"|grep -v grep|awk '{print $2}'` ]
tail -n1 -f $log |while read line
do
echo $line > /tmp/lastline
awk  -F\" '{print $2}' /tmp/lastline >/tmp/lastrequest
request=`grep "comments-post.php" /tmp/lastrequest`
reval=$?
if [ $reval == 0 ]; then
awk  -F\" '{print $4}' /tmp/lastline >/tmp/lastarget
target_url=`awk -F\/ '{print $4}' /tmp/lastarget`
date |tee >> /tmp/nocache.log
cat /tmp/lastarget |tee >> /tmp/nocache.log
curl http://xfeng.me/nocache/$target_url/ |tee >> /tmp/nocache.log
curl http://xfeng.me/nocache/$target_url/comment-page-1/ |tee >> /tmp/nocache.log
fi
done
