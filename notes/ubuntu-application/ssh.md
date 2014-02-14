---
layout: post
title: ssh
description: ssh
---

http://www.g-loaded.eu/2005/11/10/ssh-with-keys/
很好的一篇教程。

常用flag
========

-l login_name
    Specifies the user to log in as on the remote machine.  This also
    may be specified on a per-host basis in the configuration file.

-N    
    Do not execute a remote command.  This is useful for just for‐
    warding ports (protocol version 2 only).

-L [bind_address:]port:host:hostport
    Specifies that the given port on the local (client) host is to be
    forwarded to the given host and port on the remote side.  This
    works by allocating a socket to listen to port on the local side,
    optionally bound to the specified bind_address.  Whenever a con‐
    nection is made to this port, the connection is forwarded over
    the secure channel, and a connection is made to host port
    hostport from the remote machine.

-T  
    Disable pseudo-tty allocation.

Server
======

$ sudo apt-get install openssh-server

服务器的DSA，RSA等密钥对存放在/etc/ssh/内，为root所有，并被sshd使用。

请在`/etc/ssh/sshd_config`对sshd进行设置，修改以下行：
    PermitRootLogin no 
    LoginGraceTime 30
    PubkeyAuthentication yes
    PasswordAuthentication no
其它可能用到的指令：
    DenyUsers, AllowUsers, DenyGroups, AllowGroups, ListenAddress,
    MaxSessions, MaxStartups, MaxAuthTries, AuthorizedKeysFile,
    ClientAliveCountMax, ClientAliveInterval

在服务器上设置可信的客户端公钥：
    $ mkdir ~/.ssh
    $ cd ~/.ssh
    $ touch authorized_keys
    $ chmod 600 authorized_keys
接着将客户端的（上传的）公钥添加到这个文件中来：
    $ cat id_rsa.pub >> authorized_keys
    $ rm id_rsa.pub

sshd重启（启用新配置）：
    $ sudo service ssh restart

Find the fingerprints for all public keys in your ".ssh" directory:
    $ for i in /etc/ssh/ssh_host*.pub; do ssh-keygen -l -f "$i"; done

Client
======

http://help.github.com/linux-set-up-git/

生成SSH密钥对：
    $ ssh-keygen -t rsa -C "clc3123@gmail.com" -f ~/.ssh/id_rsa
其中，-t指定加密方法，-C增加注释，-f设定密钥对的文件位置。
设置密码时可以直接回车，这样就可以不使用密码，但是在安全性要求较高的环境下还是建议使用密码。

通过私钥重新生成公钥并输出到stdout：

    $ ssh-keygen -y ~/.ssh/id_rsa

查看生成的密钥对的fingerprint：

    $ ssh-keygen -lf ~/.ssh/id_rsa.pub

列出ssh-agent所代理的私钥：

    $ ssh-add -l

为ssh-agent手动添加私钥：

    $ ssh-add ~/.ssh/user_rsa

其它ssh-add命令：

    $ ssh-add -d ~/.ssh/user_rsa
    $ ssh-add -D

设置通过密钥对认证连接服务器：
    $ scp ~/.ssh/id_rsa.pub clc3123@server:~/.ssh/
接下来见以上在服务器端的操作。

将本机公钥添加到远程服务器的可信列表:
    $ ssh-copy-id -i identity_file user@remotemachine

Find the fingerprints for all public keys in your ".ssh" directory:
    $ for i in ~/.ssh/*.pub; do ssh-keygen -l -f "$i"; done

known_hosts文件保存用户登录过的server的公钥。
登录新的ssh server时，最好比对一下预先得到的server公钥指纹。

对当前系统用户的ssh进行配置：
    $ cd ~/.ssh/
    $ touch config
    $ chmod 600 config
    $ vi config

ssh config file
===============

~/.ssh/config配置案例：
    Host clc3123.github.com
        User git
        Hostname github.com
        IdentityFile ~/.ssh/id_rsa
    
    Host chefchen.github.com
        User git
        Hostname github.com
        IdentityFile ~/.ssh/chefchen_rsa
