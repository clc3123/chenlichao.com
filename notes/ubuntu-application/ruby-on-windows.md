---
layout: post
title: ruby-on-windows
description: ruby-on-windows
---

required
========

1.  rubyinstaller
    http://rubyinstaller.org/downloads/

2.  DevKit
    https://github.com/oneclick/rubyinstaller/wiki/Development-Kit
    
    extract DevKit to dir: <DEVKIT_INSTALL_DIR>
    cd <DEVKIT_INSTALL_DIR>
    ruby dk.rb init
    ruby dk.rb review
    ruby dk.rb install
    
    test:
    gem install rdiscount --platform=ruby
    ruby -rubygems -e "require 'rdiscount'; puts RDiscount.new('**Hello RubyInstaller**').to_html"
    
C:\Ruby193\bin会被加入PATH，可能需要重启系统才能使用其中的软件。

设置编码相关的系统变量，可以在终端输入：
    $ set LC_ALL=en_US.UTF-8
    $ set LANG=en_US.UTF-8
或者在： *计算机》属性》高级系统设置》系统变量》用户变量* 设置这两个变量。

vagrant
=======
