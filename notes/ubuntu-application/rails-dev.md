---
layout: post
title: rails-dev
description: rails-dev
---

Rails
=====

安装一些基础软件：
    $ sudo apt-get install curl tree git-core qgit gitg giggle vim screen byobu
    $ sudo apt-get install ack-grep
    $ sudo ln -s $(which ack-grep) /usr/local/bin/ack # 这样vim-ack才能用

Ack 推荐安装single file版本，http://beyondgrep.com/install/

    $ gem install rails
    $ rails new -h # 察看新建项目帮助和各种选项
    $ rails new myapp -T -d postgresql # 不使用TestUnit，使用PostgreSQL
    $ rails generate rspec:install # 安装RSpec后，生成app需要的测试文件

Rails常用命令：
-   To generate a secret key for an existing application, run
    "rake secret" and set the key in config/initializers/secret_token.rb.
-   各种rails generator列表 
        $ rails g -h

$ gem sources --remove http://rubygems.org/
$ gem sources -a http://ruby.taobao.org/

安装rmagick或minimagick时需要：
    $ sudo apt-get install imagemagick libmagickwand-dev

生成所有数据库：
    $ rake db:create:all

使用enterprisedb的postgresql安装包的话，在安装pg gem的时候可能会报错，
如果还有使用bundler，请按照以下方法解决：
    $ bundle config build.pg --with-pg-dir=/opt/PostgreSQL/9.2
详见：
    http://gembundler.com/man/bundle-config.1.html

导出Dev数据库Schema：
    $ rake db:schema:dump # dump schema in Ruby format
    $ rake db:structure:dump # dump schema in SQL format

Test数据库导入Dev数据库的Schema（dump，load一条龙）：
    $ rake db:test:clone # Load Ruby schema file
    $ rake db:test:clone_structure # Load SQL schema file

详见: activerecord-3.2.2/lib/active_record/railties/databases.rake

$ tail -f log/development.log # 查看开发日志

$ rails console production # rails c 进入指定的环境

本地服务器切换到指定的环境
    $ rails server --environment ENV # webrick
    $ thin start -e production # thin

重置数据库
    $ rake db:reset

TDD Tools
=========

Rspec
-----

$ rails generate rspec:install

个人理解Spork的机制：
Rspec启动的时候，如果在启动配置中包含了Drb的选项，就会主动去寻找Drb测试服务器。接着Spork在spec_helper中被加载时，会询问Rspec之前是否找到了Drb服务器：如果有，则会施展魔法，在测试服务器上跑测试；如果没有，Spork则会将prefork和each_run中的block在本地进程中运行。所以说，如果Rspec运行时未使用Drb模式，即使spec_helper中加载了Spork，也无法展现魔法。

Spork: for Rspec & Cucumber
---------------------------

> https://github.com/sporkrb/spork 
> 以下内容对应1.0.0以后的版本

增加到Gemfile中：
    gem 'spork'
    gem 'spork-rails'

$ spork rspec --bootstrap

运行测试服务器：
    $ spork

运行rspec时加入以下flag，或者将其加入.rspec文件
    --colour
    --drb

Guard
-----
增加到Gemfile中：
    gem 'guard'
    gem 'guard-spork'
    gem 'guard-rspec'
    gem 'guard-livereload'
    gem 'libnotify' 

在项目目录下生成默认配置文件.Guardfile：
    $ guard init
    $ guard init spork/rspec/livereload

IMPORTANT: Place Spork guard before RSpec/Cucumber/Test::Unit guards!
    $ rake db:create:all
