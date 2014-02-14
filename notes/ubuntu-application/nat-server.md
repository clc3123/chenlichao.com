---
layout: post
title: nat-server
description: nat-server
---

准备工作
========

用vagrant在virtualbox开两台ubuntu的vm
-------------------------------------

    $ mkdir nat-test
    $ cd nat-test
    $ cat <<FILE > Vagrantfile
    VAGRANTFILE_API_VERSION = "2"

    Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
      config.vm.box = "precise64raring-20140124"

      config.vm.synced_folder ".", "/vagrant", nfs: (RUBY_PLATFORM =~ /linux|darwin/)

      config.vm.define "master" do |server|
        master.vm.hostname = "nat-server"
        master.vm.network :private_network, ip: "192.168.33.10"
      end

      config.vm.define "slave" do |client|
        slave.vm.hostname = "nat-client"
        slave.vm.network :private_network, ip: "192.168.33.20"
      end
    end
    FILE
    $ vagrant up

第一个窗口执行：

    $ vagrant ssh server

第二个窗口执行：

    $ vagratn ssh client

设置vm
------

两台vm都设置下dns：

    $ sudo cat <<DNS > /etc/resolvconf/resolv.conf.d/tail
    nameserver 199.91.73.222
    nameserver 8.8.8.8
    DNS
    $ sudo resolvconf -u

nat server `/etc/network/interfaces`配置:

    auto lo
    iface lo inet loopback
    auto eth0
    iface eth0 inet static
          address 192.168.33.10
          netmask 255.255.255.0
    auto eth1
    iface eth1 inet dhcp

nat client `/etc/network/interfaces`配置:

    auto lo
    iface lo inet loopback
    auto eth0
    iface eth0 inet static
          address 192.168.33.20
          netmask 255.255.255.0

然后退出ssh并关掉vm：

    $ vagrant halt

调整vm的网卡配置
----------------

打开virtualbox gui：

1.  server和client的第一块网卡都配置为host-only，接入刚才vagrant自动创建的`vboxnetX`。
2.  server的第二块网卡配置为nat，可连入internet。client取消第二块网卡。

再次开机查看配置结果
--------------------

这次通过virtual box界面启动vm。

nat server:

    $ ip addr show
    1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN 
        link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
        inet 127.0.0.1/8 scope host lo
        inet6 ::1/128 scope host 
          valid_lft forever preferred_lft forever
    2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP qlen 1000
        link/ether 08:00:27:af:df:89 brd ff:ff:ff:ff:ff:ff
        inet 192.168.33.10/24 brd 192.168.33.255 scope global eth0
        inet6 fe80::a00:27ff:feaf:df89/64 scope link 
          valid_lft forever preferred_lft forever
    3: eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP qlen 1000
        link/ether 08:00:27:29:ed:ad brd ff:ff:ff:ff:ff:ff
        inet 10.0.3.15/24 brd 10.0.3.255 scope global eth1
        inet6 fe80::a00:27ff:fe29:edad/64 scope link 
          valid_lft forever preferred_lft forever

    $ ip route show
    default via 10.0.3.2 dev eth1  metric 100 
    10.0.3.0/24 dev eth1  proto kernel  scope link  src 10.0.3.15 
    192.168.33.0/24 dev eth0  proto kernel  scope link  src 192.168.33.10

nat client:

    $ ip addr show
    1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN 
        link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
        inet 127.0.0.1/8 scope host lo
        inet6 ::1/128 scope host 
          valid_lft forever preferred_lft forever
    2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP qlen 1000
        link/ether 08:00:27:af:df:89 brd ff:ff:ff:ff:ff:ff
        inet 192.168.33.20/24 brd 192.168.33.255 scope global eth0
        inet6 fe80::a00:27ff:feaf:df89/64 scope link tentative dadfailed 
          valid_lft forever preferred_lft forever

    $ ip route show
    192.168.33.0/24 dev eth0  proto kernel  scope link  src 192.168.33.20

此时nat client是ping不通外网的。

正式开工
========

这里主要参考了这篇文章

<https://help.ubuntu.com/community/Internet/ConnectionSharing>
<https://help.ubuntu.com/community/IptablesHowTo>

以下所有命令以root运行。

server设置
----------

开启`ipv4_forward`：

    $ sed -i '/^#net.ipv4.ip_forward=1$/a\net.ipv4.ip_forward=1' /etc/sysctl.conf
    $ sysctl -p

或直接自行这个：

    $ sysctl net.ipv4.ip_forward=1

设置iptables，注意之前先保存一个备份：
    
    $ iptables-save | tee /etc/iptables.old.rules
    $ iptables -A FORWARD -i eth0 -o eth1 -s 192.168.33.0/24 -m conntrack --ctstate NEW -j ACCEPT
    $ iptables -A FORWARD -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
    $ iptables -t nat -A POSTROUTING -o eth1 -j MASQUERADE

<http://www.yourownlinux.com/2013/07/how-to-configure-ubuntu-as-router.html>

再来一种配置，差不多，供参考：

    $ iptables -A FORWARD -i eth0 -o eth1 -j ACCEPT
    $ iptables -A FORWARD -i eth1 -o eth0 -m state -–state RELATED,ESTABLISHED -j ACCEPT
    $ iptables -t nat -A POSTROUTING -o eth1 -j MASQUERADE

<http://webcache.googleusercontent.com/search?q=cache:http://wernerstrydom.com/2013/02/23/configure-ubuntu-server-12-04-to-do-nat/&strip=1>

上面的文章提到也可以这样设置iptables，不过第一条rule貌似对所有forward的packet放行，显得过于宽松了：

    $ iptables -P FORWARD ACCEPT
    $ iptables -t nat -A POSTROUTING -o eth1 -j MASQUERADE

client设置
----------

添加路由设置：

    $ ip route add default via 192.168.33.10 dev eth0

看看这时的路由表：

    $ ip route show
    default via 192.168.33.10 dev eth0 
    192.168.33.0/24 dev eth0  proto kernel  scope link  src 192.168.33.20

一切ok，这时就可以在nat client访问internet了。
