---
layout: post
title: udev
description: udev
---

<http://serverfault.com/questions/521687/why-dev-disk-by-id-change-after-a-suddenly-server-power-off>

上面这篇so帖子问到问什么在一次服务器断电后磁盘的by-id变了，导致 `/etc/fstab` 中引用的 `/dev/disk/by-id/DISK_ID-partN` 失效。

在回复中提到，磁盘的by-uuid是存储在磁盘文件系统中的，因此掉电也不会改变，而by-id是根据udev的规则来生成的。

These days almost everything under /dev is created by udev. How udev operates is controlled by rules, which are not entirely consistent across various distributions.

另外ubuntu较新的版本中，udev规则存储位置也发生了变化。

I know in later releases that most of the Ubuntu udev rules were migrated to /lib/udev/rules.d. The rules under /etc/udev/rules.d/ are left for locally configured stuff.
