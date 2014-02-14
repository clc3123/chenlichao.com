---
layout: post
title: debconf
description: debconf
---

dpkg-reconfigure - reconfigure an already installed package using debconf
=========================================================================

You can change the default frontend debconf uses by `dpkg reconfigure debconf`. On the other hand, if you just want to change the frontend for a minute, you can set the `DEBIAN_FRONTEND` environment variable to the name of the frontend to use.

这个命令默认显示low priority的问题。

DESCRIPTION

    dpkg-reconfigure reconfigures packages after they have already been installed. Pass it the names of a package or packages to reconfigure. It will ask configuration questions, much like when the package was first installed. If you just want to see the current configuration of a package, see debconf-show(1) instead.

OPTIONS

    -ftype, --frontend=type

    Select the frontend to use. The default frontend can be permanently changed by:

        $ dpkg-reconfigure debconf

    Note that if you normally have debconf set to use the noninteractive frontend, dpkg-reconfigure will use the dialog frontend instead, so you actually get to reconfigure the package.

Unattended Package Installation with Debian and Ubuntu
======================================================

<http://blog.hjksolutions.com/articles/2007/07/27/unattended-package-installation-with-debian-and-ubuntu.html>

Apt is a wonderful tool, but it does have its quirks. One of those is that it likes to ask you interactive questions during package installation. This makes total sense when a human is doing apt-get install foobar, but it causes all sorts of consternation when you want to automatically install packages. (You do this all the time with Puppet, which I’ll talk more about at the end of this post.)

The answer to this problem is to pre-seed `debconf` with the correct answers to it’s questions. To do this, first you need to install the package by hand:

    $ apt-get install libnss-ldap

You’ll need to provide answers to the questions it asks, which we’re going to re-use later as the basis for our seed file. Next, make sure you have `debconf-utils` installed, and grab the answers to your questions:

    $ apt-get install debconf-utils # Only if you need it
    $ debconf-get-selections | grep libnss-ldap
    libnss-ldap     libnss-ldap/rootbindpw  password
    libnss-ldap     libnss-ldap/bindpw      password
    libnss-ldap     libnss-ldap/dblogin     boolean false
    # Automatically update libnss-ldap's configuration file?
    libnss-ldap     libnss-ldap/override    boolean false
    libnss-ldap     shared/ldapns/base-dn   string   dc=example,dc=com
    libnss-ldap     libnss-ldap/rootbinddn  string   cn=admin,dc=example,dc=com
    libnss-ldap     shared/ldapns/ldap_version      select   3
    libnss-ldap     libnss-ldap/binddn      string   cn=proxyuser,dc=example,dc=net
    libnss-ldap     shared/ldapns/ldap-server       string   ldapi:///
    libnss-ldap     libnss-ldap/nsswitch    note
    libnss-ldap     libnss-ldap/confperm    boolean false
    libnss-ldap     libnss-ldap/dbrootlogin boolean true

Take the output of that and stick it in a file, say libnss-ldap.seed. You can now use that file to pre-seed a new system with those answers using debconf-set-selections:

    $ debconf-get-selections | grep libnss-ldap > /tmp/libnss-ldap.seed
    $ debconf-set-selections /tmp/libnss-ldap.seed

Or use ssh to pre-seed a new box:

    $ cat /tmp/libnss-ldap.seed | ssh somehost debconf-set-selections

If you are using Puppet (and if you’re not, you should be) to manage your systems, you can use a recipe like this to automatically install packages that require interaction:

    define seed_package($ensure = latest) {
      $seedpath = "/var/cache/local/preseeding" 
      file { "$seedpath/$name.seed":
        source => "puppet://$puppet_server/seeds/$lsbdistcodename/$name.seed",
        mode => 0600,
        owner => root,
        group => root
      }
      package { $name:
        ensure => $ensure,
        responsefile => "$seedpath/$name.seed",
        require => File["$seedpath/$name.seed"],
      }
    }

    class foobar {
      seed_package { "libnss-ldap":
        ensure => latest
      }
    }

debconf-utils
=============

可以获得两个command：debconf-get-selections和debconf-set-selections

其中debconf-get-selections可以获得全部debconf数据库的内容

Automating new Debian installations with preseeding
===================================================

<http://www.debian-administration.org/articles/394>

用preseed来配置新安装的系统

It's simply an answer file for all questions asked by the debian installer. The only thing the installer needs to know is where to find the file which answers all questions.

The preseed file is generated with the command:

    $ debconf-get-selections --installer > preseed.cfg
    $ debconf-get-selections >> preseed.cfg

However this does not seem to work all the time. It is also noted in the Debian documentation that you should modify the example preseed file with this generated file.

加入 `--installer` 貌似是dump出系统安装时的debconf配置参数，不加的话则是dump之后安装packages时使用的配置，两者有少量配置重叠。待考证。


auto-seeding with chef & puppet
===============================

<http://projects.puppetlabs.com/projects/1/wiki/Debian_Preseed_Patterns>
