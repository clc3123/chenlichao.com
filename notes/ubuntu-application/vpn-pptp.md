---
layout: post
title: vpn-pptp
description: vpn-pptp
---

可参考这些文章：
+ http://blog.istef.info/2008/10/17/ubuntu-pptp-server/
+ https://wangyan.org/blog/debian-pptp-vpn.html

以下配置对ubuntu 10.04及12.04有效，都以root执行。

    $ apt-get update
    $ apt-get install pptpd

编辑`/etc/pptpd.conf`，添加以下两行到文件的最后：

    localip 192.168.0.1-10
    remoteip 192.168.0.11-20

为了让用户连上VPN后能够正常地解析域名，我们需要手动设置DNS。编辑`/etc/ppp/pptpd-options`，找到ms-dns这一项：

    ms-dns 199.91.73.222 # V2EX DNS
    ms-dns 8.8.8.8 # Google Public DNS
    ms-dns 8.8.4.4 # Google Public DNS

当然配置成运营商的dns也是可以的，比如linode给指定的dns。

编辑`/etc/ppp/chap-secrets`，按照下面的格式添加vpn用户。每个用户一行，每行4列，分别为用户名、服务器名（跟`/etc/ppp/pptpd-options`中的设置保持一致）、密码、分配给客户端的IP（不做限制写`*`即可）。

    yourname pptpd yourpassword *

编辑`/etc/sysctl.conf`，找到`net.ipv4.ip_forward=1`这一行，去掉前面的注释。

    $ sysctl -p # 让配置生效
    $ service pptpd restart # 重启pptpd服务

备份当前的iptables规则：

    $ iptables-save > /etc/iptables.down.rules

开启iptables的NAT转发(为啥不用添加forward放行的规则？难道是默认开放？)：

    $ /sbin/iptables -t nat -A POSTROUTING -s 192.168.0.0/24 -o eth0 -j MASQUERADE

保存NAT设置后的iptables规则：

    $ iptables-save > /etc/iptables.up.rules

如果不想在下次服务器重启时手工设置iptables的规则，可编辑`/etc/network/interfaces`，在eth0那一段后面添加:

    auto eth0
    iface eth0 inet dhcp
    pre-up iptables-restore < /etc/iptables.up.rules # 网卡连接上时自动调用的设置
    post-down iptables-restore < /etc/iptables.down.rules # 网卡断开时使用的设置

现在就可以在客户端系统中连接VPN了。务必在高级设置中使用点对点的128bit加密。

因为`/etc/ppp/pptpd-options`对加密方法有要求。
