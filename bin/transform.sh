#!/bin/bash
#
# Datenquellen prozessieren
#

basedir=$(realpath $(dirname $0))

if [[ -z $1 ]]; then
    sourceId=*
else
    sourceId=$1
fi

for source in $basedir/../data/$sourceId
do
    sourceDirectory="file://$(realpath $source)/"
    $basedir/../vendor/calabash -o result=$sourceDirectory/solr.xml -o report=$sourceDirectory/report.xml $basedir/../src/main/xproc/pipeline.xpl sourceDirectory=$sourceDirectory
done
