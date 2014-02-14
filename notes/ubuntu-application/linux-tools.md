---
layout: post
title: linux-tools
description: linux-tools
---

dmraid - discover, configure and activate software (ATA)RAID

$ dmraid -ay # activates all software RAID sets discovered.

正确设置系统raid

http://ubuntuforums.org/showthread.php?p=9274738

http://www.intel.com/support/chipsets/imsm/sb/cs-020663.htm
http://download.intel.com/design/intarch/PAPERS/326024.pdf

介绍intel rst在linux中的使用

http://askubuntu.com/questions/87979/configure-mdadm-for-existing-intel-rapid-storage-array

ok, after determining again the situation, i've understood that my Intel Rapid Storage mirror RAID has been configured as dmraid because the first time i've configured it was for windows 7 (intel rapid storage software for windows support only dmraid variation).

i've managed to see the details by running "sudo dmraid -s".

my RAID device is listed as /dev/dm-0 (and linked from /dev/mapper/isw_[raid set]_[array's name from BIOS]

in case of failure, i saw that in order to rebuild the RAID one need to run "sudo dmraid -R [raid set]

"sudo dmraid -r" will show which devices listed as part of raid sets.

Intel Rapid Storage in Linux PDF

http://linux.die.net/man/8/dmraid
