#!/bin/bash

pwd=`pwd`

build_arg=""
if [[ $1 ]];then
    build_arg="--build-arg make_j_arg=$1"
fi

rm -fr ${pwd}/make_data
mkdir ${pwd}/make_data
# 编译
docker build ${build_arg} -t hazx_make_tmp:nginxphp .
if [ "$?" != 0 ];then
    exit 1
fi
# 导出编译
docker run --rm -it -v ${pwd}/make_data:/root/make_data --name save_make hazx_make_tmp:nginxphp /root/hazx/save.sh
docker rmi hazx_make_tmp:nginxphp