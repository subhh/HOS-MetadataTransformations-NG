#!/bin/bash
#
# Datenquellen prozessieren
#

basedir=$(realpath $(dirname $0))

for source in $basedir/../data/*
do
    sourceDirectory="file://$(realpath $source)/"
    $basedir/../vendor/calabash -o result=$sourceDirectory/solr.xml $basedir/../src/main/xproc/pipeline.xpl sourceDirectory=$sourceDirectory
done
