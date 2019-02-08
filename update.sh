#!/bin/bash

set -x

git clone https://github.com/lightbend/config.git tmp/
cp -r tmp/config/src/test/resources/ hocon/

cd hocon2json && sbt assembly && cd ..

for conf_file in hocon/*
do
    if [ -f "$conf_file" ]
    then
        scala hocon2json/target/scala-2.12/hocon2json-assembly-0.1.jar $conf_file > json/`basename $conf_file`
    fi
done