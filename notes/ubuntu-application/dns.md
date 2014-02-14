---
layout: post
title: dns
description: dns
---

設定 /etc/resolv.conf 檔案
==========================

<http://dns-learning.twnic.net.tw/bind/intro4.html>

此檔案可用來設定DNS用戶端要求名稱解析時，所定義的各項內容。我們分別來看一個完整的resolv.conf的檔案:

    domain twnic.com.tw
    nameserver 192.168.10.1
    nameserver 192.168.2.5
    search twnic.com.tw twnic.net.tw

nameserver指定用戶端要求進行名稱解析的nameserver IP位址，在此可指定多部DNS伺服器，則用戶端將會依序提出查詢要求。

domain指定本地的網域名稱，如果查詢時的名稱沒有包含小數點，則會自動補上此處的網域名稱為字尾再送給DNS伺服器。

search這個選項為非必要選項，而功能在於若使用者指定主機名稱hostname查詢時，所需要搜尋的網域名稱。在示例中，當DNS伺服器在做名稱解析過程中，無法對輸入的名稱，例如pc1，找出相對應的IP時，則DNS會利用search的設定值加上需查詢的名稱，即`pc1.twnic.com.tw`來進行解析，解析失敗時則會嘗試`pc1.twnic.net.tw`。

需要注意的是當我們想嘗試多種在沒有包含小數點，於字尾補上所需要搜尋的網域名稱時，我們會在"search"中指定幾種組合給DNS伺服器，而不能在"domain"中指定。因為“domain”是指定本地的網域名稱，而搜尋時也以"domain"為優先嘗試，如果失敗之後才會嘗試"search"中的組合。

在ubuntu 12.04系统中持久保存dns设置
===================================

下面这个so的帖子提到了多种方法：

<http://askubuntu.com/questions/130452/how-do-i-add-a-dns-server-via-resolv-conf>

方法1
-----

首先我们需要创建一个文件`/etc/resolvconf/resolv.conf.d/tail`

然后在这个文件里写入自己要添加的DNS服务器，格式与`/etc/resolv.conf`文件一致：

    nameserver 8.8.8.8
    nameserver 8.8.4.4

重启下resolvconf程序，让配置生效：

    $ sudo /etc/init.d/resolvconf restart

或者直接更新`/etc/resolv.conf`：

    $ sudo resolvconf -u

这样刚才的配置会自动写入到`/etc/resolv.conf`

方法2
-----

修改`/etc/network/interfaces`：

    auto eth0
    iface eth0 inet static
        ...
        dns-nameservers 8.8.8.8 8.8.4.4

这个方法在`man interfaces`中没有提到，但是在`man resolvconf`和`man resolv.conf`有介绍。

<http://ubuntuforums.org/showthread.php?t=2134277&p=12598160#post12598160>

The `dns-*` settings in `/etc/network/interfaces` only apply if you have the resolvconf package installed.

When resolvconf is installed, other supported Ubuntu software talks to resolvconf instead of overwriting `/etc/resolv.conf` directly.

<https://help.ubuntu.com/12.04/serverguide/network-configuration.html#name-resolution>

方法3
-----

如果一定要直接修改`/etc/resolv.conf`的话，可以删除`/etc/resolv.conf`到`/run/resolvconf/resolv.conf`的symlink。

这样resolvonf只会修改`/run/resolvconf/resolv.conf`，而不会自动覆盖更新`/etc/resolv.conf`。

resolvconf
==========

<http://akyl.net/changes-dns-resolvconf-ubuntu-1204-precise-pangolin>

resolvconf is a set of script and hooks managing DNS resolution. resolvconf uses DHCP client hooks, a Network Manager plugin and /etc/network/interfaces to generate a list of nameservers and domain to put in /etc/resolv.conf.

dnsmasq
=======

<http://akyl.net/changes-dns-resolvconf-ubuntu-1204-precise-pangolin>
<https://www.stgraber.org/2012/02/24/dns-in-ubuntu-12-04/>

On a ubuntu 12.04 desktop install, your DNS server is going to be "127.0.0.1" which points to a NetworkManager-managed dnsmasq server.

This was done to better support split DNS for VPN users and to better handle DNS failures and fallbacks. This dnsmasq server *isn’t a caching server for security reason* to avoid risks related to local cache poisoning and users eavesdropping on other’s DNS queries on a multi-user system.

The big advantage is that if you connect to a VPN, instead of having all your DNS traffic be routed through the VPN like in the past, you’ll instead only send DNS queries related to the subnet and domains announced by that VPN. This is especially interesting for high latency VPN links where everything would be slowed down in the past.

As for dealing with DNS failures, dnsmasq often sends the DNS queries to more than one DNS servers (if you received multiple when establishing your connection) and will detect bogus/dead ones and simply ignore them until they start returning sensible information again. This is *to compare against the libc’s way of doing DNS resolving where the state of the DNS servers can’t be saved* (as it’s just a library) and so every single application has to go through the same, trying the first DNS, waiting for it to timeout, using the next one.

阿里云默认dns
=============

    nameserver 110.75.186.247
    nameserver 110.75.186.248
