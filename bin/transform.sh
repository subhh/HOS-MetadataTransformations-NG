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
    $basedir/../vendor/calabash -o result=$sourceDirectory/solr.xml \
                                -o validate-source=$sourceDirectory/validate-source.xml \
                                -o validate-solr=$sourceDirectory/validate-solr.xml \
                                $basedir/../src/main/xproc/pipeline.xpl sourceDirectory=$sourceDirectory
done
