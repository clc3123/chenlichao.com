---
layout: post
title: disk-performance
description: disk-performance
---

hdparm： get/set SATA/IDE device parameters
===========================================

    $ sudo hdparm -tT /dev/sda

-t 是从硬盘直接读数据,这个过程中确保读的内容是没有缓存过的

-T 是从磁盘缓存中读取数据,更多考验的是CPU和内存等的吞吐量

另外使用flag -i和-I可以查询硬盘参数和信息

查看磁盘IO
==========

查看CPU wa（IO-WAIT）数值，越低越好
    $ top

smartctl
========
安装：
    $ sudo apt-get install smartmontools

-   磁盘整体健康评测
    $ sudo smartctl -H /dev/sda
-   SMART信息
    $ sudo smartctl -A /dev/sda
-   全面自检并查看结果
    $ sudo smartctl -t long /dev/sda #开始自检
    $ sudo smartctl -l selftest /dev/sda #查看结果

dd
==

copy a file, converting and formatting according to the operands

先做纯写入测试：
1.  每个数据块都要fdatasync后才进行下一个数据块写入，非常慢。类似数据库写入。
        $ dd if=/dev/zero of=./test.bin bs=64K count=20000 oflag=dsync
2.  完全绕过OS缓存写入磁盘，比1稍快，但比3慢多了。
        $ dd if=/dev/zero of=./test.bin bs=64K count=20000 oflag=direct
3.  常见的情景。全部数据块通过OS缓存，直至全部写入磁盘后才返回。
        $ dd if=/dev/zero of=./test.bin bs=64K count=20000 conv=fdatasync

纯读取测试：
-   以下测试两次，第一次可能没有缓存，但第二次肯定有缓存了
        $ dd if=./test.bin of=/dev/null bs=64K count=20000
-   完全忽略读取缓存，直接从磁盘读入
        $ dd if=./test.bin of=/dev/null bs=64K count=20000 iflag=direct

读写测试：
    $ dd if=./test.bin of=./test1.bin bs=64K count=20000 conv=fdatasync

-   Q: What is the difference between the following?
        $ dd bs=1M count=128 if=/dev/zero of=test
        $ dd bs=1M count=128 if=/dev/zero of=test; sync
        $ dd bs=1M count=128 if=/dev/zero of=test conv=fdatasync
        $ dd bs=1M count=128 if=/dev/zero of=test oflag=dsync

-   A: The difference is in handling of the write cache in RAM:
        $ dd bs=1M count=128 if=/dev/zero of=test
    The default behaviour of dd is to not “sync” (i.e. not ask the OS to
    completely write the data to disk before dd exiting). The above command 
    will just commit your 128 MB of data into a RAM buffer (write cache). 
    This will be really fast and it will show you the hugely inflated 
    benchmark result right away. However, the server in the background is
    still busy, continuing to write out data from the RAM cache to disk.

        $ dd bs=1M count=128 if=/dev/zero of=test; sync
    Absolutely identical to the previous case, as anyone who understands 
    how *nix shell works should surely know that adding a ; sync does not 
    affect the operation of previous command in any way, because it is
    executed independently, after the first command completes. So 
    your (wrong) MB/sec value is already printed on screen while 
    that sync is only preparing to be executed.

        $ dd bs=1M count=128 if=/dev/zero of=test conv=fdatasync
    This tells dd to require a complete “sync” once, right before
    it exits. So it commits the whole 128 MB of data, then tells 
    the operating system: “OK, now ensure this is completely on disk”, 
    only then measures the total time it took to do all that and 
    calculates the benchmark result.

        $ dd bs=1M count=128 if=/dev/zero of=test oflag=dsync
    Here dd will ask for completely synchronous output to disk,
    i.e. ensure that its write requests don’t even return until 
    the submitted data is on disk. In the above example, this will mean 
    sync'ing once per megabyte, or 128 times in total. It would probably
    be the slowest mode, as the write cache is basically unused
    at all in this case.

-   Which one do you suggest?
        $ dd bs=1M count=128 if=/dev/zero of=test conv=fdatasync
    This behaviour is perhaps the closest to the way real-world tasks behave.
    If your server or VPS is really fast and the above test completes 
    in a second or less, try increasing the count= number to 1024 or so, 
    to get a more accurate averaged result.

在大多数的unix/linux对磁盘io的写操作都是通过缓存来完成的，基本的原理如下：当将数据写入文件时，内核通常先将该数据复制到其中一个缓冲区中，如果该缓冲区尚未写满，则并不将其排入输出队列，而是等待其写满或者当内核需要重用该缓冲区以便存放其他磁盘块数据时，再将该缓冲排入输出队列，然后待其到达队首时，才进行实际的I/O操作。我们称之为延迟写，极大的减少了写磁盘的次数。

但是在没写特殊的应用中我们需要实时的将应用层数据写入到磁盘上，特别是一些高可靠性要求的系统中，数据需要及时的写入磁盘。即便是瞬时系统故障，数据也可以安全恢复，于是就有了sync、fsync和fdatasync函数。但在功能上，这三个函数又略有区别：

sync函数只是将所有修改过的块缓冲区排入写队列，然后就返回，它并不等待实际写磁盘操作结束。通常称为update的系统守护进程会周期性地（一般每隔30秒）调用sync函数。这就保证了定期冲洗内核的块缓冲区。

fsync函数只对由文件描述符filedes指定的单一文件起作用，并且等待写磁盘操作结束，然后返回。fsync可用于数据库这样的应用程序，这种应用程序需要确保将修改过的块立即写到磁盘上。

fdatasync函数类似于fsync，但它只影响文件的数据部分。而除数据外，fsync还会同步更新文件的属性。
