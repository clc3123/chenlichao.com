---
layout: post
title: special-character
description: special-character
---

css-trick整理的常用字符对照表

<http://css-tricks.com/snippets/html/glyphs/>

很全面的unicode字符数据库，可查询在各种编码、各种语言下的字符表示方法：

<http://www.fileformat.info/info/unicode/char/search.htm>

------------------

关于如何在css `content`属性中写特殊字符：

<http://stackoverflow.com/questions/190396/adding-html-entities-using-css-content>

文章提到在简写字符的unicode hex编码时，只要在尾部跟上一个空格，就可避免“事故”

------------------------

html中non-breaking space `U+00a0`和space `U+0020`的区别：

The `&nbsp;` non-breaking space is used in HTML to represent a non-breaking, or blank, space. When you type several consecutive spaces into an HTML file, only the first space is recognized; all spaces that follow are ignored. But you can force blank spaces into an HTML page by typing `&nbsp;` for each blank space that you want to appear on the page.
