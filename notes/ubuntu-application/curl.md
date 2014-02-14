---
layout: post
title: curl
description: curl
---

## 常用命令行参数
---
-A, --user-agent <agent string>
  (HTTP) Specify the User-Agent string to send to the HTTP server.
-b, --cookie <name=data>
  (HTTP)  Pass the data to the HTTP server as a cookie.
-d, --data <data>
  (HTTP) Sends the specified data in a POST request  to  the  HTTP
  server,  in  the  same  way  that a browser does when a user has
  filled in an HTML form and presses the submit button. This  will
  cause curl to pass the data to the server using the content-type
  application/x-www-form-urlencoded.
-D, --dump-header <file>
  Write the protocol headers to the specified file.
  This  option is handy to use when you want to store the headers
  that a HTTP site sends to you.
--data-urlencode <data>
  (HTTP) This posts data, similar to the other --data options with
  the exception that this performs URL-encoding.
-i, --include
  (HTTP)  Include  the  HTTP-header in the output. The HTTP-header
  includes things like server-name, date of  the  document,  HTTP-
  version and more...
-I, --head
  (HTTP/FTP/FILE) Fetch the HTTP-header only! HTTP-servers feature
  the command HEAD which this uses to get nothing but  the  header
  of  a  document.
-H, --header <header>
  (HTTP) Extra header to use when getting  a  web  page.
-F, --form <name=content>
  (HTTP)  This  lets curl emulate a filled-in form in which a user
  has pressed the submit button. This causes  curl  to  POST  data
  using  the  Content-Type  multipart/form-data  according  to RFC
  2388. This enables uploading of binary files etc.
--cacert <CA certificate>
  (SSL) Tells curl to use the specified certificate file to verify
  the peer. The file may contain  multiple  CA  certificates.  The
  certificate(s)  must be in PEM format. Normally curl is built to
  use a default file for this, so this option is typically used to
  alter that default file.
--keepalive
--no-keepalive
--keepalive-time <seconds>
-X, --request <command>
  (HTTP) Specifies a custom request method to use when communicat‐
  ing  with  the  HTTP server.  The specified request will be used
  instead of the method otherwise used (which  defaults  to  GET).
  Read  the  HTTP  1.1 specification for details and explanations.
  Common additional HTTP requests  include  PUT  and  DELETE,  but
  related technologies like WebDAV offers PROPFIND, COPY, MOVE and
  more.
-0, --http1.0
  (HTTP)  Forces curl to issue its requests using HTTP 1.0 instead
  of using its internally preferred: HTTP 1.1.
-o, --output
-s, --silent

## 用apt-get安装
---
$ sudo apt-get install curl libssl-dev gnutls-bin libcurl4-gnutls-dev

由于许可证问题ubuntu支持gnutls，而非openssl，所以apt-get安装的curl使用的是gnutls。
详细的编译选项可以查看：
$ curl-config --configure

## 编译安装
---
如果编译时支持的是openssl，可以先安装：
$ sudo apt-get install openssl libcurl4-openssl-dev

$ ./configure --with-ssl --prefix=/usr # --with-ssl默认对应openssl
$ sudo make
$ sudo make install

详细文档，包括用gnutls代替openssl时的编译选项
http://curl.haxx.se/docs/install.html

## 获取对方服务器公钥
---
Use the s_client command line tool that comes with OpenSSL.
It negotiates an SSL connection, step by step,
and prints debugging info in excruciating detail.
It also includes a dump of the server-side SSL certificate
in PEM format. You can use that certificate to test offline,
import into your client-side keystore, or anything else.

$ openssl s_client -connect ${REMHOST}:${REMPORT}

示例如下：
$ openssl s_client -connect api.weibo.com:443
$ openssl s_client -connect graph.qq.com:443

## Rails Mass Assignment
---
curl -X POST -d
"user[name]=hh&user[email]=clc@ddd.com&user[password]=jjjjjj&user[password_confirmation]=jjjjjj&user[micropost_ids][]=1&user[micropost_ids][]=2&user[admin]=true&commit=Sign up"
http://super.man:3000/users/

curl -d
"user[name]=hacker&user[admin]=1&user[comment_ids][]=1&user[comment_ids][]=2"
http://localhost:3000/users/create

curl -d "utf8=✓&authenticity_token=ibo0vJGpBZ8NzcE7gaGsV/DA3KWBm5PlFWknb8eIcQY=&gear[name]=AD&gear[shortcut]=ag3&gear[total_distance]=300" http://mozeal.dev:3000/gears.xml
