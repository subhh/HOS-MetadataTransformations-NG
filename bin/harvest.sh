#!/bin/bash
#
# Datenquellen harvesten
#

function metha_sync () {
    local baseUrl=$1
    local format=$2
    local set=$3
    local methaOpts=$4

    if [ -z "$set" ]; then
        /usr/sbin/metha-sync $methaOpts -format $format $baseUrl
    else
        /usr/sbin/metha-sync $methaOpts -format $format -set $set $baseUrl
    fi
}

basedir=$(realpath $(dirname $0))
if [[ -z $1 ]]; then
    sourceId=*
else
    sourceId=$1
fi

for source in $basedir/../data/$sourceId
do
    source $source/about.sh
    metha_sync $baseUrl $format $set $methaOpts
done
