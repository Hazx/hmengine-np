# HMEngine-np

HMEngine-np 是一个 Nginx + PHP8 的 Docker 镜像，如果你有需要可以拿去参考使用。

对应镜像及版本：`hazx/hmengine-np:2.4.1`

# 目录说明

- `1.Make`：编译阶段需要用到的目录，若你不需要打包成Docker镜像，而是只使用编译好的二进制程序，可以只使用此目录。
- `2.Package`：镜像打包阶段需要用到的目录。
- `3.Run`：运行镜像时所需要映射的目录示例，含 Nginx 和 PHP 的示例配置文件。

# 镜像内容
## 软件版本

- Nginx：1.20.2
- PHP：8.0.13

## 编译参数

### Nginx

```shell
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
--disable-fileinfo
```

# 使用镜像

你可以直接下载使用我编译好的镜像 `docker pull hazx/hmengine-np:2.4.1`，你也可以参照 [编译和打包](#编译和打包) 部分的说明自行编译和打包镜像。

## 需要做映射的内部路径

- Nginx 配置目录：`/web_server/nginx/conf`
- PHP 配置目录：`/web_server/php/etc`
- WEB 文件目录：`/home/web`（非必须设定此路径，依Nginx配置文件而定）
- 日志文件目录：`/home/web_log`（非必须设定此路径，依配置文件而定）
- mysql_sock 文件：`/home/mysql.sock`（非必须设定此路径，依PHP配置文件而定）

> 如果你需要改变 WEB、日志、sock 或其他路径映射，你需要注意修改 Nginx 及 PHP 配置文件的相应路径参数。

> WEB 文件需要具备 `1000:1000` 归属权限，若映射到 `/home/web`，容器在启动时会自动处理权限。

## 需要做映射的内部端口

- 80：Nginx - HTTP
- 443：Nginx - HTTPS

## 创建容器

```shell
docker run -d \
    -p 80:80 \
    -p 443:443 \
    -v /home/hmengine-np/3.Run/example_nginx:/web_server/nginx/conf \
    -v /home/hmengine-np/3.Run/example_php:/web_server/php/etc \
    -v /home/hmengine-np/3.Run/example_website/web:/home/web \
    -v /home/hmengine-np/3.Run/example_website/web_log:/home/web_log \
    --name web_server \
    --restart unless-stopped \
    hazx/hmengine-np:2.4.1
```

# 编译和打包

*需要注意，编译和打包阶段需要 Docker 环境，且依赖互联网来安装编译和运行环境。*

## 编译 Nginx 和 PHP

> 编译阶段下载安装的依赖环境不会应用到你的系统环境，且在编译完成后不保留临时编译环境镜像。

在 `1.Make` 文件夹下，你可以按你的需求修改 `Dockerfile`，Nginx 和 PHP 的编译参数都写在 `Dockerfile` 文件中。

执行编译：

```shell
chmod +x start_make.sh && ./start_make.sh
```

若你的主机是多核CPU，你可以使用多线程编译来加快编译速度。假如你的CPU是4核8线程，你可以这样执行：

```shell
chmod +x start_make.sh && ./start_make.sh 4
```

完成编译后，当前目录下会自动生成一个名为 `make_data` 的文件夹，里面存放着编译好的 Nginx 和 PHP 的程序文件。若你还要进行镜像打包，请不要重命名或移动此文件夹。

## 打包镜像

> 在打包前需确定已完成编译工作，且 `1.Make` 目录下已经生成了一个名为 `make_data` 的非空文件夹。

在 `2.Package` 文件夹下，你可以按你的需求修改 `Dockerfile` 以跟编译结果相对应。

执行镜像打包：

```shell
chmod +x pkg_images.sh && ./pkg_images.sh
```
若想自定义镜像名称和tag，你可以这样执行：
```shell
chmod +x pkg_images.sh && ./pkg_images.sh test:v1
```




