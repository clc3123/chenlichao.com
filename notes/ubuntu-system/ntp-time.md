---
layout: post
title: ntp-time
description: ntp-time
---

View Time
=========

    $ date

Set Time
========

    $ date newdatetimestring

Change Time Zone
================

<https://help.ubuntu.com/community/UbuntuTime>

terminal
--------

    $ dpkg-reconfigure tzdata

unattended
----------

    $ echo "Asia/Shanghai" | tee /etc/timezone
    $ dpkg-reconfigure --frontend noninteractive tzdata

Time Sync
=========

Network Time Protocol (NTP) is a UDP/IP protocol for synchronizing time over a network connection. Basically a client requests the current time from a server, and then uses the servers response to set its own clock.

Beyond this simple description, there is a lot of complexity. There are multiple tiers of NTP servers, with the tier one NTP servers connected to atomic clocks (often via GPS), and tier two and three servers spreading the load of actually handling requests across the internet. The client software is a lot more complex than you might think as it has to factor communication delays, and adjust the time in a way that does not affect the other processes that run on the system. Luckily all that complexity is hidden from the user.

NTP attempts to fix your local clock to keep accurate time. If your local clock drifts too fast (usually HW problems or IRQ lockups or somesuch) then NTP either keeps resetting your clock or gives up and terminates. Fix the drift problem and NTP will behave.

query ntp server
----------------

<https://www.digitalocean.com/community/articles/how-to-set-up-time-synchronization-on-ubuntu-12-04>

Ideally you want a * and a few +'s in the fist column and a reach of 377:

    $ ntpq -p

ubuntu默认使用了NTP Pool Project提供的ntp服务器，详见 `/etc/ntp.conf`

Don't be surprised if the resolved names don't match names in the ntp.conf file.

delay is in milliseconds. It should be < 1 for local network servers, < 10 for ISP servers over DSL and ideally < 100 for wireless. offset is in milliseconds and is the current best guess of the time difference between your system and the server. The smaller the better! jitter is an estimate the the local clock frequency error. The smaller the better. If it's consistently high then your system may be drifting.

<http://www.ntp.org/ntpfaq/NTP-s-trouble.htm#Q-MON-REACH>

What does 257 mean as value for reach?

The value displayed in column reach is octal, and it represents the reachability register. One digit in the range of 0 to 7 represents three bits. The initial value of that register is 0, and after every poll that register is shifted left by one position. If the corresponding time source sent a valid response, the rightmost bit is set.

During a normal startup the registers values are these: 0, 1, 3, 7, 17, 37, 77, 177, 377

Thus 257 in the dual system is 10101111, saying that two valid responses were not received during the last eight polls. However, the last four polls worked fine.

sync manually - command line ntpdate
-------------------------------

Ubuntu comes with ntpdate as standard, and will run it once at boot time to set up your time according to Ubuntu's NTP server. 

    $ ntpdate ntp.ubuntu.com

However, a system's clock is likely to drift considerably between reboots if the time between reboots is long. In that case it makes sense to correct the time occasionally. The easiest way to do this is to get cron to run it every day.

With your favorite editor, create (needs sudo) a file `/etc/cron.daily/ntpdate` containing:

    #!/bin/sh
    ntpdate ntp.ubuntu.com

ntpd - network time protocol
----------------------------

    $ sudo apt-get install ntp
    $ sudo service ntp status

ntp via dhcp
------------

<https://help.ubuntu.com/community/UbuntuTime#Troubleshooting>

By default NTP uses `/etc/ntp.conf` as configuration file. If `/etc/ntp.conf.dhcp` exists then the NTP daemon assumes you're using DHCP to redefine the NTP settings and it uses that file instead. Your DHCP server must be configured to supply NTP servers.
