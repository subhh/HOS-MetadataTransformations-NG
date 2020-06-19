#!/bin/bash
#
# Datenquellen harvesten
#
# TODO: Hängende Harvestingprozesse erkennen
#

function metha_sync () {
    local baseUrl=$1
    local format=$2
    local set=$3

    if [ -z "$set" ]; then
        /usr/sbin/metha-sync -format $format $baseUrl
    else
        /usr/sbin/metha-sync -format $format -set $set $baseUrl
    fi
}

basedir=$(realpath $(dirname $0))

for source in $basedir/../data/*
do
    source $source/about.sh
    metha_sync $baseUrl $format $set
done
