#!/bin/bash

rm -fr ./make_data
cp -R ../1.Make/make_data ./make_data
docker build -t hazx/hmengine-np:2.0 .