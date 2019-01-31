#!/bin/sh

#####################################################################
# usage:
# sh start.sh -- start application @dev
# sh start.sh ${env} -- start application @${env}

# examples:
# sh start.sh prod -- use conf/nginx-prod.conf to start OpenResty
# sh start.sh -- use conf/nginx-dev.conf to start OpenResty

# note:
# export your own OpenResty in the path
#####################################################################

export PATH=$PATH:/home/tweyseo/deps/OR-1.13.6.2-pcrejit/bin

if [ -n "$1" ];then
    PROFILE="$1"
else
    PROFILE=dev
fi

if [ -f tmp/*-nginx.pid ]; then
    echo -e "\033[41;33mduplicate OR, see "$(pwd)"/tmp/*-nginx.pid\033[0m"
    exit 1
fi

if [ ! -f conf/nginx-${PROFILE}.conf ]; then
    echo -e "\033[41;33minvalid profile: "${PROFILE}"\033[0m"
    exit 1
fi

mkdir -p logs & mkdir -p logs/old_logs & mkdir -p tmp

echo -e "\033[32mstart OR application with profile: "${PROFILE}"\033[0m"
openresty -p $(pwd)/ -c conf/nginx-${PROFILE}.conf
