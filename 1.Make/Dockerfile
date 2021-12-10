FROM centos:7.9.2009

LABEL maintainer="hazx632823367@gmail.com"
LABEL Version="2.4"

ARG make_j_arg

ADD nginx /root/hazx/nginx
ADD php8 /root/hazx/php8
ADD save /root/hazx/save.sh

RUN curl -o /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo ;\
    yum makecache -y ;\
    mkdir /web_server ;\
    chmod -R 755 /web_server ;\
    export make_j=${make_j_arg} ;\
    # Nginx - 安装依赖
    yum install -y openssl openssl-devel libxml2 libxml2-devel curl curl-devel libjpeg libjpeg-devel sqlite sqlite-devel libpng libpng-devel freetype-devel gmp-devel libevent libevent-devel gcc gcc-c++ unzip python-docutils libedit libedit-devel zlib zlib-devel git zip screen vim pcre-devel readline libstdc++-devel automake autoconf wget unzip ;\
    # Nginx - 配置Nginx
    cd /root/hazx/nginx/ ;\
    tar zxvf nginx-1.20.2.tar.gz ;\
    tar zxvf openssl-1.1.1l.tar.gz ;\
    tar zxvf pcre-8.45.tar.gz ;\
    tar zxvf zlib-1.2.11.tar.gz ;\
    cd /root/hazx/nginx/nginx-1.20.2/ ;\
    ./configure \
        --prefix=/web_server/nginx \
        --with-openssl=/root/hazx/nginx/openssl-1.1.1l \
        --with-pcre=/root/hazx/nginx/pcre-8.45 \
        --with-zlib=/root/hazx/nginx/zlib-1.2.11 \
        --with-http_ssl_module \
        --with-http_sub_module \
        --with-http_stub_status_module \
        --with-pcre-jit \
        --with-pcre \
        --with-http_secure_link_module \
        --with-http_realip_module \
        --with-http_dav_module \
        --with-http_v2_module ;\
    # Nginx - 配置Server标记
    export sbj='HMEngine\ |\ Powered\ by\ Hazx.' ;\
    sed -e "s/\"nginx\/\"\ NGINX_VERSION/\"${sbj}\"/" src/core/nginx.h > src/core/nginx.h.tmp ;\
    sed -e "s/\"NGINX\"/\"${sbj}\"/" src/core/nginx.h.tmp > src/core/nginx.h ;\
    rm -f src/core/nginx.h.tmp ;\
    sed -e "s/\"Server\:\ nginx\"\ CRLF\;/\"Server\:\ ${sbj}\"\ CRLF\;/" src/http/ngx_http_header_filter_module.c > src/http/ngx_http_header_filter_module.c.tmp1 ;\
    sed -e "s/\"Server\:\ \"\ NGINX_VER\ CRLF\;/\"Server\:\ ${sbj}\"\ CRLF\;/" src/http/ngx_http_header_filter_module.c.tmp1 > src/http/ngx_http_header_filter_module.c.tmp2 ;\
    sed -e "s/\"Server\:\ \"\ NGINX_VER_BUILD\ CRLF\;/\"Server\:\ ${sbj}\"\ CRLF\;/" src/http/ngx_http_header_filter_module.c.tmp2 > src/http/ngx_http_header_filter_module.c ;\
    rm -f src/http/ngx_http_header_filter_module.c.tmp1 ;\
    rm -f src/http/ngx_http_header_filter_module.c.tmp2 ;\
    sed -e "s/<center>\"\ NGINX_VER\ \"<\/center>/<center>${sbj}<\/center>/" src/http/ngx_http_special_response.c > src/http/ngx_http_special_response.c.tmp1 ;\
    sed -e "s/<center>\"\ NGINX_VER_BUILD\ \"<\/center>/<center>${sbj}<\/center>/" src/http/ngx_http_special_response.c.tmp1 > src/http/ngx_http_special_response.c.tmp2 ;\
    sed -e "s/<center>nginx<\/center>/<center>${sbj}<\/center>/" src/http/ngx_http_special_response.c.tmp2 > src/http/ngx_http_special_response.c ;\
    rm -f src/http/ngx_http_special_response.c.tmp1 ;\
    rm -f src/http/ngx_http_special_response.c.tmp2 ;\
    sed -e "s/nginx\/\$nginx_version/\"${sbj}\"/" conf/fastcgi.conf > conf/fastcgi.conf.tmp ;\
    rm -fr conf/fastcgi.conf ;\
    mv conf/fastcgi.conf.tmp conf/fastcgi.conf ;\
    sed -e "s/nginx\/\$nginx_version/\"${sbj}\"/" conf/fastcgi_params > conf/fastcgi_params.tmp ;\
    rm -fr conf/fastcgi_params ;\
    mv conf/fastcgi_params.tmp conf/fastcgi_params ;\
    # Nginx - 编译
    make -j${make_j:-1} ;\
    make install ;\
    # PHP8 - 安装依赖
    yum install -y autoconf libxml2 libxml2-devel openssl openssl-devel zlib-devel curl-devel libjpeg-devel libpng-devel freetype-devel mhash-devel mcrypt libmcrypt libmcrypt-devel libwebp libwebp-devel mhash mhash-devel gcc gcc-c++ make automake libsqlite3x libsqlite3x-devel libicu libicu-devel oniguruma oniguruma-devel cmake3 ;\
    # PHP8 - 编译libzip
    cd /root/hazx/php8 ;\
    tar zxvf libzip-1.8.0.tar.gz ;\
    cd libzip-1.8.0 ;\
    mkdir build && cd build ;\
    ln -s /bin/cmake3 /bin/cmake ;\
    cmake3 .. ;\
    make -j${make_j:-1} ;\
    make install ;\
    ln -s /usr/local/lib64/libzip.so /usr/lib64/libzip.so ;\
    ln -s /usr/local/lib64/pkgconfig/libzip.pc /usr/lib64/pkgconfig/libzip.pc ;\
    ln -s /usr/local/lib64/libzip.so.5.1 /usr/lib64/libzip.so.5.1 ;\
    ln -s /usr/local/lib64/libzip.so.5 /usr/lib64/libzip.so.5 ;\
    # PHP8 - 编译PHP8
    cd /root/hazx/php8 ;\
    tar zxvf php-8.0.13.tar.gz ;\
    cd php-8.0.13 ;\
    ./configure \
        --prefix=/web_server/php \
        --with-config-file-path=/web_server/php/etc \
        --enable-fpm \
        --enable-bcmath \
        --enable-ftp \
        --enable-mbstring \
        --enable-soap \
        --enable-opcache \
        --enable-intl \
        --enable-mysqlnd \
        --enable-calendar \
        --enable-exif \
        --enable-xml \
        --enable-sockets=shared \
        --enable-gd \
        --with-gettext \
        --with-openssl \
        --with-zlib \
        --with-curl \
        --with-mhash \
        --with-mysqli \
        --with-pdo-mysql \
        --with-libdir=lib64 \
        --with-iconv \
        --with-pdo_sqlite \
        --with-sqlite3 \
        --with-zip \
        --with-libxml \
        --without-pear \
        --disable-fileinfo ;\
    make -j${make_j:-1} ;\
    make install ;\
    cp ./php.ini-production /web_server/php/etc/php.ini ;\
    mv /web_server/php/etc/php-fpm.conf.default /web_server/php/etc/php-fpm.conf ;\
    mv /web_server/php/etc/php-fpm.d/www.conf.default /web_server/php/etc/php-fpm.d/www.conf ;\
    # 清理
    yum clean all ;\
    rm -rf /var/cache/yum ;\
    chmod +x /root/hazx/save.sh

CMD  echo "make ok."

