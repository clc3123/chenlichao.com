---
layout: post
title: grub
description: grub
---

注意grub2和grub的区别

<https://help.ubuntu.com/community/Grub2>
<https://help.ubuntu.com/community/Grub2/Setup>

Grub2 and add boot options apic=off noapic nolapic

<http://ubuntuforums.org/showthread.php?t=1376547>

add it to the `GRUB_CMDLINE_LINUX_DEFAULT` line

    $ sudo vi /etc/default/grub

you can see I added `hpet=force`:

    GRUB_CMDLINE_LINUX_DEFAULT="quiet splash hpet=force"

save the file then run:

    $ sudo update-grub

You may want to move it to grub_cmdline_linux so it is also added to the recovery modes also.

-   GRUB_CMDLINE_LINUX

    If it exists, this line imports any entries to the end of the 'linux' command line (Grub Legacy's "kernel" line) for both normal and recovery modes. This is similar to the "altoptions" line in `menu.lst`.

-   GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"

    This line imports any entries to the end of the 'linux' line (Grub Legacy's "kernel" line). The entries are appended to the end of the normal mode only. This is similar to the "defoptions" line in `menu.lst`. For a black screen with boot processes displayed in text, remove "quiet splash". To see the grub splash image plus a condensed text output, use "splash". This line is where other instructions, such as "acpi=off" are placed.

<https://help.ubuntu.com/community/BootOptions>

<https://www.kernel.org/doc/Documentation/kernel-parameters.txt>

What do the different Boot Options mean? (i.e. acpi=off, noapic, nolapic, etc)

<http://askubuntu.com/questions/52096/what-do-the-different-boot-options-mean-i-e-acpi-off-noapic-nolapic-etc>
