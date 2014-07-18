#!/bin/bash
# This script run at 00:00
# cut yesterday log and gzip the day before yesterday log files.
# yesterday logs to awstats

# The Nginx logs path
logs_path="/home/wwwlogs/"
# Nginx logs names here
logs_names=(access blog.joysboy.net joysboy.net me.joysboy.net photo.xfeng.me xfeng.me mb.joysboy.net nginx_error wiki.joysboy.net xmubingo.info)
num=${#logs_names[@]}
for((i=0;i<num;i++));do
mkdir -p ${logs_path}${logs_names[i]}/$(date -d "yesterday" +"%Y%m")
log_name="${logs_path}${logs_names[i]}.log"
if [ -f "$log_name" ]; then
mv ${logs_path}${logs_names[i]}.log ${logs_path}${logs_names[i]}/$(date -d "yesterday" +"%Y%m")/${logs_names[i]}_$(date -d "yesterday" +"%Y%m%d").log
fi
#gzip_log="${logs_path}${logs_names[i]}/$(date -d "yesterday" +"%Y%m")/${logs_names[i]}_$(date -d "-2 day" +"%Y%m%d").log"
#if [ -f "$gzip_log" ]; then
#/usr/bin/gzip ${logs_path}${logs_names[i]}/$(date -d "yesterday" +"%Y%m")/${logs_names[i]}_$(date -d "-2 day" +"%Y%m%d").log
#fi
done
/usr/local/nginx/sbin/nginx -s reopen
