---
layout: post
title: rvm
description: rvm
---

安装rvm
=======

RVM官方安装教程：https://rvm.io/rvm/install/

安装RVM之前必须先装：
    $ sudo apt-get install curl git-core

单用户模式，不能加sudo：
    $ \curl -sSL https://get.rvm.io | bash -s stable --without-gems="rvm rubygems-bundler"
    $ source ~/.rvm/scripts/rvm
    $ type rvm | head -1 # 确认rvm加载成功
    $ rvm requirements # 查看安装ruby时的依赖，还没装的就装上
    $ sudo apt-get --no-install-recommends install build-essential openssl libreadline6 libreadline6-dev curl git-core zlib1g zlib1g-dev libssl-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt-dev autoconf libc6-dev libgdbm-dev ncurses-dev automake libtool bison subversion pkg-config libffi-dev

在新版本的rvm中，上面的后两步有变化：
    $ rvm autolibs 3 # 先授权rvm自动调用包管理
    $ rvm requirements # 再自动安装依赖，可能要sudo权限
也可以在安装ruby时才授权autolibs：
    $ rvm install 1.9.3 --autolibs=3

multi-user模式(要加sudo)：
    $ curl -L get.rvm.io | sudo bash -s stable # 被安装到/usr/local/rvm/
    $ sudo usermod -a -G rvm clc3123 # 将需要使用rvm的用户加入group rvm
可能要先退出session再进入一个新的session才能使用RVM。

关于bundle exec
===============

官方推荐了2种方案来“杜绝”bundle exec
https://rvm.io/integration/bundler/

1.  在1.11.0版本之后，rubygems-bundler成为了rvm每个ruby版本global默认安装的gem
    这样所有的gem binary都变成bundler-aware了，不用输入bundle exec了
        $rvm_path/gemsets/default.gems
        $rvm_path/gemsets/global.gems
    在以上两个地方可以分别查看和设置global和default安装的gem

2.  启用after_cd_bundler这个hook，但要配合bundler的binstubs选项来用

个人觉得第二种方案直观，但是第一种默认方案无需使用binstubs，节省空间

提高Ruby安装速度
================

FOR MAC
    $ sed -i .bak 's!ftp.ruby-lang.org/pub/ruby!ruby.taobao.org/mirrors/ruby!' $rvm_path/config/db
FOR LINUX
    $ sed -i 's!ftp.ruby-lang.org/pub/ruby!ruby.taobao.org/mirrors/ruby!' $rvm_path/config/db

Ruby:
    $ rvm install 1.9.3
    $ rvm rubygems 1.8.10 # 可能ruby附带安装好了
    $ rvm --default use 1.9.3
    $ rvm docs generate #生成ri和rdoc文档
    $ which ruby # 查看正在使用的ruby
    $ gem -v

常用命令
========

rvm get stable ; rvm reload
安装最新的rvm版本，并重启rvm

rvm list known
列出rvm已知可使用的ruby版本

rvm install 1.9.2
安装ruby 1.9.2

rvm use 1.8.7
切换到ruby 1.8.7(必须已安装)

rvm use default
切换到设置为default的ruby版本

rvm remove 1.9.2
移除ruby 1.9.2

rvm --default use 1.9.2
将ruby 1.9.2设置为默认（打开新的shell时默认使用的）

rvm use system
使用系统自带的ruby

rvm reset
将系统自带的ruby设置为default

rvm rubygems 1.7.2
安装特定版本的rubygems

rvm info
查看当前使用的ruby的环境配置

rvm info 1.9.2
查看ruby 1.9.2的环境配置

rvm list rubies
列出所有安装的ruby

rvm list default
列出默认的ruby

rvm 1.8.7 ; rvm gemset create abcd
创建名为abcd的被ruby 1.8.7使用的gemset

rvm use 1.8.7@abcd
或 rvm 1.8.7 ; rvm gemset abcd
切换到ruby 1.8.7下的名为abcd的gemset环境

rvm use 1.8.7@abcd --default
如果加入--default，则ruby 1.8.7默认使用该gemset

rvm gemset name
当前使用的gemset

rvm gemset list/list_all
当前使用的ruby/安装的全部ruby可用的所有gemset

rvm gemset abcd ; rvm gemset delete abcd
删除当前的ruby下的名为abcd的gemset

rvm 1.8.7@abcd gemset export
导出名为abcd.gems的gemset备份

rvm use 1.9.2@ABCD --create ; rvm gemset import abcd
创建ruby 1.9.2下的名为ABCD的gemset，再导入abcd.gems的gemset备份

rvm gemset copy 1.8.7@abcd 1.9.2@ABCD
把前者拷贝一份到后者
