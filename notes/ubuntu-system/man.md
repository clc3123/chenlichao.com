---
layout: post
title: man
description: man
---

man
===

see: `$ man 1 man`

The table below shows the section numbers of the manual followed by the types of pages they contain.

1.  Executable programs or shell commands
2.  System calls (functions provided by the kernel)
3.  Library calls (functions within program libraries)
4.  Special files (usually found in /dev)
5.  File formats and conventions eg /etc/passwd
6.  Games
7.  Miscellaneous (including macro packages and conventions), e.g. man(7), groff(7)
8.  System administration commands (usually only for root)
9.  Kernel routines [Non standard]

常用命令：

    $ man n intro # 查看第n个section的介绍
    $ man -a init # 依次查看名为init的所有man
    $ man -k regexp # 依据regexp搜索相关man
    $ man -f init # 列出名为init的所有man

* * * * * * * * * * * * * * * * * * * * 

<http://stackoverflow.com/questions/62936/what-does-the-number-in-parentheses-shown-after-unix-command-names-mean>

It's the section that the man page for the command is assigned to.

These are split as:

1.  General commands
2.  System calls
3.  C library functions
4.  Special files (usually devices, those found in /dev) and drivers
5.  File formats and conventions
6.  Games and screensavers
7.  Miscellanea
8.  System administration commands and daemons
