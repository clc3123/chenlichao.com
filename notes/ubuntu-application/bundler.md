---
layout: post
title: bundler
description: bundler
---

bundle outdated (--pre) # 查看Gem最新版本信息，加--pre可查看测试版Gem

bundle install --path vendor/bundle # 指定Gem安装路径，这个path设定是持久的
bundle config # 确认path设置成功
bundle install --system # 恢复默认Gem安装路径

如果Gem安装指定了path，那么bundle install和bundle update时，
会自动执行bundle clean，清除旧的Gem。
