---
layout: post
title: tty
description: tty
---

stdin: is not a tty
-------------------

<http://unix.stackexchange.com/questions/48527/ssh-inside-ssh-fails-with-stdin-is-not-a-tty>

By default, when you *run a command on the remote machine* using ssh, a TTY is not allocated for the remote session. This lets you transfer binary data, etc. without having to deal with TTY quirks. This is the environment provided for the command executed on computerone.

However, when you run ssh *without a remote command* , it DOES allocate a TTY, because you are likely to be running a shell session. This is expected by the ssh otheruser@computertwo.com command, but because of the previous explanation, there is no TTY available to that command.

If you want a shell on computertwo, use this instead, which will force TTY allocation during remote execution:

    $ ssh -t user@computerone.com 'ssh otheruser@computertwo.com'

This is typically appropriate when you are eventually running a shell or other interactive process at the end of the ssh chain. If you were going to transfer data, it is neither appropriate nor required to add -t, but then every ssh command would contain a data-producing or -consuming command, like:

    $ ssh user@computerone.com 'ssh otheruser@computertwo.com "cat /boot/vmlinuz"'

There's a better way to use SSH as a relay: use the *ProxyCommand* option. You'll need to have a key on the client machine that lets you log in into the second computer (public key is the recommended way of using SSH in most circumstances anyway). Put this in your ~/.ssh/config and run ssh computertwo.

    Host computerone
    HostName computerone.com
    UserName user

    Host computertwo
    HostName computertwo.com
    UserName otheruser
    ProxyCommand ssh computerone exec nc %h %p

nc is netcat. Any of the several versions available will do.

vagrant ssh command
-------------------

<https://github.com/mitchellh/vagrant/blob/master/plugins/communicators/ssh/communicator.rb>

vagrant通过以下方式在remote host上执行一些command，这种方式ssh并不会获得一个tty，但是依然具有交互特性，目前还不知道具体的原理

    $ ssh user@host 'sudo -H -E bash -l'
    tty\n
    not a tty

加上ssh `-t` 参数后，ssh可获得一个tty

    $ ssh -t user@host 'sudo -H -E bash -l'
    $ tty
    /dev/pts/0
