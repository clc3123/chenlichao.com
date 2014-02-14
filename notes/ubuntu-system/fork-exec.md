---
layout: post
title: fork-exec
description: fork-exec
---

fork vs exec
============

<http://stackoverflow.com/questions/8667425/using-upstart-to-manage-unicorn-w-rbenv-bundler-binstubs-w-ruby-local-exec-s>

In unix land there are two key system calls that facilitate running programs: fork and exec.

fork copies the process that calls it. One process calls fork, and it returns control back to two processes. Each process must identify which it is (the parent or the child) from the value returned by fork (see the man page for details).

exec runs a new program, replacing the process that called exec.

When you simply run a command in a shell, the under the hood the shell calls fork to create a new process with its own id, and that new process (after some setup) immediately calls exec to start the command you typed. This is how most programs are run, whether by shell or your window manager or whatever. See the system function in C, which also has variants in most of the scripting languages.

If you think it's inefficient, you're probably right. It's how it has been done in unix since days of yore, and apparnetly nobody is game to change it. One of the reasons is that there are many things that are not replaced on exec, including (sometimes) open files, and the process's user and group ids.

Another reason is that a LOT of effort has been spent making fork efficient, and they have actually done a pretty good job of it - in modern unixes (with the help of the CPU) fork actually copies very little of the process. I guess nobody wants to throw all that work away.

To demonstrate:

    mslade@mickpc:~$ echo $$
    3652
    mslade@mickpc:~$ bash
    mslade@mickpc:~$ echo $$
    6545
    mslade@mickpc:~$ exec bash
    mslade@mickpc:~$ echo $$
    6545
    mslade@mickpc:~$ exit
    exit
    mslade@mickpc:~$ echo $$
    3652

Most of the popular languages have variations of fork and exec, including shell, C, perl, ruby and python. But not java.

So with all that in mind, what you need to do to make your upstart job work is make sure that it forks the same number of times as upstart thinks it does.

The exec line in ruby-local-exec is actually a good thing, it prevents a fork. Also load doesn't start a new process, it just loads the code into the existing ruby interpreter and runs it.
