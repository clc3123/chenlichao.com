---
layout: post
title: Tinker with Jekyll，观其所短，知其所长
description: Jekyll vs Middleman对比评测，兼谈Liquid Template，博客的第一篇文章哦
---

将近2周的时间，磕磕绊绊地用Jekyll将自己的博客架好了。:)

这次搭建的技术选型，没有过多的纠结。选用的工具，在ruby语言的几种静态网站生成器中选就好了，Middleman、Nesta、Nanoc，这些都是用过的，这次不想用了，于是选择了Jekyll。

话说Jekyll是ruby圈里开源的最早的一批 `Static Site Generator` 了，借Github之势，挂起一阵静态网站的复古风潮。但鄙人却一直没有用过。。。惭愧惭愧。。。

让我们进入正题，就几个方面将Jekyll和我熟悉的Middleman做一次对比：

## 模版语言 Liquid vs ERB, Haml

博客搭建完了，我分析了下，这其中最让人虐心的，就是Jekyll的模版语言： `Liquid` 。

它可来头不小，出自Shopify公司，当初还没 `resque` 的时候，Shopify老板写的 `delayed_job` 那可是连Github都在用。看！Liquid还有不少[大用户](https://github.com/Shopify/liquid/wiki)。

Liquid因其安全性出众，特别适合需要授权用户自行编写网页模版的场景，比如淘宝模版DIY这种场景（所以Shopify要写这么一个gem，hoho）。

使用Liquid的时候，我们可以像haml和erb一样，在模版渲染的时候，往render方法中传入需要渲染的ruby objects，把它们跟模版一起render出来，只不过，Liquid还要求我们传入的objects具有 `to_liquid` 方法，用来对objects进行转换，转换后的objects，才能渲染出来。只要我们定制的 `to_liquid` 方法合理，用户几乎不可能通过我们传入的ruby objects钻任何空子。[链接1](https://github.com/Shopify/liquid/blob/e8a3fd10d497a2f5dbda71d224eb544bb63f34c9/lib/liquid/context.rb#L181) [链接2](https://github.com/Shopify/liquid/blob/e8a3fd10d497a2f5dbda71d224eb544bb63f34c9/lib/liquid/context.rb#L216) [链接3](https://github.com/Shopify/liquid/blob/e8a3fd10d497a2f5dbda71d224eb544bb63f34c9/lib/liquid/context.rb#L223)

Liquid中除了让programmer定义 `to_liquid` 外，还为ruby的各种内置数据类型默认扩展了 `to_liquid` 的方法，包括Array，String，Hash等。

[链接](https://github.com/Shopify/liquid/blob/e8a3fd10d497a2f5dbda71d224eb544bb63f34c9/lib/liquid/extensions.rb)

    class String # :nodoc:
      def to_liquid
        self
      end
    end

    class Array  # :nodoc:
      def to_liquid
        self
      end
    end

    class Hash  # :nodoc:
      def to_liquid
        self
      end
    end

咋一看，Liquid也没对这些数据类型做特殊的转换，那么是不是我们可以随便在Jekyll的Liquid模版中插入 `{% raw %}{{ page.content.to_sym }}{% endraw %}` 呢？

呵呵...Github能随便让你在他家的Github Page中制造内存爆炸吗？别高兴得太早，看这里：

[链接](https://github.com/Shopify/liquid/blob/e8a3fd10d497a2f5dbda71d224eb544bb63f34c9/lib/liquid/context.rb#L193-L237)

    if object.respond_to?(:[]) and
      ((object.respond_to?(:has_key?) and object.has_key?(part)) or
       (object.respond_to?(:fetch) and part.is_a?(Integer)))

      # if its a proc we will replace the entry with the proc
      res = lookup_and_evaluate(object, part)
      object = res.to_liquid

      # Some special cases. If the part wasn't in square brackets and
      # no key with the same name was found we interpret following calls
      # as commands and call them on the current object
    elsif !part_resolved and object.respond_to?(part) and ['size', 'first', 'last'].include?(part)

      object = object.send(part.intern).to_liquid

      # No key was present with the desired value and it wasn't one of the directly supported
      # keywords either. The only thing we got left is to return nil
    else
      return nil
    end

哭了，这么严格的规定...想在String上做个 `String#reverse` 都不行...

上面给出的 `Liquid::Context#variable` 方法也是Liquid中一个很重要的method，实际上除了那些恐怖的[正则匹配](https://github.com/Shopify/liquid/blob/e8a3fd10d497a2f5dbda71d224eb544bb63f34c9/lib/liquid.rb#L23-L45)外，就是它来审查用户模版中对我们传入的ruby objects的调用了，可谓执掌生杀大权，随便有点非份之想，就是 `return nil` ...

举个例子，Jekyll中，我们经常用到这个：

    {% raw %}
    {% for page in site.pages %}
      ...
    {% endfor %}
    {% endraw %}

参考 `Jekyll::Site` 中的这些代码 [链接1](https://github.com/jekyll/jekyll/blob/0e20ced15185fe32d65daf39a6ad5056f9ab9b59/lib/jekyll/site.rb#L158) [链接2](https://github.com/jekyll/jekyll/blob/0e20ced15185fe32d65daf39a6ad5056f9ab9b59/lib/jekyll/site.rb#L310) [链接3](https://github.com/jekyll/jekyll/blob/0e20ced15185fe32d65daf39a6ad5056f9ab9b59/lib/jekyll/site.rb#L237-L239) [链接4](https://github.com/jekyll/jekyll/blob/0e20ced15185fe32d65daf39a6ad5056f9ab9b59/lib/jekyll/page.rb#L113-L115) [链接5](https://github.com/jekyll/jekyll/blob/0e20ced15185fe32d65daf39a6ad5056f9ab9b59/lib/jekyll/convertible.rb#L143)，可知当Liquid解析完 `site.pages` 的时候，它还是一个由 `Jekyll::Page` instances组成的array，可是当进入for循环的时候， `page` 就只是一个经过 `to_liquid` 转换的普通Hash咯，看[这里](https://github.com/jekyll/jekyll/blob/0e20ced15185fe32d65daf39a6ad5056f9ab9b59/lib/jekyll/convertible.rb#L100)

    ATTRIBUTES_FOR_LIQUID = %w[
      url
      content
      path
    ]

而page中的可访问的属性就只剩下[上面这些](https://github.com/jekyll/jekyll/blob/0e20ced15185fe32d65daf39a6ad5056f9ab9b59/lib/jekyll/page.rb#L11-L15)，以及page中YAML Front Matter中设置的那些属性了...

可见，当Jekyll采用Liquid作为template的时候，我们能够发挥的空间就很小了。

我们处理页面逻辑的时候，通常会有几个常见的需求：

1.  字符操作
2.  Hash、Array或其它具有灵活性的datatype作为临时变量
3.  读取文件系统

在Middleman中使用template的话，上面提到的都不是问题，因为template是由Haml或者ERB驱动的，运行ruby代码不在话下。

咳咳...ERB模版中执行 `<%- exec("rm -rf /") %>` 也是可以的，如果你有足够权限的话...

而在Jekyll中，不考虑对其进行扩展的情况下（想想Github Page环境）：

第1点，你只能通过 `Liquid::StandardFilters` 和 `Jekyll::Filter` 提供的filter来操纵字符串，也就是说，Github Page也只能提供这些了。你的选择很少，很纠结...

第2点，你不能初始化一个Array或者Hash来存放临时数据。除了模版render时传入的ruby object可以是一个hash，并可以包含array外，超哥我唯一发现的可以生成array的就是 `Liquid::StandardFilters#split` 。

为了将一些临时数据存储为array，我不得不采用一种很hacky的办法：首先assign一个string临时变量 `fake_array` ，再将需要存储的数据转为string， `Liquid::StandardFilters#append` 到 `fake_array` 中，需要用时再将 `fake_array` 进行split。

因此在博客的首页 `index.html` 中出现了这样的蛋疼代码（没耐心的就别看了...），虐心程度堪比 `Flappy Bird` ：

    {% raw %}
    <section id="notes">
      <h1>笔记</h1>
      <ul>
      {% assign dirstrlist = '' %}
      {% assign sorted_pages = site.pages | sort: 'url' %}

      {% for page in sorted_pages %}
        {% assign parts = page.url | replace_first: '/' | split: '/' %}
        {% if parts[0] == 'notes' %}
          {% assign dirstr = '' %}
          {% for part in parts %}
            {% unless forloop.last %}
              {% assign dirstr = dirstr | append: '/' | append: parts[forloop.index0] %}
            {% endunless%}

            {% if forloop.last %}
              {% assign dirarray = dirstrlist | replace_first: '|' | split: '|' %}
              {% if dirarray contains dirstr %}
                {% continue %}
              {% else %}
                <li>
                {% assign units = dirstr | replace_first: '/' | split: '/' %}
                {% for unit in units %}
                  {% unless forloop.first %}
                    <span class="dir">{{ unit }}</span>
                  {% endunless %}
                {% endfor %}

                {% assign dirstrlist = dirstrlist | append: '|' | append: dirstr %}

                {% for spage in sorted_pages %}
                  {% assign sparts = spage.url | replace_first: '/' | split: '/' %}
                  {% if sparts[0] == 'notes' %}
                    {% assign sdirstr = '' %}
                    {% for spart in sparts %}
                      {% unless forloop.last %}
                        {% assign sdirstr = sdirstr | append: '/' | append: sparts[forloop.index0] %}
                      {% endunless%}

                      {% if forloop.last and sdirstr == dirstr %}
                        <a href="{{ spage.url }}">{{ spart | replace: '.html' }}</a>
                      {% endif %}
                    {% endfor %}
                  {% endif %}
                {% endfor %}
                </li>
              {% endif %}
            {% endif %}
          {% endfor %}
        {% endif %}
      {% endfor %}
      </ul>
    </section>
    {% endraw %}

刷了一屏没啥营养的代码，罪过罪过...第3点，也不用说了吧...做不到的！

这么看来，Jekyll作为Github Page的基础，的确是很切合产品所需的：安全第一！因为Github并不能信任每一个它的用户。

Middleman使用Haml，可以少写很多的html代码，也不用忍受Liquid那恶心的括号和tag，这点上就很让我喜欢了。

足够的自由，自由就意味着高效（某种程度上）。

## 配套设施

Middleman在这方面大幅领先，让我们来看看：

1.  Rails的Asset Pipeline，用过的没有一个不赞的，Middleman集成得很好
2.  集成了貌似一堆 `Padrino` 的helpers（囧），基本想得到的helper都有了
3.  rack-livereload，杠杠嘀！livereload服务器端不用自己设置，执行 `$ middleman server` 的时候就自动架好了；只需chrome浏览器中安装一个插件即可。
4.  i18n...装B的玩意...

Middleman确实很nb，但是为Jekyll写的插件也不少，自己去Jekyll的官网去找。谁说屌丝不能有法拉利？Nick Quaranto的博文介绍一个凑合的Asset Pipeline [链接](http://quaran.to/blog/2013/01/09/use-jekyll-scss-coffeescript-without-plugins/)：

    desc "compile and run the site"
    task :default do
      pids = [
        spawn("jekyll"), # put `auto: true` in your _config.yml
        spawn("scss --watch assets:stylesheets"),
        spawn("coffee -b -w -o javascripts -c assets/*.coffee")
      ]
     
      trap "INT" do
        Process.kill "INT", *pids
        exit 1
      end
     
      loop do
        sleep 1
      end
    end

## 托管服务

有Github在，这个已经不是问题。如果你的Jekyll博客不使用插件的话，一个push就能搞定部署，连compile都不要。Middleman需要先compile，但又能麻烦到哪去呢，HOHO。

-------------------------------

总结时间到了。

说Jekyll是建立在Ruby的基础上，我看倒不如说是建立在Liquid上更为贴切。

在简单的需求下，比如为Github项目建立介绍页面，Jekyll绝对是首选，你的粉丝甚至可以在Github上为你的页面fix typo，获得小小的满足，hoho。

如果你想搞一个静态博客托管服务，支持在线编辑预览，Jekyll是个很好的选择。虽然也许别人希望你能支持Middleman...哭...

但如果你仅是想写个静态博客，并在本地或自己的服务器执行编译，用Middleman是更好的选择。对了，<http://teahour.fm>也是Middleman打底的哦！

Liquid的价值，可别被忽视了，需要的时候，你也能用得上。

--------------------------------

updated at 2014-02-18:

在Liquid源码中找到了 `for` tag的一点[小技巧](https://github.com/Shopify/liquid/blob/e8a3fd10d497a2f5dbda71d224eb544bb63f34c9/lib/liquid/tags/for.rb#L23-L25)：

You can also define a limit and offset much like SQL. Remember that offset starts at 0 for the first item.

    {% raw %}
    {% for item in collection limit:5 offset:10 %}
      {{ item.name }}
    {% end %}
    {% endraw %}

能把首页 `index.html` 中的虐心代码缩短一些了。:)
