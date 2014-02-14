---
layout: post
title: lvm
description: lvm
---

通过fdisk的显示来看，LVM的虚拟磁盘虽然建立在/dev/sda的sda5分区上面，但是却当作一个独立的磁盘来看待。

    vagrant@debconf-test:/dev/disk/by-id$ sudo fdisk -l

    Disk /dev/sda: 12.9 GB, 12884901888 bytes
    255 heads, 63 sectors/track, 1566 cylinders, total 25165824 sectors
    Units = sectors of 1 * 512 = 512 bytes
    Sector size (logical/physical): 512 bytes / 512 bytes
    I/O size (minimum/optimal): 512 bytes / 512 bytes
    Disk identifier: 0x00010d54

      Device Boot      Start         End      Blocks   Id  System
    /dev/sda1   *        2048      499711      248832   83  Linux
    /dev/sda2          501758    25163775    12331009    5  Extended
    /dev/sda5          501760    25163775    12331008   8e  Linux LVM

    Disk /dev/mapper/precise64devbox--vg-root: 12.1 GB, 12087984128 bytes
    255 heads, 63 sectors/track, 1469 cylinders, total 23609344 sectors
    Units = sectors of 1 * 512 = 512 bytes
    Sector size (logical/physical): 512 bytes / 512 bytes
    I/O size (minimum/optimal): 512 bytes / 512 bytes
    Disk identifier: 0x00000000

    Disk /dev/mapper/precise64devbox--vg-root doesn't contain a valid partition table

    Disk /dev/mapper/precise64devbox--vg-swap_1: 536 MB, 536870912 bytes
    255 heads, 63 sectors/track, 65 cylinders, total 1048576 sectors
    Units = sectors of 1 * 512 = 512 bytes
    Sector size (logical/physical): 512 bytes / 512 bytes
    I/O size (minimum/optimal): 512 bytes / 512 bytes
    Disk identifier: 0x00000000

    Disk /dev/mapper/precise64devbox--vg-swap_1 doesn't contain a valid partition table
