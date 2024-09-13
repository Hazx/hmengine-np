# HMengine-np

HMengine-np 是一个 Nginx + PHP8 的 Docker 镜像，如果你有需要可以拿去参考使用。

对应镜像及版本：

- `hazx/hmengine-np:3.0`
- `hazx/hmengine-np:3.0-arm`


# 目录说明

- `build`：编译打包镜像所需要用到的目录。
- `example`：运行镜像时所需要映射的目录示例，含 Nginx 和 PHP 的示例配置文件。


# 组件版本

- Nginx：1.26.2
- PHP：8.3.11
- OpenSSL：3.3.1
- PCRE：8.45
- Zlib：1.3.1
- Libzip：1.10.1

# 使用镜像

你可以直接下载使用我编译好的镜像 `docker pull hazx/hmengine-np:3.0`（ARM64 平台使用 `3.0-arm`），你也可以参照 [编译与打包](#编译与打包) 部分的说明自行编译打包镜像。

## 需要做映射的内部路径

- Nginx 配置目录：`/web_server/nginx/conf`
- PHP 配置目录：`/web_server/php/etc`
- WEB 文件目录：`/web_server/html`（非必须设定此路径，依 Nginx 的配置文件而定）
- 日志文件目录：`/web_server/logs`（非必须设定此路径，依 Nginx 及 PHP 的配置文件而定）
- MySQL 管道文件：`/web_server/mysql.sock`（非必须设定此路径，依 PHP 的配置文件而定）

> 如果你需要改变 WEB、日志、sock 或其他路径映射，你需要注意修改 Nginx 及 PHP 配置文件的相应路径参数。

## 需要做映射的内部端口

- 80：Nginx - HTTP（默认端口）
- 其他端口依配置文件而定

## 创建容器示例

以下命令以将文件释放在目录 `/opt/hmengine-np` 下为例，实际操作请以实际情况为准。

```shell
docker run -d \
    -p 80:80 \
    -v /opt/hmengine-np/example/nginx:/web_server/nginx/conf \
    -v /opt/hmengine-np/example/php:/web_server/php/etc \
    -v /opt/hmengine-np/example/website:/web_server/html \
    -v /opt/hmengine-np/example/logs:/web_server/logs \
    --name web_server \
    --restart unless-stopped \
    hazx/hmengine-np:3.0
```

## 环境变量

环境变量 | 默认值 | 参数值 | 功能说明
---|---|---|---
NGINX_ONLY | false | false / true | 只启动 Nginx
NGINX_WORKER_PROCESSES | 1 | auto / 数字 | Nginx Worker 数量
NGINX_GZIP | on | on / off | Gzip 压缩
NGINX_PORT | 80 | 数字 | WEB 端口
PHP_PORT | 9000 | 数字 | PHP 工作端口
PHP_MAX_CHILD | 5 | 数字 | PHP 最大进程数
PHP_STR_SVC | 2 | 数字 | PHP 初始化进程数
PHP_MIN_SPARE | 1 | 数字 | PHP 最小空闲进程数
PHP_MAX_SPARE | 5 | 数字 | PHP 最大空闲进程数
PHP_MEM_LIMIT | 256M | 数字+容量单位 | PHP 脚本运行内存限制
PHP_MAX_POST | 8M | 数字+容量单位 | PHP POST 大小限制
PHP_MAX_UPLOAD | 64M | 数字+容量单位 | PHP 上传大小限制
REQ_TIMEOUT | 60 | 数字 | 请求超时时间·秒（Nginx、PHP 所有相关参数）

*环境变量仅在使用 Nginx 及 PHP 相应自带的默认配置文件且首次启动时生效。*


# 编译与打包

*需要注意，编译和打包阶段需要 Docker 环境，且依赖互联网来安装编译和运行环境。*

## 编译并打包

> 编译阶段下载安装的依赖环境不会应用到你的系统环境，且在编译完成后不保留临时编译环境镜像。

你可以按需修改 `build` 文件夹下的内容。

然后执行以下命令开始编译与打包：

```shell
bash build.sh
```

编译过程默认采用 2 线程进行，若你想提高编译线程数，可以执行如下命令，在结尾带上线程数字：

```shell
bash build.sh 8
```

## 编译参数

编译默认采用如下参数配置 Nginx 与 PHP，如有特殊需求可自行修改。

### Nginx

```shell
./configure \
    --prefix=/web_server/nginx \
    --with-openssl=/path/to/openssl \
    --with-zlib=/path/to/zlib \
    --with-http_ssl_module \
    --with-http_sub_module \
    --with-http_stub_status_module \
    --with-http_secure_link_module \
    --with-pcre \
    --with-pcre-jit \
    --with-http_realip_module \
    --with-http_dav_module \
    --with-http_v2_module
```

### PHP

```shell
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
    --with-openssl=/path/to/openssl \
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
    --disable-fileinfo
```




