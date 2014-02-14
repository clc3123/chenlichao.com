---
layout: post
title: x-server
description: x-server
---

服务器端
========

<https://help.ubuntu.com/community/ServerGUI>

X11 Client Installation
-----------------------

You may find it preferable to only run specific X11 clients on the server,
and forward the X11 connections over ssh to display them on your desktop of choice.

This way you avoid the need for an X11 server or desktop environment on the server itself.

But note on the other hand that this opens up different vulnerabilities
if the remote desktop can be compromised.

To do this, install the xauth package, then simply install the applications you need, and apt-get will bring in other packages as needed to satisfy the dependencies.

    $ sudo apt-get install xauth openssh-server

X11 Server Installation
-----------------------

如果需要在服务器安装图形环境，可以选择：

+   X Window Server

        $ sudo apt-get install xserver-xorg xserver-xorg-core

+   xvfb, in-memory, fake X server

        $ sudo apt-get install xvfb

    后者可配合Headless Gem和Firefox，来做服务器端的浏览器模拟。

管理员端
========

可通过ssh直连服务器端的X11程序，这样服务器端就不需要为这些需要图形界面的程序专门安装X Server。

    $ ssh -X root@linode firefox/emacs
