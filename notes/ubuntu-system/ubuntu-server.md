---
layout: post
title: ubuntu-server
description: ubuntu-server
---

echo "${PATH//:/$'\n'}" 按行显示PATH
Words of the form $'string' are treated specially. The word expands to string, with backslash-escaped characters replaced as specified by the ANSI C standard.

网络相关
========

inetd
-----

Often called a super-server, inetd listens on designated ports used by Internet services such as FTP, POP3, and telnet. When a TCP packet or UDP packet arrives with a particular destination port number, inetd launches the appropriate server program to handle the connection. For services that are not expected to run with high loads, this method uses memory more efficiently, since the specific servers run only when needed. Furthermore, no network code is required in the application-specific daemons, as inetd hooks the sockets directly to stdin, stdout and stderr of the spawned process. For protocols that have frequent traffic, such as HTTP and POP3, a dedicated server that intercepts the traffic directly may be preferable.

In recent years, because of the security limitations in the original design of inetd, it has been replaced by xinetd, rlinetd, ucspi-tcp, and others in many systems. Distributions of Linux especially have many options and Mac OS X (beginning with Mac OS X v10.2) uses xinetd. As of version Mac OS X v10.4, Apple has merged the functionality of inetd into launchd. *Systemd* supports inetd services, and expands socket activation beyond IP messaging (AF_INET+6) to include AF_UNIX, AF_NETLINK and more.

The services provided by inetd can be omitted entirely. This is becoming more common where machines are dedicated to a single function. For example, an HTTP server could be configured to just run httpd and have no other ports open. A dedicated firewall could have no services started.

接入无线网络
------------

1.  查看网络设备是否有wlan0

        $ ifconfig -a

2.  修改/etc/network/interfaces为

        auto lo
        iface lo inet loopback
        auto wlan0
        iface wlan0 inet dhcp # 针对使用DHCP的情况
        wpa-driver wext # 设置所用的driver
        wpa-ssid TP-LINK_BOBO
        wpa-psk yourpassword

3.  确认无线网络状态

        $ sudo ifdown eth0 #关闭有线
        $ sudo ifup wlan0 #启动无线
        $ iwconfig # 无线网络信息

Ethernet Interface Settings
---------------------------

`ethtool` is a program that displays and changes Ethernet card settings such as auto-negotiation, port speed, duplex mode, and Wake-on-LAN. It is not installed by default, but is available for installation in the repositories.

    $ sudo apt-get install ethtool

Changes made with the ethtool command are temporary and will be lost after a reboot. If you would like to retain settings, simply add the desired ethtool command to a pre-up statement in the interface configuration file /etc/network/interfaces.

The following is an example of how the interface identified as eth0 could be permanently configured with a port speed of 1000Mb/s running in full duplex mode.

    auto eth0
    iface eth0 inet static
    pre-up /sbin/ethtool -s eth0 speed 1000 duplex full

常用应用
========

vsftpd
------

安装:

    $ sudo apt-get install vsftpd

设置不随系统启动:

    $ sudo update-rc.d -f vsftpd remove
    $ sudo update-rc.d vsftpd stop 20 2 3 4 5 .

配置文件在 /etc/vsftpd.conf
参考: http://wiki.ubuntu.org.cn/Vsftpd

常用软件
========

ldd - prints the shared libraries required by each program or shared library specified on the command line.

$ sudo add-apt-repository (--remove) ppa:xxx/xxx

$ sudo apt-get install git-core tree openssh-server htop vim-nox byobu
$ sudo apt-get install curl libssl-dev gnutls-bin libcurl4-gnutls-dev

如果vim需要ruby支持(使用command-t),可以sudo apt-get install vim-nox

Byobu can be configured to run by default at every text login (SSH or TTY).
That behavior can be toggled with the byobu-enable and byobu-disable commands.

ubuntu pid最大数值是32768，该数值存在 /proc/sys/kernel/pid_max

常用命令
========

执行上一条命令（borrowed from csh）：

    $ !!

在未来执行任务：

    $ at # 设置任务
    $ atq # at任务列表
    $ atrm # 移除任务

In some Unix-like computer operating systems it uses a daemon, atd, which waits in the background periodically checking the list of jobs to do and executing those at their scheduled time on behalf of at.

系统的locale相关信息，对应修改的文件是 `/etc/default/locale` ：

    $ locale # 当前系统的locale
    $ locale -a # 所有支持的locale
    $ update-locale --help

参看文件mime-type：

    $ file --mime-type FILE_NAME
    $ file -i FILE_NAME

uname - print system information

    $ uname -a

lsb_release - print distribution-specific information

    $ lsb_release -a # 输出全部相关信息
    $ lsb_release -sc # 输出当前ubuntu的codename,如precise

移除某一版本的内核:

  $ sudo apt-get remove --purge linux-image-3.2.0-29-generic
 
在每个命令最后加上&，即可后台运行任务并立即返回命令行。


install your public key in a remote machine's authorized_keys

    $ ssh-copy-id git@linode

获取某个process的信息：

    $ ps aux | grep sshd

查看CPU Core的数量，以此确定load的合理数值：
    $ cat /proc/cpuinfo # 或者下面的
    $ grep 'model name' /proc/cpuinfo | wc -l

查看load：
    $ htop # 动态
    $ uptime # 快照

获取当前系统的runlevel：
    
    $ sudo runlevel
    $ who -r

关机/重启：
    $ sudo shutdown -h/-r now
    $ telinit 0 # 关机
    $ telinit 6 # 重启

退出程序：
    $ kill pidnumber # 只发送signal，不保证程序退出
    $ kill -9 pidnumber # 这回真玩完了
    $ killall pidname # 接受一个process名字作为参数

挂载(如需改变系统启动时的默认挂载设备，可修改/etc/fstab):
    $ mount /dev/sda1 /mnt/mydisk
    $ mount # 查看当前挂载的设备和挂载点
    $ cat /proc/mounts
    $ umount /dev/sda1 # 取消挂载

关于查看设备UUID：
    $ ls -la /dev/disk/by-uuid/ 或 $ sudo blkid

修改hostname：
    $ echo "clc3123" > /etc/hostname
    $ hostname -F /etc/hostname # 从文件读取并更新主机名

设置Linux的FQDN(Fully Qualified Domain Name)：
1.  首先在/etc/hostname文件中设置主机名，假设是clc3123
2.  然后在/etc/hosts文件中增加一行主机记录，
    第一个字段是该主机的IP地址，第二个字段是你希望设置的FQDN，最后是刚刚设置的主机名，如下
        A.B.C.D clc3123.example.com clc3123
3.  设置好之后, 通过hostname -F /etc/hostname更新主机名
这时，通过hostname -f看到的FQDN就应该是：clc3123.example.com
以上步骤可参考：http://library.linode.com/getting-started#sph_setting-the-hostname

查看Linux下默认的DNS
    $ vi /etc/resolv.conf
    nameserver  10.242.252.8
    nameserver  10.242.252.66

$ dpkg-reconfigure tzdata # 设置时区，根据GUI进行选择

在~/.bashrc中取消注释force_color_prompt=yes,命令行就有颜色了.

格式化: $ man mkfs

给阿里云挂载数据盘
------------------

<http://help.aliyun.com/origin?spm=0.0.0.0.GBt7Ru&&helpId=271>

    $ df -h
    $ sudo fdisk -l # 阿里云服务器用df看不到数据盘,只能看到系统盘
    $ sudo fdisk /dev/xvdb

对数据盘进行分区，根据提示，依次输入“n”，“p”，“1”，两次回车，“wq”，分区就开始了，很快就会完成。

    $ sudo fdisk -l
    $ sudo mkfs.ext4 /dev/xvdb1
    $ echo '/dev/xvdb1 /mnt ext4 defaults 0 0' >> /etc/fstab
    $ sudo mount -a

Bash
----

On login Bash runs the following scripts:
- /etc/profile
- The first found of ~/.bash_profile, ~/.bash_login, ~/.profile (Ubuntu by default uses .profile)

Ubuntu中要是启用了.bash_profile或.bash_login,就在其中加上source "$HOME/.profile",重新启用系统默认的.profile

On entering an interactive terminal, Bash also executes:
- /etc/bash.bashrc
- ~/.bashrc

On logout, Bash runs:
- ~/.bash_logout

以上详细请参考man bash

nohup - run a command immune to hangups, with output to a non-tty
-----------------------------------------------------------------

$ nohup COMMAND [ARG] &

nohup is often used in combination with the nice command to run processes on a lower priority.
$ nohup nice abcd &

Another possibility would be to use `setsid` which will run a program in a new session.
It is also possible to use `dislocate` to achieve this effect.

Under Debian, it is possible to use the following command to daemonise a process:
$ /sbin/start-stop-daemon

Another way to avoid the process being bound to a terminal is
to have the at daemon run it, as for example with:
$ echo command | at now.

nice - run a program with modified scheduling priority
------------------------------------------------------

查看系统inode信息
    $ sudo tune2fs -l /dev/sdaX | grep "inodes"


SSD优化
=======

http://www.howtogeek.com/62761/how-to-tweak-your-ssd-in-ubuntu-for-better-performance/

大概可总结4种方法:
1.  noatime, nodirtime
2.  trim(discard)
3.  io scheduler(deadline)
    $ cat /sys/block/sdX/queue/scheduler
    ubuntu 12.10's kernel changes the default scheduler from cfq to deadline
    https://wiki.ubuntu.com/QuantalQuetzal/ReleaseNotes/UbuntuDesktop
4.  mount tmpfs on /tmp

软件源设置
==========

添加163更新源，完全替换/etc/apt/sources.list为以下内容：
deb http://mirrors.163.com/ubuntu/ precise main restricted universe multiverse
deb http://mirrors.163.com/ubuntu/ precise-updates main restricted universe multiverse
deb http://mirrors.163.com/ubuntu/ precise-security main restricted universe multiverse
deb http://mirrors.163.com/ubuntu/ precise-backports main restricted universe multiverse
deb-src http://mirrors.163.com/ubuntu/ precise main restricted universe multiverse
deb-src http://mirrors.163.com/ubuntu/ precise-updates main restricted universe multiverse
deb-src http://mirrors.163.com/ubuntu/ precise-security main restricted universe multiverse
deb-src http://mirrors.163.com/ubuntu/ precise-backports main restricted universe multiverse

$ sudo apt-get update
$ sudo apt-get dist-upgrade

User & Group
============

User
----

### /etc/passwd => 系统用户列表

格式：
    Name:Password:UID:GID:GECOS:Home Directory:Login Shell
举例(Password一般以x显示，实际存储在 /etc/shadow)：
    clc3123:x:1000:1000:clc3123,,,:/home/clc3123:/bin/bash
    postgres:x:116:127:PostgreSQL administrator,,,:/var/lib/postgresql:/bin/bash

### /etc/shadow => 用户密码文件

see: `$ man shadow`

举例：

    vagrant:$6$RfvZI.jH$x7PEf3BZl89V520XWJkCVNc3NoPzzmmHHOTMFUHbU/KqwPN/NSM8DnHjVD2zvU1uDOOsS3UKtl2L59F4m69Pr.:16094:0:99999:7:::

各field的意义：
-   login name
-   encrypted password
-   date of last password change
-   minimum password age
-   maximum password age
-   password warning period
-   password inactivity period
-   account expiration date
-   reserved field

其中，加密字段：
-   `!`，说明帐号密码被锁定，但能够使用ssh等其它方式登录。Ubuntu中的root帐号就是这种
-   `*`，说明帐号尚未设定密码
-   `!!`，说明帐号已失效

encrypted password的格式为`$id$salt$hash`，其中id代表了hash算法：

    ID  | Method
    -------------------------------------------------------------------------
    1   | MD5
    2a  | Blowfish (not in mainline glibc; added in some Linux distributions)
    5   | SHA-256 (since glibc 2.7)
    6   | SHA-512 (since glibc 2.7)

<http://serverfault.com/questions/259722/how-to-generate-a-etc-shadow-compatible-password-for-ubuntu-10-04>

ubuntu安装过程中对用户密码加salt并执行了sha512，但是系统中自带的`openssl passwd`命令却没有相应的选项指定sha512来生成密码（详见`$ man 1ssl passwd`），而必须用`whois`包中的`mkpasswd`来生成：

    $ sudo apt-get install whois
    $ mkpasswd -S RfvZI.jH -m sha-512 vagrant
    $6$RfvZI.jH$x7PEf3BZl89V520XWJkCVNc3NoPzzmmHHOTMFUHbU/KqwPN/NSM8DnHjVD2zvU1uDOOsS3UKtl2L59F4m69Pr.

呃，原来还可以这么改密码，而且sha512是默认加密方式：

    $ echo vagrant:vagrant | chpasswd -c SHA512

### 关于用户的几个命令：

- useradd or adduser (在Debian中,adduser是useradd的友好前端)
- usermod
- userdel or deluser
- passwd clc3123
- su - clc3123

举例：
    $ sudo useradd -d /home/clc3123 -m -s /bin/bash -G admin clc3123
    $ sudo usermod -a -G rvm clc3123
    $ sudo passwd -l root # 禁用root的密码登录

使用adduser添加用户：
    $ sudo adduser clc3123 # 根据后续提示操作
为clc3123增加sudo权限(以下任选一种)：
-   $ sudo vi /etc/sudoers 并将 clc3123 ALL=(ALL) ALL 添加到最后一行
-   $ sudo adduser clc3123 admin

使用useradd：
    $ sudo useradd myapp -s /bin/bash -m -d /home/myapp # 不要在这里使用-p来设置密码，不安全
    $ sudo chown -R myapp /home/myapp
    $ sudo passwd myapp # 不设置密码的话，login就还是disabled

如果给MySQL或Nginx这类服务创建专门的帐号，则无需创建用户目录，也不要给予shell权限：
    $ sudo adduser \
        --system \
        --no-create-home \
        --disabled-login \    # 导致shadow中加密字段是个\!，和下面一起使用结果不变
        --disabled-password \ # 导致shadow中加密字段是个\*
        --group nginx
查看用户所属的组(可能有好几个)
    $ groups clc3123

### Ubuntu User 管理的特点

Ubuntu的root用户是无法使用的，也就是说，如果使用：
    $ su - root
是无法切换到root帐号来使用的。
通过查看 /etc/shadow 可以发现，root帐号那一行的密码栏是个\!，
这说明此帐号是不能使用密码的。
有些应用程序也在专门对应的帐号下运行，比如Nginx和MySQL。这些都是无密码的帐号。
所以要操作root专属的文件或目录，必须使用具有sudo权限的group中的帐号，搭配sudo来执行命令。
具体哪些group具有sudo权限，可以查看 /etc/sudoers 。

### 为用户设置sudo免输密码

%sudo ALL=(ALL) NOPASSWD:ALL

更改为对于命令进行限制，例如对于关机命令取消密码
clc3123 ALL=(ALL) NOPASSWD:/sbin/shutdown, /sbin/halt, /sbin/reboot

/etc/sudoers
============

一旦sudoers文件写错了，就无法再次执行sudo，可以按照下面的方法解决：
Boot into recovery mode from the GRUB menu, enter the root shell.
Need write permission to edit sudoers so, run:

    $ mount -o remount,rw /

Then `nano /etc/sudoers` and revert your mistake.

    Defaults env_reset
    Defaults secure_path="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

以上两行配置会使得执行sudo的时候重置或剔除某些环境变量，其中第二行针对PATH。
在某些版本的rvm中会导致rvmsudo不可用。

http://ruby.about.com/od/rubyversionmanager/qt/Rvm-And-Sudo.htm

`sudo` starts a new subshell that not contains environment variables.
`rvmsudo` passes on any environment variables that RVM set up to get you to the correct Ruby.
This includes the `$PATH` as well has `$GEM_HOME`, `$GEM_PATH` and `$BUNDLE_PATH` variables.
There are some minor security concerns using rvmsudo.
Since RVM adds you gem's bin path to the environment ahead of any system paths,
gems could install duplicate commands that may be harmful to your system.

Group
=====

/etc/group
----------

用户组列表
格式：
    Group Name:Password:GID:User List
举例(Password一般不用的)：
    sambashare:x:124:clc3123
    postgres:x:127:

用户组操作的几个命令
--------------------

- groupadd
- groupmod
- groupdel
- chgrp user filename

把某个user加入特定的group：
    $ usermod --append --groups groupname username

User: mozeal
------------

RVM官方安装教程：https://rvm.beginrescueend.com/rvm/basics/
    # 貌似只能用单用户模式，所以不能加sudo
    $ bash -s stable < <(curl -s https://raw.github.com/wayneeseguin/rvm/master/binscripts/rvm-installer )
    $ . ~/.bashrc # reload bash
    $ type rvm | head -1 # 确认rvm加载成功
    $ rvm notes # 查看安装ruby时的依赖，还没装的就装上

Ruby:
    $ rvm install 1.9.2
    $ rvm rubygems 1.8.10 # 可能rvm附带安装好了
    $ rvm --default use 1.9.2
    $ which ruby # 查看正在使用的ruby
    $ gem -v

$ sudo apt-get install nodejs # 编译coffeescript用，也可下载编译安装
$ sudo apt-get install nginx

UFW防火墙(iptables的前端，简单够用)：
    $ sudo apt-get install ufw
    $ sudo ufw enable # 开启防火墙,其默认配置文件在/etc/default/ufw
    $ man ufw # 根据文档进行配置

User: git
---------

Git部署：
+ 先在SSH Client端导出项目的裸仓库：
    $ cd ~/projects # projects为mozeal项目所在的文件夹
    $ git clone --bare mozeal mozeal.git # 把mozeal文件夹转为裸仓库
+ 在SSH Client端通过SSH将裸仓库部署到Server上：
    $ scp -r ~/projects/mozeal.git mozeal@server:~/projects
+ SSH登录Server，在~/.ssh/authorized_keys里添加SSH Client端的公钥，这样就能免密码登录Server了(当然如果公钥加了密码另谈)
+ $ mkdir ~/www
+ $ cd ~/www && git clone ~/projects/mozeal.git

Recover Grub
============

http://askubuntu.com/questions/40372/how-to-move-ubuntu-to-an-ssd

Boot from the livecd and mount both the HD and SSD
(after formatting a partition on the SSD of course),
then copy all of the files over:
    $ sudo cp -ax /media/hd /media/ssd

Use the correct names for the hd and ssd mount points of course.
Then you just need to edit /etc/fstab on the ssd to
point to the new fs UUID (you can look it up with blkid).
Finally you need to install grub on the ssd:
    $ sudo -s
    $ for f in sys dev proc ; do mount --bind /$f /media/ssd/$f ; done
    $ chroot /media/ssd
    $ grub-install /dev/ssd
    $ update-grub

Of course, use the correct device for /dev/ssd.
The whole disk, not a partition number.
Finally reboot and make sure your bios is set to boot from the SSD.

https://help.ubuntu.com/community/Partitioning/Home/Moving
https://help.ubuntu.com/community/MovingLinuxPartition

generate and update UUID
------------------------

$ tune2fs -U random /dev/sdZY
or
$ tune2fs -U random /dev/hdZY

where ZY is your new partition's block device name

Shell
=====

shell脚本里-r -f -s都代表了什么？
可以man bash，然后搜索CONDITIONAL EXPRESSIONS

