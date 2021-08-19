FROM centos:7.9.2009

LABEL maintainer="hazx632823367@gmail.com"
LABEL Version="2.0"

RUN mkdir /root/web_server ;\
    chmod -R 755 /root/web_server

ADD make_data /root/web_server
ADD keep /root/web_server/
ADD start_webserver /root/web_server/start_webserver.sh

RUN curl -o /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo ;\
    yum makecache -y ;\
    yum install -y libpng-devel libicu oniguruma ;\
    # 安装libzip
    mv /root/web_server/libzip/lib/* /usr/local/lib64/ ;\
    chmod +x /root/web_server/libzip/exec/* ;\
    mv /root/web_server/libzip/exec/* /usr/local/bin/ ;\
    mkdir -p /usr/local/lib64/pkgconfig ;\
    mv /root/web_server/libzip/libzip.pc /usr/local/lib64/pkgconfig/libzip.pc ;\
    ln -s /usr/local/lib64/libzip.so /usr/lib64/libzip.so ;\
    ln -s /usr/local/lib64/libzip.so.5 /usr/lib64/libzip.so.5 ;\
    ln -s /usr/local/lib64/libzip.so.5.3 /usr/lib64/libzip.so.5.3 ;\
    ln -s /usr/local/lib64/pkgconfig/libzip.pc /usr/lib64/pkgconfig/libzip.pc ;\
    # 配置权限
    groupadd www ;\
    useradd -M -s /bin/false -g www www ;\
    chmod +x /root/web_server/start_webserver.sh ;\
    chmod +x /root/web_server/keep ;\
    # 清理
    yum clean all ;\
    rm -rf /var/cache/yum

CMD  /root/web_server/start_webserver.sh

