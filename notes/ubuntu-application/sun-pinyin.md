---
layout: post
title: sun-pinyin
description: sun-pinyin
---

ubuntu安装ibus-sunpinyin

1. 到http://code.google.com/p/sunpinyin/downloads/list下载
    ibus-sunpinyin-2.0.3.tar.gz
    sunpinyin-2.0.3.tar.gz

2. 安装sunpinyin
    为了编译SunPinyin基本库你需要安装以下的工具
    C++编译器 (sudo aptitude install build-essential)
    sqlite3 (sudo apt-get install sqlite3 libsqlite3-dev)
    SCons (sudo apt-get install scons)
    ibus > 1.2
    gettext
    sudo apt-get install libtool libibus-dev libgtk2.0-dev debhelper autotools-dev

    tar zxvf sunpinyin-2.0.3.tar.gz
    cd sunpinyin-2.0.3
    scons --prefix=/usr
    sudo scons install

3. 安装ibus-sunpinyin
    tar zxvf ibus-sunpinyin-2.0.3.tar.gz
    cd ibus-sunpinyin-2.0.3
    scons --prefix=/usr
    sudo scons install

    对于ibus，建议安装到/usr prefix，主要是因为怕ibus无法加载ibus-sunpinyin。

    重启ibus来查看是否安装成功。
