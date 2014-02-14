---
layout: post
title: git
description: git
---

Setting up a Git server
=======================

http://progit.org/book/zh/ch4-4.html

Git Commands
============

git checkout -f
强制取消已作出的变化（尤其是删除文件后适用）

git checkout -b branchname
新建branch后立即转入新branch

git mv oldname newname
git中的重命名

git mv file dir
移动文件

git commit -m message
直接在命令行内输入commit信息

git submodule管理
http://josephjiang.com/entry.php?id=342

git submodule add git://github.com/tobi/delayed_job.git ./vendor/delayed_job
添加submodule，必须是在主项目根目录下执行。比如以上就是在主项目根目录下的vendor文件夹中放入delayed_job文件夹。

git submodule init
git submodule update
git submodule foreach git pull origin master

How to remove a submodule?
http://stackoverflow.com/questions/1260748/how-do-i-remove-a-git-submodule

git ls-remote remotename branchname
获取远程分支最新commit的SHA。

Git Setting
===========

$ git config --global core.editor "vim"
$ git config --global alias.co checkout
$ git config --global color.ui true

$ git config --global user.name clc3123
$ git config --global user.email clc3123@gmail.com

Multiple Github Accounts
========================

假设你有两个Github帐号，用户名分别为first和second。

为second用户生成第二对密钥对second_id_rsa：
    $ ssh-keygen -t -rsa -C "second@example.com" -f ~/.ssh/second_id_rsa

将second_id_rsa的公钥添加到Github。

默认SSH只读取到id_rsa，所以为了让SSH识别新的私钥，需要将其添加到SSH agent：
    $ ssh-add ~/.ssh/second_id_rsa

完成以上步骤后在~/.ssh目录创建config文件：
    $ cd ~/.ssh
    $ touch config
    $ chmod 600 config

修改config的内容为：
    # Default github user (first@example.com)
    Host github.com
        HostName github.com
        IdentityFile ~/.ssh/id_rsa
    
    # Second github user (second@example.com)
    Host second.github.com
        HostName github.com
        IdentityFile ~/.ssh/second_id_rsa

配置完成后，在添加second帐号的github仓库时，origin的地址要对应地做一些修改，
比如现在添加second帐号下的一个仓库example，则需要这样添加：
    $ git remote add origin git@second.github.com:second/example.git
仓库地址并非原来的git@github.com:second/example.git

这样每次连接都会使用second_id_rsa与服务器进行连接。至此，大功告成！

注意：github根据配置文件的user.email来获取github帐号显示author信息，所以对于多帐号用户一定要记得将user.email改为相应的email(second@mail.com)。

编译安装 gitg 0.2.5
===================

$ sudo apt-get install libgtk-3-dev libgtksourceview-3.0-dev gsettings-desktop-schemas-dev
$ tar xjf gitg-0.2.5.tar.bz2
$ cd gitg-0.2.5
$ ./configure
$ sudo make && sudo make install
