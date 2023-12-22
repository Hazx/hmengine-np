#!/bin/bash

## 内置模块来源
## http://nginx.org/en/download.html
## https://www.openssl.org/source/
## https://www.pcre.org/
## https://www.zlib.net/
## https://www.php.net/releases/
## https://libzip.org/download/

docker_img=hmengine-np
docker_tag=2.7
## 编译线程数
make_threads=${1:-2}

## 清理工作目录
if [ -e build_${docker_img} ];then
    rm -fr build_${docker_img}
fi
if [ -e output/${docker_img}-${docker_tag}.tar ];then
    rm -fr output/${docker_img}-${docker_tag}.tar
fi

## 构建前的准备工作
mkdir -p build_${docker_img}
cp -R build build_${docker_img}/
cat <<EOF > build_${docker_img}/build/Dockerfile
FROM centos:7.9.2009
LABEL maintainer="hazx632823367@gmail.com"
LABEL Version="${docker_tag}-build"
COPY nginx /root/hazx/nginx
COPY php8 /root/hazx/php8
COPY IDR-buildex-sh /root/hazx/
COPY IDR-build-sh /root/hazx/
RUN mv /root/hazx/IDR-build-sh /root/hazx/build.sh ;\
    mv /root/hazx/IDR-buildex-sh /root/hazx/export.sh ;\
    chmod a+x /root/hazx/*.sh ;\
    /root/hazx/build.sh
CMD /root/hazx/export.sh
EOF

## 构建资源
docker build --progress=plain --build-arg make_threads=${make_threads} -t ${docker_img}:${docker_tag}-build build_${docker_img}/build/
mkdir -p build_${docker_img}/package
pwd_dir=$(cd $(dirname $0); pwd)
docker run --rm --name tmp-hmengine-build-export \
    -v ${pwd_dir}/build_${docker_img}/package:/export \
    ${docker_img}:${docker_tag}-build

## 打包最终镜像
mkdir -p output
cp build/IDR-imginit-sh build_${docker_img}/package/img_init.sh
cp build/IDR-webserver-sh build_${docker_img}/package/webserver.sh
cp build/IDR-keep build_${docker_img}/package/keep
cat <<EOF > build_${docker_img}/package/Dockerfile
FROM centos:7.9.2009
LABEL maintainer="hazx632823367@gmail.com"
LABEL Version="${docker_tag}"
COPY web_server /web_server
COPY img_init.sh /
COPY webserver.sh /web_server/
COPY keep /web_server/
RUN chmod a+x /img_init.sh ;\
    /img_init.sh ;\
    rm -f /img_init.sh ;\
    rm -f /Dockerfile
WORKDIR /web_server
ENV PATH "/web_server/nginx/sbin:/web_server/php/sbin:$PATH"
CMD /web_server/webserver.sh
EOF
docker build --progress=plain -t ${docker_img}:${docker_tag} build_${docker_img}/package/
docker save ${docker_img}:${docker_tag} | gzip -c > output/${docker_img}-${docker_tag}.tar.gz

## 清理垃圾
docker rmi ${docker_img}:${docker_tag}-build
docker rmi ${docker_img}:${docker_tag}
rm -fr build_${docker_img}

echo "Docker build finished."
echo "Image name: ${docker_img}:${docker_tag}"
echo "Image Path: output/${docker_img}-${docker_tag}.tar.gz"

