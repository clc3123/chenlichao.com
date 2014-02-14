---
layout: post
title: locales
description: locales
---

<http://www.thomas-krenn.com/de/wiki/Perl_warning_Setting_locale_failed_unter_Debian>

<http://www.thomas-krenn.com/de/wiki/Locales_unter_Ubuntu_konfigurieren>

显示当前系统中locale的设置：

    $ locale

显示所有可用的locale：

    $ locale -a

如果所需的locale不在上述列表中，用 `locale-gen` 命令来生成：

    $ locale-gen en_US.UTF-8

ubuntu中， `locale-gen` 调用 `localedef` 来生成locale相关文件，具体可查看：
    
    $ vi `which locale-gen`

ubuntu的默认locale设置保存在 `/etc/default/locale` 中，可直接用vi编辑，也可以用：

    $ update-locale LC_ALL=\"en_US.UTF-8\"

<http://www.thomas-krenn.com/de/wiki/Perl_warning_Setting_locale_failed_unter_Debian>

<https://bugs.launchpad.net/command-not-found/+bug/997769>

--------------------------------------------------------------------------------

<http://www.syn-ack.org/centos-linux/fixing-the-lc_ctype-cannot-change-locale-utf-8-error-on-centos/>

SSH sends `LC_*` environment variables

The problem is that your SSH client is by default configured to send your `LC_*` environment variables. This means that SSH will try to set every `LC_*` variable you have set on your local (connecting) system on the remove system as well. The problem is that since CentOS 6.3 the name of the locale is not compatible with what some SSH clients (like the default OpenSSH client on Apple Mac OSx) has set.

When you run:

    $ printenv

you see which `LC_*` variables are set locally. On my Mac OSx Mountain Lion system it prints:

    LC_TYPE=UTF-8

The fix is very easy. On your local system open your ssh_config file as root (usually in /etc/ssh_config or /etc/sshd/ssh_config) and comment this line:

    SendEnv LANG LC_*

--------------------------------------------------------------------------------

如何修改locale中的date显示设置

<http://ccollins.wordpress.com/2009/01/06/how-to-change-date-formats-on-ubuntu/>

Say for example, I would prefer to use the German date format of “06.01.2009″, or “%d.%m.%Y”.  How would I achieve this?

A simple answer would be to configure your system to use a German locale, by editing /etc/environment and adding (or modifying) the line:

    LC_TIME=de_DE.UTF-8

The problem with this approach, is that more than dates and times are now changed, such as day and month names (now being in German).

A better way would be to customise your current locale (en_IE in my case). To do this, change directory to /usr/share/i18n/locales. Here you will find many locales for many regions. Choose the locale you wish to customise and copy it by executing:

    $ sudo cp en_IE custom

Next chose the date or time format string you would like.  In our case it will be “%d.%m.%Y”.  You can check and modify this string using the date command, as in:

    $ date +%d.%m.%Y

If this returns the date in the format you would like, then you know you have the right format string. You can find all format codes if you use “man date”.

The date format string, is specified in the locale file using a Unicode notation.  Open our custom locale using your favourite text editor:

    $ sudo vi custom

The date format is specified on the line beginning “d_fmt”, and looks like:

    d_fmt "<U0025><U0064><U002F><U0025><U006D><U002F><U0025><U0079>"

You will now have to convert your date format string to Unicode.  You can do this, by looking up the Unicode equivalent for each character on http://asciitable.com/.  In this way “%” becomes “<U0025>”, “d” becomes “<U0064>”, “.” becomes “<U002E>”, and so on.  Replace the d_fmt line with your new format string:

    d_fmt "<U0025><U0064><U002E><U0025><U006D><U002E><U0025><U0059>"

The same process can be used to modify the datetime format (d_t_fmt), date format (d_fmt), time format (t_fmt), am and pm format (am_pm), and standard 12 hour notation (t_fmt_ampm), as well as other locale settings.

Save and exit your text editor. You now have a custom locale in the file “custom”.  In order for the system to use it, you need to compile it into a system readable locale definition. This can be done using the locale compiler by executing:

    $ sudo localedef -f UTF-8 -i custom custom.UTF-8

Now the new custom locale is available to the system, you need to configure the system to use it. Do this by editing the file /etc/environment and adding (or modifying) the line:

    LC_TIME="custom.UTF-8"

All that remains is to log out and log in again, or restart any system services, to see the new format being applied.
