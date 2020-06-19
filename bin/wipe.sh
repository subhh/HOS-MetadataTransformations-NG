#!/bin/bash
#
# Index löschen
#

coreId=$1
basedir=$(realpath $(dirname $0))

source $basedir/solr.credentials

exec /usr/bin/curl -H "Content-Type: text/json" --data-binary '{ "delete": { "query": "*:*" } }' $solrUrl
