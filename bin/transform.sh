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
    #$basedir/../vendor/morgana $basedir/../src/main/xproc/pipeline-3.0.xpl -option:sourceDirectory=$sourceDirectory -output:result=$sourceDirectory/solr.xml
    $basedir/../vendor/calabash -o result=$sourceDirectory/solr.xml $basedir/../src/main/xproc/pipeline.xpl sourceDirectory=$sourceDirectory
done
