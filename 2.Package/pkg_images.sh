#!/bin/bash

rm -fr ./make_data
cp -R ../1.Make/make_data ./make_data

if [[ $1 ]];then
    docker build -t $1 .
else
    docker build -t hazx/hmengine-np:2.3 .
fi