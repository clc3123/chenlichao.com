---
layout: post
title: time-machine
description: time-machine
---

backup over network
==============================

backup on windows
------------------------------

<http://apple.stackexchange.com/a/72374>

The officially sanctioned answer: buy an Apple Time Capsule device.

Unsupported but well-known alternative: enable a hidden option that allows you to use any network drive. Open the Terminal application and run this one command:

    $ defaults write com.apple.systempreferences TMShowUnsupportedNetworkVolumes 1

It will allow you to select any network drive from System Preferences: Time Machine.

The network drive should be a *HFS+* file system over *AFP* (Apple Filing Protocol). I would strongly discourage you from using any other setup if you are not prepared to manually restore one file at a time from the backup.

上面提到了time machine的镜像需要通过afp分享出来，可是在windows上建立afp分享，需要安装第三方软件。因此推荐下面的方法：

1.  先按下面链接中的文章做

    <http://lifehacker.com/5691649/an-easier-way-to-set-up-time-machine-to-back-up-to-a-networked-windows-computer>

2.  在10.8中，上面的方法是有效的；但是10.9中，time machine是选择不了smb分享出来的sparsebundle，因此要增加几个步骤，主要是把sparsebundle挂载为本地磁盘

    <http://apple.stackexchange.com/questions/107032/time-machine-backup-to-an-smb-share-mavericks>

    <http://forums.macrumors.com/showthread.php?t=1425355>

    <http://basilsalad.com/how-to/create-time-machine-backup-network-drive-lion/>

    After you get the sparse bundle created in your desired location, mount the sparse bundle by double clicking it. It should mount just as any other drive or image file will.

    Once that is done, open up terminal and run this command (leave the quotes in place):

        $ sudo tmutil setdestination "/Volumes/Time Machine Backups/"

    Now open up Time Machine and turn it on. You don't have to select your disk, the command in terminal did that for you.

backup on linux
------------------------------

<http://apple.stackexchange.com/a/79720>

I was successful at setting up an Ubuntu 12.04 computer running *netatalk* (AFP) as a file server and backing up two Macs on 10.8 and restoring one after a crash.

<http://archboy.org/2011/08/18/netatalk-afp-linux-share-file-mac-osx-timemachine-backup-server/>

TM Local Snapshot Via CommandLine
=================================

<http://pondini.org/TM/30.html>
<http://pondini.org/TM/Troubleshooting.html>

To turn Snapshots ON:  `$ sudo tmutil enablelocal`  
To turn Snapshots OFF: `$ sudo tmutil disablelocal`
To make a Snapshot:    `$ tmutil snapshot`
