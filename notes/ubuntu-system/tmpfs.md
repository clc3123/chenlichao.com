---
layout: post
title: tmpfs
description: tmpfs
---

Origin of /run directory
------------------------

<http://article.gmane.org/gmane.linux.redhat.fedora.devel/146976>

<http://unix.stackexchange.com/questions/13972/what-is-this-new-run-filesystem>

The /run directory is the companion directory to /var/run. Like for example /bin is the companion of /usr/bin.

That means that daemons like systemd and udev, which are started very early in the boot process - and perhaps before /var/run is available (i.e. mounted) - have with /run a standardized file system location available where they can store runtime information.

Like /bin contains important programs, which may be needed in the boot process before /usr is available (in case it is on its own filesystem).

The /run idea is a relatively new idea/standard, one supporter is the developer of systemd.

What are "/run", "/run/lock" and "/run/shm" used for?
-----------------------------------------------------

<http://www.cyberciti.biz/tips/what-is-devshm-and-its-practical-usage.html>

<http://askubuntu.com/questions/169495/what-are-run-lock-and-run-shm-used-for>

Short answer: they store temporary system files, including device locks and memory segments shared between different processes. Don't worry, they usually use a fraction of their "size" shown by df.

1.  /run is, in general, a temporary filesystem (tmpfs) residing in RAM (aka "ramdisk"); its meant for storing "temporary" system or state files which may be critical but *do not require persistence* across reboots.

    /run is actually a fairly new innovation, and was added a couple of years ago to replace the multiple tmpfs's that used to be created (including /var/lock and /dev/shm) with *a single unified root tmpfs* .

    The main locations /run replaces are:
    1.  /var/run → /run
    2.  /var/lock → /run/lock
    3.  /dev/shm → /run/shm [currently only Debian plans to do this]
    4.  /tmp → /run/tmp [optional; currently only Debian plans to offer this] 

2.  /run/lock (formerly /var/lock) contains lock files <http://www.pathname.com/fhs/pub/fhs-2.3.html#VARLOCKLOCKFILES> , i.e. files indicating that a shared device or other system resource is in use and containing the identity of the process (PID) using it; this allows other processes to properly coordinate access to the shared device.

3.  /run/shm (formerly /dev/shm) is *temporary world-writable shared-memory* . Strictly speaking, it is intended as storage for programs using the POSIX Shared Memory API. It facilitates what is known as inter-process communication (IPC), where different processes can share and communicate via a common memory area, which in this case is usually a normal file that is stored on a "ramdisk". Of course, it can be and has been used in other *creative ways* as well ;)

Do not be alarmed about the size: importantly, many people running `df -h` and knowing that /run is backed by RAM are shocked that their precious memory is being "wasted" by these mysterious folders. Just like the Linux ate my RAM myth though, this belief is incorrect.

The size shown is only the maximum that may be used. It defaults to 50% of physical RAM. Only as much shown in the Used column is actually in use, which in the above screenshot is less than 1 megabyte total. You can use the `ipcs -m` command to verify that the actual shared memory segments used match up to the df summary, and also see which PIDs are using them.

Like your regular RAM, /run is also *eventually backstopped by your swap* , so if you are using /run/shm for "faster" compile times, keep that in mind ;)
