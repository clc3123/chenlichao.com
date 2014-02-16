---
layout: post
title: rvm
description: rvm
---

安装rvm
-------

RVM官方安装教程： <https://rvm.io/rvm/install/>

安装RVM之前必须先装：

    $ sudo apt-get install curl git

### 单用户模式，不能加sudo

    $ curl -sSL https://get.rvm.io | bash -s -- stable --without-gems="rvm rubygems-bundler"
    $ source ~/.rvm/scripts/rvm
    $ type rvm | head -1 # 确认rvm加载成功
    $ rvm autolibs status # 查看rvm安装ruby依赖时采用的模式
    $ rvm requirements # 自动安装依赖，可能要sudo权限

至于rvm执行requirements时在系统中都装了啥，可以看源码： <https://github.com/wayneeseguin/rvm/tree/master/scripts/functions/requirements>

也可以在安装ruby时才授权autolibs：

    $ rvm install 1.9.3 --autolibs=4

### multi-user模式，以非root用户安装，并要加sudo

    $ curl -sSL https://get.rvm.io | sudo bash -s -- stable --without-gems="rvm rubygems-bundler"
    $ sudo usermod -a -G rvm clc3123 # 将需要使用rvm的用户加入group rvm

这个模式下，rvm被安装到`/usr/local/rvm/`

先退出shell session再进入一个新的session，确认是否能调用rvm了。

如何通过sudo或cron等调用rvm管理的ruby及gem binary
-------------------------------------------------

一种方法是rvm wrapper，详见`$ rvm wrapper`。这种方法在`$rvm_path/bin`下面生成wrapper脚本。这种方式的缺点是所有ruby环境的wrapper挤在一起。

<https://github.com/rvm/gem-wrappers>

第二种方法比较智能。在rvm 1.25以后版本中，rvm会附带安装`gem-wrappers` gem。它的作用是在安装gem时自动生成gem binary在当前ruby环境下的wrapper脚本。

比如我们在ruby-2.0.0-p353下安装`$ gem install pry`，就会在`$rvm_path/wrappers/ruby-2.0.0-p353/pry`下生成这么一个wrapper，在sudo和cron中调用它就好了。

我们还可以重新生成当前ruby环境的wrappers：

    $ gem wrappers regenerate

关于bundle exec
---------------

rvm官方推荐了2种方案来“杜绝”bundle exec

<https://rvm.io/integration/bundler/>

1.  在1.11.0版本之后，`rubygems-bundler`成为了rvm每个ruby版本global默认安装的gem

    这样所有的gem binary都变成bundler-aware了，不用输入bundle exec了

        $rvm_path/gemsets/default.gems
        $rvm_path/gemsets/global.gems

    在以上两个地方可以分别查看和设置global和default安装的gem

2.  启用`after_cd_bundler`这个rvm hook，要配合bundler的binstubs选项来用

个人觉得多打一个bundle exec又能怎样？

提高Ruby安装速度
----------------

FOR MAC
    $ sed -i .bak 's!ftp.ruby-lang.org/pub/ruby!ruby.taobao.org/mirrors/ruby!' $rvm_path/config/db
FOR LINUX
    $ sed -i 's!ftp.ruby-lang.org/pub/ruby!ruby.taobao.org/mirrors/ruby!' $rvm_path/config/db

常用命令
--------

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
