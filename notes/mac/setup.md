---
layout: post
title: setup
description: setup
---

设置computername和hostname等
============================

computername会出现在bash的prompt中：

    $ scutil --get ComputerName
    $ scutil --set ComputerName clc3123-mba

也可以直接设置hostname：

    $ scutil --set HostName clc3123-mba

Homebrew
========

注意安装前先下载安装command line developer tools

Automator
=========

The robot in the icon for Apple's Automator, which also uses a pipeline concept to chain repetitive commands together, holds a pipe in homage to the original Unix concept.

<http://en.wikipedia.org/wiki/Pipeline_(Unix)>
