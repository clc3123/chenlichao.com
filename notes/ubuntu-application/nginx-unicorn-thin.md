---
layout: post
title: nginx-unicorn-thin
description: nginx-unicorn-thin
---

Nginx
=====

$ nginx -h # 查看帮助
$ nginx -t # 测试配置文件

Ubuntu PPA 安装
---------------
$ sudo apt-get install python-software-properties
$ sudo add-apt-repository ppa:nginx/stable
$ sudo apt-get update
$ sudo apt-get install nginx

编译安装
--------

编译需要的包：
    $ sudo apt-get install gcc libpcre3 libpcre3-dev zlib1g zlib1g-dev openssl libssl-dev

默认安装，能用但可能缺少一些要用到的功能:
    $ ./configure
    $ make
    $ sudo make install

查看所有可选的configure参数：
    $ ./configure --help

更多配置(这里把nginx安装在/opt/nginx中)：
    $ sudo adduser          \
        --system            \
        --no-create-home    \
        --disabled-login    \
        --group nginx
或者：
    $ sudo useradd -s /bin/false -r nginx

    $ ./configure                      \
        --prefix=/opt/nginx-1.2.8      \
        --user=nginx                   \
        --group=nginx                  \
        --with-http_ssl_module         \
        --with-http_stub_status_module \
        --with-http_gzip_static_module \
        --with-http_realip_module      \
        --with-ipv6                    \
        # --without-http_charset_module
        # --without-http_auth_basic_module
        # --without-http_userid_module
        # --without-http_fastcgi_module
        # --without-http_memcached_module
        # --without-http_map_module
        # --without-http_geo_module
        # --without-http_autoindex_module

一些有趣的编译参数，还没时间研究，先列出：
    --with-pcre-jit

设置init script为可执行：
    $ sudo chmod 770 /etc/init.d/nginx
设置init script自动启动(与Thin的设置类似)：
    $ sudo update-rc.d -f nginx defaults 80 20 # 具体查看man update-rc.d

可以在/etc/default/nginx中进行其它设置,init script会一并导入.
比如可以设置ulimit等.

Sample Configuration
--------------------

    user nginx nginx;
    worker_processes 2;
    pid /var/run/nginx.pid;
    
    events {
      worker_connections 768;
      # multi_accept on;
    }
    
    http {
      sendfile on;
      tcp_nopush on;
      tcp_nodelay on;
      keepalive_timeout 60;
      
      include /etc/nginx/mime.types;
      default_type application/octet-stream;
      
      access_log /var/log/nginx/access.log;
      error_log /var/log/nginx/error.log;
      
      gzip on;
      gzip_disable "MSIE [1-6]\.";
      gzip_proxied any;
      gzip_types text/plain text/html text/xml text/css 
                 text/javascript application/json application/x-javascript
                 application/atom+xml application/xml+rss;
      
      # gzip_vary on;
      # gzip_comp_level 6;
      # gzip_buffers 16 8k;
      # gzip_http_version 1.1;
      
      include /etc/nginx/conf.d/*.conf;
      include /etc/nginx/sites-enabled/*;
    }

Thin
====

+ 生成Thin开机启动脚本/etc/init.d/thin和放App启动配置的文件夹/etc/thin
    $ rvmsudo thin install
+ 设置Thin开机启动(debian)
    $ sudo /usr/sbin/update-rc.d -f thin defaults 19 21
+ 为App设置启动选项(-d已经是默认的了),设置放到/etc/thin文件夹下,如下例:
    $ rvmsudo thin config -C /etc/thin/testapp.yml -c /home/projects/testapp/ -s 3 -e production -p 8000
+ 这样服务器重启之后Thin和相关的App就自动启动了.还可以通过以下命令来控制:
      $ sudo /etc/init.d/thin start|stop|restart
  但这样是对所有/etc/thin/里的设置文件所针对的App进行操作.单独对App操作也是可以的.

关于RVM Wrapper的使用(可能用的上),可以参考这几篇文章:
    http://jsani.com/2011/09/ubuntu-10-xx-nginx-thin-rails-3-a-how-to/
    http://deepakprasanna.blogspot.com/2011/06/rvm-wrappers.html
    http://beginrescueend.com/integration/god/
    http://beginrescueend.com/integration/cron/
