---
layout: post
title: watir-and-selenium
description: watir-and-selenium
---

Selenium的平台和浏览器支持情况
============================================================

http://seleniumhq.org/about/platforms.html

Watir全系列
============================================================

https://github.com/watir

Watir, Watir Webdriver, Selenium Webdriver的关系
============================================================

http://rubyforge.org/pipermail/wtr-development/2009-October/001313.html
------------------------------------------------------------

This provides an API very similar to the Java bindings, which works
nicely, but being heavily invested in the Watir API (both as a Watir
user and having written Celerity), I would like to keep using that,
while reaping all the benefits of WebDriver. So my proposal is that
Watir 2.0 should be implemented on top of these ruby bindings. The
benefits of WebDriver are many, and well summed up elsewhere. See this
blog post:

http://google-opensource.blogspot.com/2009/05/introducing-webdriver.html

Watir and WebDriver are trying to solve a lot of the same problems.
WebDriver already has great browser support that we would get for
free, making the Watir team able to concentrate on refining our API
instead of duplicating the effort to control all the various browsers.
I think this would be a very good move to make.

http://google-opensource.blogspot.jp/2009/05/introducing-webdriver.html
------------------------------------------------------------

WebDriver takes a different approach to solve the same problem as Selenium.
Rather than being a JavaScript application running within the browser,
it uses whichever mechanism is most appropriate to control the browser. 
For Firefox, this means that WebDriver is implemented as an extension.
For IE, WebDriver makes use of IE's Automation controls. By changing the 
mechanism used to control the browser, we can circumvent the restrictions
placed on the browser by the JavaScript security model. In those cases 
where automation through the browser isn't enough, WebDriver can make use 
of facilities offered by the Operating System. For example, on Windows we 
simulate typing at the OS level, which means we are more closely modeling 
how the user interacts with the browser, and that we can type into "file" 
input elements.

With the benefit of hindsight, we have developed a cleaner, Object-based
API for WebDriver, rather than follow Selenium's dictionary-based approach.

These complementary capabilities explain why the two projects are merging: 
Selenium 2.0 will offer WebDriver's API alongside the traditional Selenium 
API, and we shall be merging the two implementations to offer a capable, 
flexible testing framework.

Waitr与Watir WebDriver有什么区别？
------------------------------------------------------------

http://www.cnblogs.com/dami520/archive/2012/06/25/2561128.html
