---
layout: post
title: mongodb
description: mongodb
---

http://www.mongodb.org/display/DOCS/Ubuntu+and+Debian+packages

添加GPG key (wtf???)
$ sudo apt-key adv --keyserver keyserver.ubuntu.com --recv 7F0CEB10

将下面这行加入/etc/apt/sources.list
deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen

$ sudo apt-get update
$ sudo apt-get install mongodb-10gen

