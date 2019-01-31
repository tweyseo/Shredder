#!/bin/sh

#####################################################################
# usage:
# sh stop.sh -- stop application @dev
# sh stop.sh ${env} -- stop application @${env}

# examples:
# sh stop.sh prod -- use conf/nginx-prod.conf to stop OpenResty
# sh stop.sh -- use conf/nginx-dev.conf to stop OpenResty

# note:
# export your own OpenResty in the path
#####################################################################

export PATH=$PATH:/home/tweyseo/deps/OR-1.13.6.2-pcrejit/bin

if [ -n "$1" ];then
    PROFILE="$1"
else
    PROFILE=dev
fi

if [ ! -f tmp/${PROFILE}-nginx.pid ]; then
    echo -e "\033[41;33minvalid profile: "${PROFILE}"\033[0m"
    exit 1
fi

echo -e "\033[32mstop OR application with profile: "${PROFILE}"\033[0m"
openresty -s quit -p $(pwd)/ -c conf/nginx-${PROFILE}.conf

baklogs="logs/old_logs/$(date +'%Y%m%d_%H%M%S')"
mkdir -p ${baklogs}
mv ./logs/*.* ${baklogs}/
