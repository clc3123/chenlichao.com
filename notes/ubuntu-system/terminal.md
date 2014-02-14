---
layout: post
title: terminal
description: terminal
---

Terminal
========

Originally text terminals were electronic computer terminals connected to computers by a serial port, but later computers have built-in system consoles, and terminal emulator programs that work in a graphical desktop environment.

ttyN on host
------------

getty, short for "get teletype", is a Unix program running on a host computer that manages physical or virtual terminals (TTYs). When it detects a connection, it prompts for a username and runs the 'login' program to authenticate the user. It is usually called by init.

The tty part of the name stands for teletype, but has come to mean any type of text terminal. One getty process serves one terminal.

Personal computers running Unix-like operating systems, even if they do not provide any remote login services, may still use getty as a means of logging in on a local virtual console.

终端颜色
--------

通过 `$ tput colors` 查看当前终端支持的颜色数量

常用快捷键
----------

+   ctrl-n = 下一个命令
+   ctrl-b = 左
+   ctrl-f = 右
+   ctrl-p = 上一个命令
+   ctrl-h = 退格
+   ctrl-a = 回行首
+   ctrl-e = 到行尾
+   ctrl-r = 搜索过往命令
+   ctrl-j = 换行
+   ctrl-m = 回车，相当于\r
+   ctrl-[ = esc
+   ctrl-i = tab
+   ctrl-v = 之后输入的按键被转为key sequence
+   ctrl-u = 删除直至行首
+   ctrl-k = 删除直至行尾

Terminal key sequence
---------------------

<http://stackoverflow.com/questions/4653572/how-do-i-get-the-f1-f12-keys-to-switch-screens-in-gnu-screen-in-cygwin-when-conn>

参看终端中按键（组合）被映射到的字符串（key sequence）：

    $ showkey -a

也可以在vi中进入insert模式，按ctrl-v后输入字符，则可查看到该字符的key sequence。
  
* * * * * * * * * * * * * * * * * * * * 

<http://unix.stackexchange.com/questions/53581/sending-function-keys-f1-f12-over-ssh>

1.  Terminals only understand characters, not keys. So all function keys are encoded as sequences of characters, using control characters.
2.  Apart from a few common ones that have an associated control character (Tab is Ctrl+I, Enter is Ctrl+M, Esc is Ctrl+[), function keys send escape sequences, beginning with ^[[ or ^[O.
3.  You can use the tput command to see what escape sequence applications expect for each function key on your terminal. These sequences are stored in the terminfo database.

        $ for x in {1..12}; do echo -n "F$x "; tput kf$x | cat -A; echo; done
        
4.  Another way to see the escape sequence for a function key is to press Ctrl+V in a terminal application that doesn't rebind the Ctrl+V key. Ctrl+V inserts the next character literally, and you'll be able to see the rest of the sequence, which consists of ordinary characters.
5.  Note that you may have a time limit: some applications only recognize escape sequences if they come in fast enough, so that they can give a meaning to the Esc key alone.

* * * * * * * * * * * * * * * * * * * * 

<http://en.wikipedia.org/wiki/Ascii_invisible_characters#ASCII_control_characters>

+   ASCII includes definitions for 128 characters: 33 are non-printing control characters (many now obsolete) that affect how text and space are processed and 95 printable characters, including the space (which is considered an invisible graphic).
+   ASCII reserves the first 32 codes (numbers 0–31 decimal) for control characters: codes originally intended not to represent printable information, but rather to control devices (such as printers) that make use of ASCII, or to provide meta-information about data streams such as those stored on magnetic tape.
+   Except for the control characters that prescribe elementary line-oriented formatting, ASCII does not define any mechanism for describing the structure or appearance of text within a document. Other schemes, such as markup languages, address page and document layout and formatting.
+   Caret notation often used to represent control characters on a terminal. On most text terminals, holding down the Ctrl key while typing the second character will type the control character. Sometimes the shift key is not needed, for instance ^@ may be typable with just Ctrl and 2.
+   The "escape" character (ESC, code 27), for example, was intended originally to allow sending other control characters as literals instead of invoking their meaning. This is the same meaning of "escape" encountered in URL encodings, C language strings, and other systems where certain characters have a reserved meaning. Over time this meaning has been co-opted and has eventually been changed. In modern use, an ESC sent to the terminal usually indicates the start of a command sequence, usually in the form of a so-called "ANSI escape code" (or, more properly, a "Control Sequence Introducer") beginning with ESC followed by a "[" (left-bracket) character. An ESC sent from the terminal is most often used as an out-of-band character used to terminate an operation, as in the vi text editors.

* * * * * * * * * * * * * * * * * * * * 

<http://superuser.com/questions/302367/where-to-learn-more-about-osx-terminal-app-keyboard-settings-codes>

在Mac的Terminal.app中设置按键的key sequence：

* * * * * * * * * * * * * * * * * * * * 

用putty连接ubuntu server的时候，要将输入字符的编码设为utf-8，并将终端类型选为xterm-r6。
