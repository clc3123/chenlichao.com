---
layout: post
title: chef
description: chef
---

列出ohai搜集的所有automatic attributes：

    $ grep -R "provides" -h /opt/chef/embedded/lib/ruby/gems/1.9.1/gems/ohai-6.18.0/lib/ohai/plugins|sed 's/^\s*//g'|sed "s/\\\"/\'/g"|sort|uniq|grep ^provides

<http://docs.opscode.com/chef_overview_attributes.html>
