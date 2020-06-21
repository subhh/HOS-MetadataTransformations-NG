#!/bin/bash
#
# Datenquellen prozessieren
#

basedir=$(realpath $(dirname $0))

for source in $basedir/../data/*
do
    sourceDirectory="file://$(realpath $source)/"
    $basedir/../vendor/morgana $basedir/../src/main/xproc/pipeline-3.0.xpl -option:sourceDirectory=$sourceDirectory -output:result=$sourceDirectory/solr.xml
    #$basedir/../vendor/calabash -o result=$sourceDirectory/solr.xml $basedir/../src/main/xproc/pipeline.xpl sourceDirectory=$sourceDirectory
done
