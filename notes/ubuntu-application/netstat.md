---
layout: post
title: netstat
description: netstat
---

查看网络连接
------------

linux

    $ sudo netstat -npltu | grep 21

    -n show numerical addresses
    -p show pid and name of the program to which the socket belongs
    -l list only listening (omitted by default)
    -a list both listening and non-listening
    -t tcp
    -u udp

