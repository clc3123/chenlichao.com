---
layout: post
title: init-upstart-and-others
description: init-upstart-and-others
---

Upstart
=======

查看系统upstart版本：

    $ initctl version

Useful resources from <http://askubuntu.com/questions/133807/how-to-config-start-services-with-upstart> :

+   `$ man 5 init`
+   `$ man 8 init`
+   `$ man 7 upstart-events`
+   <http://upstart.ubuntu.com/cookbook/>
+   <http://upstart.ubuntu.com/cookbook/upstart_cookbook.pdf>

<http://superuser.com/questions/213416/running-upstart-jobs-as-unprivileged-users>

Sudo is really designed to be used interactively (hence the you must have a tty to run sudo message) -- It's not the right tool to be used in non-interactive startup scripts.

Ubuntu Bootup
-------------

<https://help.ubuntu.com/community/UbuntuBootupHowto>

Directories and Configs

1.  `/etc/init` is where the upstart init configs live. While they are not scripts themselves, they essentially execute whatever is required to replace sysvinit scripts.

2.  `/etc/init.d` is where all the traditional sysvinit scripts and the backward compatible scripts for upstart live. The backward compatible scripts basically run service myservice start instead of doing anything themselves. Some just show a notice to use the `service` command.

3.  `/etc/init/rc-sysinit.conf` controls execution of traditional scripts added manually or with update-rc.d to traditional runlevels in `/etc/rc*`

4.  `/etc/default` has configuration files allowing you to control the behaviour of both traditional sysvinit scripts and new upstart configs.

Upstart: there is no concept of runlevels, everything is event driven with dependencies. You would add an upstart config to `/etc/init` and potentially source a config file in `/etc/default` to allow users to override default behaviour.

Other Upstart Commands
----------------------

Controlling Services - interchangeable with the "service" command

+   initctl - can use in place of "service" with the commands bellow. Run initctl help.
        
        $ initctl list # 列出全部运行和停止的服务

+   start - start a service
+   stop - stop a service
+   reload - sends a SIGHUP signal to running process
+   restart - restarts a service without reloading its job config file
+   status - requests status of service

Rebooting and Powering off the system

+   halt - shutdown the system then power off
+   poweroff - shutdown the system then power off
+   reboot - reboot the system
+   shutdown - bring the system down

Misc Upstart Commands - you generally don't use these directly

+   init - Upstart process management daemon 
+   runlevel - Backward compatibility with traditional runlevels
+   telinit - Backward compatibility with traditional runlevels
+   upstart-udev-bridge - Bridge between upstart and udev

Upstart Intro
-------------

<http://en.wikipedia.org/wiki/Upstart>

Upstart is an *event-based* replacement for the traditional init daemon.

The traditional init process was originally only responsible for bringing the computer into a normal running state after power-on, or gracefully shutting down services prior to shutdown.

Its tasks must also be defined in advance, as they are limited to this prep or cleanup function. This leaves it *unable to handle various non-startup-tasks on a modern desktop computer* elegantly.

Upstart operates asynchronously — as well as handling the starting of tasks and services during boot and stopping them during shutdown, it supervises them while the system is running.

Easy transition and perfect backwards compatibility with sysvinit were explicit design goals. As such, Upstart is able to run sysvinit scripts unmodified. In this way it differs from most other init replacements, which usually assume and require complete transition to run properly, and don't support a mixed environment of traditional and new startup methods.

As Upstart matures, it is intended that its role will expand to the duties currently handled by cron, anacron, the at command's daemon (atd), and possibly (but much less likely) inetd.

Ubuntu 6.10 (Edgy Eft) and later contain Upstart as a replacement for the traditional init-process, but they still use the traditional init scripts and *Upstart's SysV-rc compatibility tools* to start most services and emulate runlevels.

How do I reduce the number of gettys?
-------------------------------------

In /etc/init there is a file named ttyN.conf for each getty that will be started, where N is numbered 1 to 6. Remove any that you do not want.

This will not take immediate effect, however you can run `$ stop ttyN` to stop one that is running.

If your system has Upstart 0.6.7 or later(first included in Ubuntu 11.04), you will be able to disable the automatic start of these without removing them by running:

    $ echo manual >> /etc/init/ttyN.conf

How do I change the behaviour of Control-Alt-Delete?
----------------------------------------------------

<https://help.ubuntu.com/community/UpstartHowto>

Edit the /etc/init/control-alt-delete.conf file. The line beginning "exec" is what upstart will run when this key combination is pressed.

To not do anything when Control-Alt-Delete is pressed, you can *simply delete this file* .

Note that this only affects the behaviour of Control-Alt-Delete when at a text console. In a desktop environment, this key combination is handled by the desktop itself and must be reconfigured there.

Helpful Tips
------------

<https://help.ubuntu.com/community/UbuntuBootupHowto>

+   initctl list shows new services straight away, service command might not!
+   Check /var/log/syslog, it will show clues as to what went wrong.
+   All scripts default to running with errexit (set -e), so any non-zero exit status will cause errors. In pre-start, this means the service won't start.
+   if you want to *fire events* from your legacy sysvinit scripts, for example postgres, you can add the following:
    1.  `initctl emit starting-postgresql` in /etc/init.d/postgresql just before the service is started
    2.  `initctl emit started-postgresql` just after
    3.  As well as `initctl emit stopping-postgresql` and ‘initctl emit stopped-postgresql
    4.  Then you can use `start on started-postgresql` and `stop on stopping-postgresql` in your job.

Init System and others
======================

<http://en.wikipedia.org/wiki/Init>

In Unix-based computer operating systems, init is a daemon process that is the direct or indirect *ancestor of all other processes* . It automatically adopts all orphaned processes. Init is the first process started during booting, and is typically assigned process identifier number 1. Init continues running until the system is shut down.

The design of init has diverged in Unix systems such as System III and System V, from the functionality provided by the init in Research Unix and its BSD derivatives. The usage on most Linux distributions is somewhat compatible with System V, but some distributions, such as Slackware, use a BSD-style and others, such as Gentoo, have their own customized version.

Several replacement init implementations have been written with attempt to *address design limitations in the standard versions* . These include systemd and Upstart.

The root typically changes the current runlevel by running the telinit or init commands.

On Unix systems, changing the runlevel is achieved by starting only the missing services (as each level defines only those that are started / stopped).[citation needed] For example, changing a system from runlevel 3 to 4 might only start the local X server. Going back to runlevel 3, it would be stopped again.

* * * * * * * * * * * * * * * * * * * * 

<http://en.wikipedia.org/wiki/Runit>

Runit focuses on being a small, modular, and portable codebase. Runit is split into three stages: one time initialization, *process supervision* , and halting or rebooting. While the first and third stages must be adapted to the specific operating system they are running on, *the second stage is portable* across all POSIX compliant operating systems.

* * * * * * * * * * * * * * * * * * * * 

<http://en.wikipedia.org/wiki/Orphan_process>

In a Unix-like operating system any orphaned process will be immediately adopted by the special init system process. This operation is called re-parenting and occurs automatically. Even though technically the process has the "init" process as its parent, it is still called an orphan process since the process that originally created it no longer exists.

* * * * * * * * * * * * * * * * * * * * 

<http://en.wikipedia.org/wiki/Systemd>

Like init, systemd is a daemon that manages other daemons. All daemons, including systemd, are background processes. systemd is the first daemon to start (during booting) and the last daemon to terminate (during shutdown).

The name systemd adheres to the Unix convention of making daemons easier to distinguish by appending the letter d to the filename.

Systemd's initialization instructions for each daemon are recorded in a declarative configuration file rather than a shell script.

Because systemd tracks processes using Linux cgroups instead of process identifiers (PIDs), daemons cannot "escape" systemd; not even by double-forking. 

Among systemd's auxiliary features are a cron-like job scheduler called systemd Calendar Timers, and an event logging subsystem called journal. The system administrator may choose whether to log system events with systemd or syslog. systemd's logfile is a binary file. The state of systemd itself can be preserved in a snapshot for future recall.

Systemd provides a replacement for sysvinit, pm-utils, inetd, acpid, syslog, watchdog, cron and atd, and obsoletes ConsoleKit.
