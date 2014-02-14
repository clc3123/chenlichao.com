---
layout: post
title: dpkg-apt-aptitude
description: dpkg-apt-aptitude
---

What are Backports
------------------

<https://help.ubuntu.com/community/UbuntuBackports>

<http://askubuntu.com/questions/25717/how-do-i-enable-the-backports-repository>

Daily Operations
----------------

查找软件包：

    $ apt-cache search curl
    $ aptitude search curl

查看软件包信息：

    $ apt-cache show imagemagick # 基本介绍
    $ apt-file search 文件名 # 查找文件所属的pkg
    $ apt-file list curl # pkg所有相关文件的安装路径，包括执行文件位置
    $ which xxx # 只查看执行文件位置

通过dpkg -i安装deb包的时候,如果提示依赖未安装,使用

    $ sudo apt-get install -f

dpkg卸载:

    $ sudo dpkg -r xxx

查看不同repository中同名软件包的优先级：

    $ apt-cache policy hello
    $ aptitude versions hello

查看版本变更：

    $ aptitude changelog hello

What does “Provides” mean in the output of apt-cache showpkg?
-------------------------------------------------------------

<http://serverfault.com/questions/306750/what-does-provides-mean-in-the-output-of-apt-cache-showpkg>

The `provide` field tells the package manager about a specific capability of the package in case there are alternatives available. 

As an example, many packages require an MTA, but they don't care about which one. Thus, they have a dependency for the meta-package `mail-transport-agent`, which is provided by ie. `exim4-daemon-light` or `nullmailer`. 

以ncurses为例，就是 `lincurses-dev` 或 `ncurses-dev` 作为meta-package，代理了 `libncurses5-dev` ：

    $ sudo apt-cache showpkg libncurses-dev (or ncurses-dev)
    ...
    Provides: 
    Reverse Provides: 
    libncurses5-dev 5.9-4

    $ sudo apt-cache showpkg libncurses5-dev
    ...
    Provides: 
    5.9-4 - ncurses-dev libncurses-dev 
    Reverse Provides:

unattended apt-get upgrade
--------------------------

按下面这个so帖子的解释，安装grub前需要通过debconf配置后，在安装过程中才会生成 `/etc/default/grub` ，所以它不能算是dpkg的conffile。

SEE ALSO `debconf.md`

<http://askubuntu.com/questions/146921/how-do-i-apt-get-y-dist-upgrade-without-a-grub-config-prompt>

The /etc/default/grub file is generated at package install time, which is necessary because it integrates with debconf. This means that it can not be treated as a dpkg conf file, and so dpkg's configuration file handling doesn't know about it.

Instead, it uses ucf, a more sophisticated Debian tool for handling configuration. This, unfortunately, doesn't understand dpkg options, so setting Dpkg::Options::="--force-confdef" won't help. It does have its own way of doing no-prompt upgrades, though, through the UCF_FORCE_CONFFNEW and UCF_FORCE_CONFFOLD environment variables.

ucf uses debconf for prompting, so setting the debconf interface to noninteractive will also silence the message. If you really want non-interactive updates you'll need to do this anyway - arbitrary packages may ask debconf questions (although they generally won't during upgrades).

You can set the debconf interface as a one-off by adding DEBIAN_FRONTEND=noninteractive to your environment, or can set it permanently by running `dpkg-reconfigure debconf` and selecting the noninteractive frontend. If you're using the noninteractive frontend you'll get the default answer for any questions a package might ask.

For ucf, the default answer is “keep the existing file”.

So, the full command to do a really, 100% guaranteed no-prompting update would be:

    $ sudo DEBIAN_FRONTEND=noninteractive apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" dist-upgrade

It's technically possible for packages to use *another method of prompting than debconf* , but this is against Debian policy. If you run across such a package, file a bug.

<http://askubuntu.com/questions/104899/make-apt-get-or-aptitude-run-with-y-but-not-prompt-for-replacement-of-configu>
<http://raphaelhertzog.com/2010/09/21/debian-conffile-configuration-file-managed-by-dpkg/>

Avoiding the conffile prompt

Every time that dpkg must install a new conffile that you have modified
(and a removed file is only a particular case of a modified file in dpkg’s eyes),
it will stop the upgrade and wait your answer. This can be particularly annoying for
major upgrades. That’s why you can give predefined answers to dpkg with the help
of multiple `--force-conf*` options:

    --force-confold: do not modify the current configuration file, the new version is installed with a .dpkg-dist suffix. With this option alone, even configuration files that you have not modified are left untouched. You need to combine it with --force-confdef to let dpkg overwrite configuration files that you have not modified.
    --force-confnew: always install the new version of the configuration file, the current version is kept in a file with the .dpkg-old suffix.
    --force-confdef: ask dpkg to decide alone when it can and prompt otherwise. This is the default behavior of dpkg and this option is mainly useful in combination with --force-confold.
    --force-confmiss: ask dpkg to install the configuration file if it’s currently missing (for example because you have removed the file by mistake).

If you use Apt, you can pass options to dpkg with a command-line like this:

    $ apt-get -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" dist-upgrade

You can also make those options permanent by creating /etc/apt/apt.conf.d/local:

    Dpkg::Options {
      "--force-confdef";
      "--force-confold";
    }

<http://serverfault.com/questions/479571/running-apt-get-upgrade-with-chef-solo>

errors when removing linux kernels
==================================

<http://serverfault.com/questions/4427/damaged-vmlinuz-and-initrd-img-symbolic-links-after-kernel-uninstall>

    The link /vmlinuz is a damaged link
    Removing symbolic link vmlinuz
    you may need to re-run your boot loader[grub]
    The link /initrd.img is a damaged link
    Removing symbolic link initrd.img
    you may need to re-run your boot loader[grub]

Those messages are nothing to worry about. They're related to using `lilo` as your bootloader, because it uses those symlinks to find your "current" kernel. Grub, being more flexible, has it's own way of doing things, and doesn't need the symlinks.

APT preference
==============

文档： `$ man 5 apt_preferences`
查看系统默认的policy： `$ sudo apt-cache policy`

<http://blog.opperschaap.net/2009/12/12/using-the-preferences-file-on-debian-and-debian-based-distributions/>

*   P > 1000 causes a version to be installed even if this constitutes a downgrade of the package
*   990 < P <=1000 causes a version to be installed even if it does not come from the target release, unless the installed version is more recent
*   500 < P <=990 causes a version to be installed unless there is a version available belonging to the target release or the installed version is more recent
*   100 < P <=500 causes a version to be installed unless there is a version available belonging to some other distribution or the installed version is more recent
*   0 < P <=100 causes a version to be installed only if there is no installed version of the package
*   P < 0 prevents the version from being installed

dpkg, apt, aptitude
===================

APT makes collection of software available to the user and does the dirty work of downloading all the required packages and installing them by calling dpkg in the correct order to respect the dependencies.

<http://www.debian.org/doc/manuals/debian-faq/ch-pkgtools.en.html>

注意，ubuntu默认不安装aptitude的，但是debian推荐使用aptitude进行日常包管理。

What is the difference between dpkg and aptitude/apt-get?
---------------------------------------------------------

<http://askubuntu.com/questions/309113/what-is-the-difference-between-dpkg-and-aptitude-apt-get>

No, `dpkg` only installs a package, so doing `dpkg -i packageName.deb` will only install this Deb package, and will notify you of any dependencies that need to be installed, but it will **not** install them, and it will **not** configure the `packageName.deb` because well...the dependencies are not there.

`apt-get` is a [**Package Management System**](http://en.wikipedia.org/wiki/Package_management_system) that handles the installation of Deb packages on [Debian-based Linux distributions](http://en.wikipedia.org/wiki/List_of_Linux_distributions#Debian-based). A Package Management System is a set of tools that will help you install, remove, and change packages easily. So `apt-get` is like a clever `dpkg`.

I like to think of the timeline this way:

-   They came up with a way to store the files of an application in a package so that it can be easily installed. So, the Deb package ([`.deb` extension file](http://en.wikipedia.org/wiki/Deb_(file_format))) was born.

    A `.deb` file contains the files needed by an application to run, as well as (I like to call it) "meta-data" that holds other information, such as the names of the dependencies the application needs. If you want to see the contents of a `.deb` file, you can use the command `dpkg -c packageName.deb`, and if you want to see this "meta-data" information, use the command `dpkg -I pacakgeName.deb`, and if you want to only see the dependencies, do `dpkg -I packageName.deb | grep Depends`.
 
-   They needed a tool to install these `.deb` files, so they came up with the `dpkg` tool. This tool, however, will just install the `.deb` file, but will not install its dependencies because it doesn't have those files and it does not have access to "repositories" to go pull the dependencies from.

-   Then, they came up with `apt-get`, which automates the problems in the previous point. Underneath the hood, `apt-get` is basically `dpkg` (so `apt-get` is a front-end for `dpkg` ), but a clever one that will look for the dependencies and install them. It even looks at the currently installed dependencies and determines ones that are not being used by any other packages, and will inform you that you can remove them.

-   **`aptitude`** then came along, and it's nothing but a front-end for `apt-get` [so, it's a front-end of a front-end]. `aptitude` is a UI (user interface) for `apt-get`. If you want to see this UI, simply type `aptitude` in the terminal; That's `aptitude`, that's what it was originally created for. `aptitude` leverages the `apt` tools to provide more options and perks than `apt-get`. For example, `aptitude` will automatically remove eligible packages, while `apt-get` needs a separate command to do so. But, in the end, doing `sudo aptitude install packageName.deb` is the same as `sudo apt-get install packageName.deb`. There might be subtle differences here and there that I do not know about, but they will both look for the dependencies and do all that stuff. You can read [the answer here](http://unix.stackexchange.com/q/767/38128) for more information on the differences between `aptitude` and `apt-get`.

Also, `aptitude` does not have Super Cow Powers.

The following information doesn't really directly answer "What is the difference between dpkg and aptitude/apt-get?" but it contributes to the big picture.

**`gdebi`** is another tool that is kind of a mixture between `apt-get` and `aptitude`. When you use it to install a `.deb` package (`gdebi packageName.deb`), it will identify the missing dependencies, install them using `apt-get`, and then finally install and configure the package using `dpkg`. It even has a [simple and neat GUI that gives you information](http://i.imgur.com/lcfsv1u.png) about the `.deb` package, the files included in the package, and what dependencies need to be installed. To see this GUI, you would do `gdebi-gtk packageName.deb`. You can give `gdebi` a try by installing it with `sudo apt-get install gdebi`.

I don't want to confuse anyone, but just to give you another part of the picture, there is another popular Linux package format called RPM, and its files have the `.rpm` extension. This package format is used on [**RPM-based** Linux distributions](http://en.wikipedia.org/wiki/List_of_Linux_distributions#RPM-based) (such as Red Hat, CentOS, and Fedora). They use the command `rpm` to install a package, and `yum` is the front-end for it, it's the clever one. So their `.rpm` files are our `.deb` files, their `rpm` tool is our `dpkg` tool, and their `yum` is our `apt-get`.

**`alien`** is a tool that converts between `.rpm` and `.deb` packages. So if you ever fall into the situation where you have an `.rpm` package, and you want to install in on your Ubuntu (or any other Debian-based distro), you can use the command `alien rpm_packageName.rpm` to convert it to `.deb`, and then install it using `dpkg`. You can do the reverse (convert `.deb` to `.rpm`) using `alien -r packageName.deb`.

<http://raphaelhertzog.com/2011/06/20/apt-get-aptitude-%E2%80%A6-pick-the-right-debian-package-manager-for-you/>

First I want to make it clear that you can use both and mix them without problems. It used to be annoying when apt-get did not track which packages were automatically installed while aptitude did, but now that both packages share this list, there’s no reason to avoid switching back and forth.

I would recommend apt-get for the big upgrades (i.e. dist-upgrade from one stable to the next) because it will always find quickly a relatively good solution while aptitude can find several convoluted solutions (or none) and it’s difficult to decide which one should be used.

<http://unix.stackexchange.com/questions/767/what-is-the-real-difference-between-apt-get-and-aptitude-how-about-wajig>

The most obvious difference is that `aptitude` provides a terminal menu interface (much like Synaptic in a terminal), whereas `apt-get` does not.

Considering only the command-line interfaces of each, they are quite similar, and for the most part, it really doesn't matter which you use. **Recent versions of both will track which packages were manually installed, and which were installed as dependencies (and therefore eligible for automatic removal).** In fact, I believe that even more recently, the two tools were updated to actually share the same database of manually vs automatically installed packages, so cases where you install something with apt-get and then aptitude wants to uninstall it are mostly a thing of the past. 

There are a few minor differences:

-   aptitude will automatically remove eligible packages, whereas apt-get requires a separate command to do so
-   The commands for *upgrade* vs. *dist-upgrade* have been renamed in aptitude to the probably more accurate names *safe-upgrade* and *full-upgrade*, respectively.
-   aptitude actually performs the functions of not just apt-get, but also some of its companion tools, such as apt-cache and apt-mark.
-   aptitude has a slightly different query syntax for searching (compared to apt-cache)
-   aptitude has the *why* and *why-not* commands to tell you which *manually installed* packages are preventing an action that you might want to take.
-   If the actions (installing, removing, updating packages) that you want to take cause conflicts, aptitude can suggest several potential resolutions. apt-get will just say "I'm sorry Dave, I can't allow you to do that."

There are other small differences, but those are the most important ones that I can think of.

In short, aptitude more properly belongs in the category with Synaptic and other higher-level package manager frontends. It just happens to also have a command-line interface that resembles apt-get.

Bonus Round: What is wajig?

Remember how I mentioned those "companion" tools like apt-cache and apt-mark? Well, there's a bunch of them, and if you use them a lot, you might not remember which ones provide which commands. wajig is one solution to that problem. It is essentially a dispatcher, a wrapper around all of those tools. It also applies sudo when necessary. When you say `wajig install foo`, wajig says "Ok, `install` is provided by `apt-get` and requires admin privileges," and it runs `sudo apt-get install foo`. When you say `wajig search foo`, wajig says "Ok, `search` is provided by `apt-cache` and does not require admin provileges," and it runs `apt-cache search foo`. If you use wajig instead of apt-get, apt-mark, apt-cache and others, then you'll never have this problem:

    $ apt-get search foo
    E: Invalid operation search

If you want to know what wajig is doing behind the scenes, which tools it is using to implement a particular command, it has `--simulate` and `--teaching` modes that show you.

Two wajig commands that I use often are `wajig listfiles foo` and `wajig whichpkg /usr/bin/foo`.

<http://askubuntu.com/questions/1743/is-aptitude-still-considered-superior-to-apt-get>

As far as I can see, in 10.04, the main differences between aptitude
and apt-get are: 

1.  aptitude adds explicit per-package flags, indicating whether a
    package was automatically installed to satisfy a dependency: you
    can manipulate those flags (`aptitude markauto` or `aptitude
    unmarkauto`) to change the way aptitude treats the package.

    **apt-get keeps track of the same information**, but will not show it
    explicitly. `apt-mark` can be used for manipulating the flags.

2.  aptitude will offer to remove unused packages each time you
    remove an installed package, whereas **apt-get will only do that if
    explicitly asked** to with `apt-get autoremove`.

3.  aptitude acts as a single command-line front-end to most of the
    functionalities in both apt-get and apt-cache.

4.  In contrast to apt-cache's "search", aptitude's "search" output
    also shows the installed/removed/purged status of a package (plus
    aptitude's own status flags).  Also, the "install" output marks
    which packages are being installed to satisfy a dependency, and
    which are being removed because unused.

5.  aptitude has a (text-only) interactive UI.

<http://www.webupd8.org/2010/06/aptitude-removed-from-ubuntu-1010.html>

<http://superuser.com/questions/93437/aptitude-vs-apt-get-which-is-the-recommended-aka-the-right-tool-to-use>

`aptitude` and `apt-get` work the same for many tasks, but for the most tricky cases, such as distribution upgrades (`apt-get dist-upgrade` vs. `aptitude full-upgrade`), they have different rules, and aptitude's rules are nearly always better in practice where they disagree.

**The reason you see more documentation for `apt-get` over `aptitude` is mostly inertia:** `aptitude` has not been the recommended front end to APT for all that long, so much of the existing documentation hasn't been updated, and there are plenty of people who recognise the advantages of `aptitude` over `apt-get` but use `apt-get` reflexively.  

**Postscript** Note that the rules used in `apt-get` and `aptitude` are moving targets - as Hubert notes in comments, the upgrade path recommended from Debian Lenny now uses `apt-get`, not `aptitude`.  This reflects the fact that `apt-get` keeps track of less state about the current package than `aptitude`, and so does not need to worry about APT state not being "clean", and because `apt-get` rules are smarter than they used to be. I still use and recommend `aptitude` over `apt-get`, but it is a more nuanced recommendation

`apt-get` does have the advantage of being more **memory-efficient**. This is unlikely to be noticeable for most users; I wasn't really aware of it until I tried to upgrade packages on a full Debian install with 32MB of RAM. `aptitude` ended up thrashing in swap for about an hour per run; apt-get was significantly faster.

tasksel
-------

<http://www.debian.org/doc/manuals/debian-faq/ch-pkgtools.en.html#s-tasksel>

When you want to perform a specific task it might be difficult to find the appropiate suite of packages that fill your need. The Debian developers have defined tasks, a task is a collection of several individual Debian packages all related to a specific activity. Tasks can be installed through the tasksel program or through aptitude.

The Debian installer will typically install automaticaly the task associated with a standard system and a desktop environment. The specific desktop environment installed will depend on the CD/DVD media used, most commonly it will be the GNOME desktop (gnome-desktop task). Also, depending on your selections throughout the installation process, tasks might be automatically installed in your system. For example, if you selected a language, the task associated with it will be installed automatically too and if you are running in a laptop system the installer recognises the laptop task will be installed too.
