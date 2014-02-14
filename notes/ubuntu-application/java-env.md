---
layout: post
title: java-env
description: java-env
---

ubuntu 12.04 LTS 64bit
==============================

以下如非注明均为服务器端操作

(本地)先下载好jdk, 用scp上传到服务器; 然后ssh登录服务器
------------------------------

    $ scp ~/Downloads/jdk-7u9-linux-x64.tar.gz root@218.245.3.174:~/
    $ ssh root@218.245.3.174

升级系统
------------------------------

    $ apt-get update
    $ apt-get upgrade
    $ apt-get install vim htop

安装mysql
------------------------------

    $ apt-get install mysql-server mysql-client
    $ vi /etc/mysql/my.cnf # 自行修改mysql配置文件

安装oracle jdk7(非openjdk)
------------------------------

可参考: 
    http://maketecheasier.com/install-java-runtime-in-ubuntu/2012/05/14
    https://help.ubuntu.com/community/Java#Choosing_the_default_Java_to_use
    http://www.webupd8.org/2012/01/install-oracle-java-jdk-7-in-ubuntu-via.html # 偷懒安装 
    http://forum.ubuntu.org.cn/viewtopic.php?t=183803 # jdk6

以下为详细安装方法:
    $ cd
    $ tar xzvf jdk-7u9-linux-x64.tar.gz
    $ mv jdk1.7.0_09 /usr/lib/jvm/
    $ update-alternatives --install /usr/bin/javac javac /usr/lib/jvm/jdk1.7.0_09/bin/javac 1
    $ update-alternatives --install /usr/bin/java java /usr/lib/jvm/jdk1.7.0_09/bin/java 1
    $ update-alternatives --config javac
    $ update-alternatives --config java
    $ java -version # 看看是不是oracle jdk

安装tomcat
------------------------------

tomcat的ubuntu文档: http://wiki.ubuntu.org.cn/Tomcat

    $ apt-get install tomcat # 源安装

本地打开浏览器访问 http://218.245.3.174:8080 测试一下

