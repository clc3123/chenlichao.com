---
layout: post
title: 使用Ruby输出sitemap.xml中lastmod标签格式
description: SEO for Rubyist，怎样用Ruby生成站点地图中lastmod的日期时间格式？
---

Google站长工具要求网站向其提交的sitemap.xml符合[sitemaps.org](http://www.sitemaps.org/)制定的站点地图0.9规范：

<http://www.sitemaps.org/protocol.html>

其中明确了 `lastmod` 标签必须符合[W3C Date Format](http://www.w3.org/TR/NOTE-datetime)规范。这种规范确立了6种不同的datetime格式，而Google要求 `lastmod` 使用其中的两种：

## Google使用的两种lastmod格式

1.  `YYYY-MM-DD`

    如 `1997-07-16`
2.  `YYYY-MM-DDThh:mm:ssTZD` ，同[RFC3339](http://www.ietf.org/rfc/rfc3339.txt)

    如 `1997-07-16T19:20:30+01:00`

那么如何用Ruby来输出这种格式呢？

### 使用Ruby输出格式1

    clc3123@clc3123-mba:~$ irb
    2.0.0-p353 :001 > Time.now.strftime("%F")
     => "2014-02-23" 
    2.0.0-p353 :002 > Time.now.strftime("%Y-%m-%d")
     => "2014-02-23"

### 使用Ruby输出格式2

    clc3123@clc3123-mba:~$ irb
    2.0.0-p353 :001 > Time.now.strftime("%FT%T%:z")
     => "2014-02-23T13:05:51+08:00" 
    2.0.0-p353 :002 > Time.now.strftime("%Y-%m-%dT%H:%M:%S%:z")
     => "2014-02-23T13:05:53+08:00" 
    2.0.0-p353 :003 > require 'date'
     => true 
    2.0.0-p353 :004 > Time.now.to_datetime.rfc3339
     => "2014-02-23T13:06:11+08:00"
