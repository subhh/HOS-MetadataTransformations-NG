#!/bin/bash
#
# Daten indexieren
#

coreId=$1
if [[ -z $2 ]]; then
    sourceId=*
else
    sourceId=$2
fi
basedir=$(realpath $(dirname $0))

source $basedir/solr.credentials

for source in $basedir/../data/$sourceId
do
    document=$source/solr.xml
    /usr/bin/curl -H "Content-Type: application/xml" --data-binary @${document} $solrUrl
done
