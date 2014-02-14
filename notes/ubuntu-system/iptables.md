---
layout: post
title: iptables
description: iptables
---

<https://help.ubuntu.com/community/IptablesHowTo>

<http://blog.tangjianwei.com/2009/01/12/my-understanding-about-dnat-and-snat-in-iptables/>

SNAT，DNAT，MASQUERADE的区别
----------------------------

<http://sxj007.blog.51cto.com/521729/110924>

SNAT，DNAT，MASQUERADE都是NAT

MASQUERADE是SNAT的一个特例

SNAT是指在数据包从网卡发送出去的时候，把数据包中的源地址部分替换为指定的IP，这样，接收方就认为数据包的来源是被替换的那个IP的主机

MASQUERADE是用发送数据的网卡上的IP来替换源IP，因此，对于那些IP不固定的场合，比如拨号网络或者通过dhcp分配IP的情况下，就得用MASQUERADE

DNAT，就是指数据包从网卡发送出去的时候，修改数据包中的目的IP，表现为如果你想访问A，可是因为网关做了DNAT，把所有访问A的数据包的目的IP全部修改为B，那么，你实际上访问的是B

因为，路由是按照目的地址来选择的，因此，DNAT是在PREROUTING链上来进行的，而SNAT是在数据包发送出去的时候才进行，因此是在POSTROUTING链上进行的

Simple iptables example
-----------------------

<https://help.ubuntu.com/community/Internet/ConnectionSharing>

In a simple example, wlan0 has the Internet connection, and eth0 is being used to share the connection. It could be connected directly with a single computer via a crossover cable or switch, or you could have a router with a cable from eth0 to the WAN port and a whole LAN setup behind this. Interestingly, the Internet connection could be ppp0, a 3G, or mobile Internet modem.

    #!/bin/sh 
    # 
    # internet connection sharing wlan0 is the gate way 
    # eth0 is the lan port this might use a straight ethernet cable to a router wan port or a switch or a single PC
    # 192.168.2.2 is the port that is being used by the lan for access I changed it to 192.168.2.254 and set fixed addresses for the wan and router
    #
    # change wlan0 to ppp0 and you can use this for mobile broadband connection sharing
    #
    ip link set dev eth0 up
    ip addr add 192.168.2.1/24 dev eth0
    sysctl net.ipv4.ip_forward=1
    iptables -t nat -A POSTROUTING -o wlan0 -s 192.168.2.0/24 -j MASQUERADE
    iptables -t nat -A PREROUTING -i wlan0 -p tcp --dport 3074 -j DNAT --to-destination 192.168.2.2
    iptables -t nat -A PREROUTING -i wlan0 -p udp -m multiport --dports 88,3074 -j DNAT --to-destination 192.168.2.2
    iptables -A FORWARD -i wlan0 -d 192.168.2.2 -p tcp --dport 3074 -j ACCEPT
    iptables -A FORWARD -i wlan0 -d 192.168.2.2 -p udp -m multiport --dports 88,3074 -j ACCEPT

iptables救命脚本
----------------

If things go wrong, the following script should save you when things get badly messed up. 

    #!/bin/sh
    # 
    # rc.flush-iptables - Resets iptables to default values. 
    # 
    # Copyright (C) 2001 Oskar Andreasson <bluefluxATkoffeinDOTnet>
    #
    # This program is free software; you can redistribute it and/or modify
    # it under the terms of the GNU General Public License as published by
    # the Free Software Foundation; version 2 of the License.
    #
    # This program is distributed in the hope that it will be useful,
    # but WITHOUT ANY WARRANTY; without even the implied warranty of
    # MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
    # GNU General Public License for more details.
    #
    # You should have received a copy of the GNU General Public License
    # along with this program or from the site that you downloaded it
    # from; if not, write to the Free Software Foundation, Inc., 59 Temple
    # Place, Suite 330, Boston, MA 02111-1307 USA
    #
    # Configurations
    #
    IPTABLES="/usr/sbin/iptables"
    #
    # reset the default policies in the filter table.
    #
    $IPTABLES -P INPUT ACCEPT
    $IPTABLES -P FORWARD ACCEPT
    $IPTABLES -P OUTPUT ACCEPT
    #
    # reset the default policies in the nat table.
    #
    $IPTABLES -t nat -P PREROUTING ACCEPT
    $IPTABLES -t nat -P POSTROUTING ACCEPT
    $IPTABLES -t nat -P OUTPUT ACCEPT
    #
    # reset the default policies in the mangle table.
    #
    $IPTABLES -t mangle -P PREROUTING ACCEPT
    $IPTABLES -t mangle -P POSTROUTING ACCEPT
    $IPTABLES -t mangle -P INPUT ACCEPT
    $IPTABLES -t mangle -P OUTPUT ACCEPT
    $IPTABLES -t mangle -P FORWARD ACCEPT
    #
    # flush all the rules in the filter and nat tables.
    #
    $IPTABLES -F
    $IPTABLES -t nat -F
    $IPTABLES -t mangle -F
    #
    # erase all chains that's not default in filter and nat table.
    #
    $IPTABLES -X
    $IPTABLES -t nat -X
    $IPTABLES -t mangle -X
