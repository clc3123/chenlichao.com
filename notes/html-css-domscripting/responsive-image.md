---
layout: post
title: responsive-image
description: responsive-image
---

<http://alistapart.com/article/responsive-images-how-they-almost-worked-and-what-we-need>

文中提到在页首添加js代码，用来侦测客户端的屏幕参数并将其添加进相应的cookie。

而对于页内图片代码则设置为下面这样：

    <img src="images/mobile-size.r.jpg" data-fullsrc="images/desktop-size.jpg">

这样浏览器就可以在页面parse过程中只请求mobile版本的图片。

后端web server对mobile版本的图片请求做特殊处理。请求携带的cookie内容将被解析，如果发现客户端的屏幕尺寸大于某个阈值，就将该请求rewrite到另一个`1x1 spacing gif`，从而减小web server的压力。

但是某些*桌面*浏览器新增的*图片预读*策略使得上述方法的后端web server rewrite策略失效，因为此时相应的cookie还未通过js进行设置。

<http://blog.cloudfour.com/responsive-imgs/>

<http://blog.cloudfour.com/responsive-imgs-part-2/>

<http://blog.cloudfour.com/responsive-imgs-part-3-future-of-the-img-tag/>
