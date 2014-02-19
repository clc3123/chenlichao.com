---
layout: post
title: Mac OSX Tips搜集中...
description: 超哥搜集的Mac OSX系统常用设置，命令行小妙招
---

## 设置computername和hostname等

computername会出现在bash的prompt中：

    $ scutil --get ComputerName
    $ scutil --set ComputerName clc3123-mba

也可以直接设置hostname：

    $ scutil --set HostName clc3123-mba

## /usr/bin/say

    $ say you bastard, you should rest for a while

用 `$ crontab -e` 写入到cron任务中，完全没必要装什么番茄工作法之类的软件。

## Homebrew

安装前先下载安装 `Command Line Tools for Xcode`

访问下面的下载页面，需要先注册一个Apple开发者帐号

<https://developer.apple.com/downloads/index.action>

## Automator

The robot in the icon for Apple's Automator, which also uses a pipeline concept to chain repetitive commands together, holds a pipe in homage to the original Unix concept.

<http://en.wikipedia.org/wiki/Pipeline_(Unix)>

## 屏幕截图

<http://guides.macrumors.com/screencapture>

命令行操作截图：

    $ screencapture -iW ~/Desktop/test.jpg

<http://guides.macrumors.com/Taking_Screenshots_in_Mac_OS_X>

改变系统默认的截图设置：

Screenshot format. default: `png`

    $ defaults write com.apple.screencapture type jpg

Location to save screenshots. default: `~/Desktop/`

    $ defaults write com.apple.screencapture location ~/Pictures/Screenshots/

Whether screenshots of windows should show shadows. default: `false`

    $ defaults write com.apple.screencapture disable-shadow -bool true

Filename prefix for screenshots. default: `Screenshot`

    $ defaults write com.apple.screencapture name "Screen Capture"
