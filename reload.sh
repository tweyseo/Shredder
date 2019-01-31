#!/bin/sh

#####################################################################
# usage:
# sh reload.sh -- reload application @dev
# sh reload.sh ${env} -- reload application @${env}

# examples:
# sh reload.sh prod -- use conf/nginx-prod.conf to reload OpenResty
# sh reload.sh -- use conf/nginx-dev.conf to reload OpenResty

# note:
# export your own OpenResty in the path
#####################################################################

if [ -n "$1" ];then
    PROFILE="$1"
else
    PROFILE=dev
fi

if [ ! -f tmp/${PROFILE}-nginx.pid ]; then
    echo -e "\033[41;33minvalid profile: "${PROFILE}"\033[0m"
    exit 1
fi

baklogs="logs/old_logs/$(date +'%Y%m%d_%H%M%S')"
mkdir -p ${baklogs}
mv ./logs/*.* ${baklogs}/

echo -e "\033[32mreload OR application with profile: "${PROFILE}"\033[0m"
kill -HUP $(cat $(pwd)/tmp/${PROFILE}-nginx.pid)