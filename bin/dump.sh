#!/bin/bash
#
# Datenquellen prozessieren
#

function metha_cat () {
    local baseUrl=$1
    local format=$2
    local set=$3

    if [ -z "$set" ]; then
        /usr/sbin/metha-cat -format $format $baseUrl
    else
        /usr/sbin/metha-cat -format $format -set $set $baseUrl
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
    metha_cat $baseUrl $format $set > $source/records.xml
    $basedir/../vendor/calabash -i $source/records.xml -o $source/records.xml $basedir/../src/main/xproc/fix-metha-dump.xpl
    #$basedir/../vendor/morgana $basedir/../src/main/xproc/fix-metha-dump.xpl -input:source=$source/records.xml -output:result=$source/records.xml
done
