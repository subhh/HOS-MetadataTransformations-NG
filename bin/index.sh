#!/bin/bash
#
# Daten indexieren
#

coreId=$1
basedir=$(realpath $(dirname $0))

source $basedir/solr.credentials

for source in $basedir/../data/*
do
    document=$source/solr.xml
    /usr/bin/curl -H "Content-Type: application/xml" --data-binary @${document} $solrUrl
done
