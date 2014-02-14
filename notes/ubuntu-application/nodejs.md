---
layout: post
title: nodejs
description: nodejs
---

预编译版本：
https://github.com/joyent/node/wiki/Installing-Node.js-via-package-manager
    $ sudo apt-get install python-software-properties python g++ make
    # $ sudo apt-get install software-properties-common
    $ sudo add-apt-repository ppa:chris-lea/node.js
    $ sudo apt-get update
    $ sudo apt-get install nodejs npm

下载编译安装：
https://github.com/joyent/node/wiki/Installation
    $ git clone --depth 1 git://github.com/joyent/node.git # or git clone git://github.com/joyent/node.git if you want to checkout a stable tag
    $ cd node
    $ git checkout v0.4.12 # optional.  Note that master is unstable.
    $ ./configure
    $ make -j2 # -j sets the number of jobs to run
    $ [sudo] make install
