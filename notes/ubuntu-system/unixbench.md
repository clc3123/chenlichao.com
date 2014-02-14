---
layout: post
title: unixbench
description: unixbench
---

UnixBench
=========

Project Page: http://code.google.com/p/byte-unixbench/

v4和v5是两个不同的版本，网上很多评测依然还是使用v4的webhostingtalk修改版。

installation
------------

    $ apt-get install build-essential perl perl-modules
    $ apt-get install libx11-dev libgl1-mesa-dev libxext-dev # 桌面系统测试才要的依赖

    $ wget http://byte-unixbench.googlecode.com/files/UnixBench5.1.3.tgz 
    $ tar xzvf UnixBench5.1.3.tgz
    $ cd UnixBench
    $ make
    $ ./Run

To use Unixbench:

1.  UnixBench from version 5.1 on has both system and graphics tests.
    If you want to use the graphic tests, edit the Makefile and make sure
    that the line "GRAPHIC_TESTS = defined" is not commented out; then check
    that the "GL_LIBS" definition is OK for your system.  Also make sure
    that the "x11perf" command is on your search path.

    If you don't want the graphics tests, then comment out the
    "GRAPHIC_TESTS = defined" line.  Note: comment it out, don't
    set it to anything.

2.  Do "make".

3.  Do "Run" to run the system test; "Run graphics" to run the graphics
    tests; "Run gindex" to run both.

You will need perl, as Run is written in perl.

