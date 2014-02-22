---
layout: post
title: Tinker with Jekyll，兼谈Liquid Template
description: Jekyll vs Middleman，兼谈Liquid Template，博客的第一篇文章哦
---

用了将近2周的时间，磕磕绊绊，总算用Jekyll将自己的博客架好了。。。

回忆当初技术选型的时候，Ruby语言的静态网站生成器中，Middleman、Nesta、Nanoc，因为已经用过，心想折腾个没用过的吧，于是选择了Jekyll。

呵呵...虽说Jekyll是开源的最早的也是最火的 `Static Site Generator` ，但鄙人却一直没有用过。。。惭愧惭愧。。。

注：本文讨论的gem版本为：

*   [Jekyll](http://jekyllrb.com) 1.4.3
*   [Liquid](https://github.com/Shopify/liquid) 2.5.5

## Jekyll vs Middleman

接下来，我将就模版、开发环境两个方面将Jekyll和我熟悉的Middleman做一次对比：

### 模版语言 Liquid vs ERB, Haml

博客搭建完了，我分析了下，这其中最让人虐心的，就是Jekyll的模版语言： `Liquid` 。

它可来头不小，出自Shopify公司，当初还没 `resque` 的时候，Shopify老板写的 `delayed_job` 那可是连Github都在用。Liquid还有不少[大用户](https://github.com/Shopify/liquid/wiki)。

Liquid模版因其安全性出众，特别适合需要授权用户自行编写网页模版的场景，比如淘宝模版DIY这种场景（所以Shopify要写这么一个gem，hoho）。

使用Liquid的时候，我们可以像haml和erb一样，在模版渲染的时候，往render方法中传入需要渲染的ruby objects，把它们跟模版一起render出来，只不过，Liquid还要求我们传入的objects具有 `to_liquid` 方法，每个objects必须用其进行转换才能渲染出来。只要我们定制的 `to_liquid` 方法合理，用户几乎不可能通过我们传入的ruby objects钻任何空子。 [链接1](https://github.com/Shopify/liquid/blob/e8a3fd10d497a2f5dbda71d224eb544bb63f34c9/lib/liquid/context.rb#L181) [链接2](https://github.com/Shopify/liquid/blob/e8a3fd10d497a2f5dbda71d224eb544bb63f34c9/lib/liquid/context.rb#L216) [链接3](https://github.com/Shopify/liquid/blob/e8a3fd10d497a2f5dbda71d224eb544bb63f34c9/lib/liquid/context.rb#L223)

Liquid默认为ruby的各种内置数据类型扩展了 `to_liquid` 的方法，包括Array，String，Hash等。

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

呵呵...Github能随便让你在他家的Github Page中制造内存爆炸吗？别高兴得太早，参考 `Liquid::Context#variable` 的代码：

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

哭了，这么严格的规定...想在string上整个 `String#reverse` 都不行...

上面给出的 `Liquid::Context#variable` 方法也是Liquid中一个很重要的method，实际上除了那些恐怖的[正则匹配](https://github.com/Shopify/liquid/blob/e8a3fd10d497a2f5dbda71d224eb544bb63f34c9/lib/liquid.rb#L23-L45)外，就是它来审查用户模版中对我们传入的ruby objects的调用了，可谓执掌生杀大权，随便有点非份之想，就是 `return nil` ...

举个例子，Jekyll中，我们经常用到这个：

    {% raw %}
    {% for page in site.pages %}
      ...
    {% endfor %}
    {% endraw %}

参考 `Jekyll::Site` 中的这些代码 [链接1](https://github.com/jekyll/jekyll/blob/0e20ced15185fe32d65daf39a6ad5056f9ab9b59/lib/jekyll/site.rb#L158) [链接2](https://github.com/jekyll/jekyll/blob/0e20ced15185fe32d65daf39a6ad5056f9ab9b59/lib/jekyll/site.rb#L310) [链接3](https://github.com/jekyll/jekyll/blob/0e20ced15185fe32d65daf39a6ad5056f9ab9b59/lib/jekyll/site.rb#L237-L239) [链接4](https://github.com/jekyll/jekyll/blob/0e20ced15185fe32d65daf39a6ad5056f9ab9b59/lib/jekyll/page.rb#L113-L115) [链接5](https://github.com/jekyll/jekyll/blob/0e20ced15185fe32d65daf39a6ad5056f9ab9b59/lib/jekyll/convertible.rb#L143)，可知当Liquid解析完 `site.pages` 的时候，它还是一个由 `Jekyll::Page` instances组成的array，可是当进入for循环的时候， `page` 就只是一个经过 `Liquid::Convertible#to_liquid` 转换的普通Hash咯，见[这里](https://github.com/jekyll/jekyll/blob/0e20ced15185fe32d65daf39a6ad5056f9ab9b59/lib/jekyll/convertible.rb#L100)

    ATTRIBUTES_FOR_LIQUID = %w[
      url
      content
      path
    ]

而page中的可访问的属性就只剩下[上面这些](https://github.com/jekyll/jekyll/blob/0e20ced15185fe32d65daf39a6ad5056f9ab9b59/lib/jekyll/page.rb#L11-L15)，以及page中YAML Front Matter中设置的那些属性了...

可见，因为Jekyll采用的是Liquid作为template，我们能够发挥的空间就很小了。

比如说，在我们处理页面逻辑的时候，通常会有几个常见的需求：

1.  字符操作
2.  读取文件系统
3.  Hash、Array或其它具有灵活性的datatype作为临时变量

在Middleman中使用template的话，上面提到的都不是问题，因为template是由Haml或者ERB驱动的，运行ruby代码不在话下。咳咳...ERB模版中执行 `<%- exec("rm -rf /") %>` 也是可以的，如果你有足够权限的话...

而在不考虑对Jekyll进行扩展的情况下（比如Github Page这样的环境）：

第1点，你只能通过 `Liquid::StandardFilters` 和 `Jekyll::Filter` 提供的filter来操纵字符串，查看代码后会发现，可供操作字符串的filter少的可怜，很多常见的方法都见不到，很纠结...

第2点，也是不可能的...除非你有极好的眼力和耐心来洞察Liquid代码中的漏洞，哈哈！

第3点，你不能初始化一个array或者hash来存放临时数据。超哥我唯一发现的可以生成array的就是 `Liquid::StandardFilters#split` ，可是Liquid中的array缺少了例如“掐头去尾”的filter，可操作性很小。

为了将一些临时数据存储为array，我不得不采用一种很hacky的办法：首先assign一个string临时变量 `fake_array` ，再将需要存储的数据转为string， `Liquid::StandardFilters#append` 到 `fake_array` 中，需要用时再将 `fake_array` 进行split来获取array。

![note-tree](/images/tinker-with-jekyll/note-tree.jpg)

在网站首页中，我就用到了上面提到的这个方法。为了将所有的notes（如上图）生成一个按目录分类的索引：

![note-index](/images/tinker-with-jekyll/note-index.jpg)

我竟然写了这么长的一段蛋疼的代码，虐心程度堪比 `Flappy Bird` ：

超哥注：改进后的相应代码见页尾，利用了几个Liquid中发现的特性

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

这么看来，Jekyll作为Github Page的基础，的确是很切合产品所需的：安全第一！想靠着黑Github出名的用户也是有的哦，呵呵。

再看Middleman，因为使用[Haml](http://haml.info/)，可以少写很多的html代码，也不用忍受Liquid那恶心的括号和tag；因为结合了Asset Pipeline，Haml2Html也无需额外动手。所以说一旦上手，是件很爽的事。

### 开发环境 Development Environment

Middleman在这方面大幅领先，让我们来看看：

1.  Rails的Asset Pipeline，用过的没有一个不赞的，Middleman集成得很好
2.  集成了貌似一堆 `Padrino` 的helpers（囧），基本想得到的helper都有了
3.  rack-livereload，杠杠嘀！livereload服务器端不用自己设置，执行 `$ middleman server` 的时候就自动架好了；只需chrome浏览器中安装一个插件即可。
4.  i18n...装B的玩意...

再看Jekyll，虽然因为自身简约的哲学，没有搞Middleman那种一站式方案，但因为社区很火很强大，所以为它写的插件也不少，大家可以自己去Jekyll的官网去找。这次我就用到了[jekyll-assets](https://github.com/ixti/jekyll-assets)这个gem，可以说是完美复制Asset Pipeline。

谁说屌丝不能有法拉利？Nick Quaranto的博文介绍一个Jekyll用的简化版Asset Pipeline方案：

[链接](http://quaran.to/blog/2013/01/09/use-jekyll-scss-coffeescript-without-plugins/)

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

## 总结

对比完两个方面，还是总结一下吧：

虽说Jekyll是Ruby写的，可我看倒不如说是建立在Liquid上更为贴切。有了Liquid的安全性，才能有Jekyll，才能有Github Page。

在简单的需求下，比如为Github项目建立介绍页面，Jekyll绝对是首选，你的粉丝甚至可以在Github上为你的页面fix typo，获得小小的满足，hoho。

还有，如果要搞一个静态博客托管服务，支持在线编辑预览，Jekyll是个很好的选择。

但如果你想写个稍微复杂些的静态博客，需要更强大更丰富的模板语言，能在本地或自己的服务器执行编译，One-stop的Middleman想必用着更爽些。

对了，<http://teahour.fm>也是Middleman打底的哦！

别忘了Liquid，好东西！

## updated at 2014-02-18

在Liquid源码中找到了 `for` tag的一点[小技巧](https://github.com/Shopify/liquid/blob/e8a3fd10d497a2f5dbda71d224eb544bb63f34c9/lib/liquid/tags/for.rb#L23-L25)：

You can also define a limit and offset much like SQL. Remember that offset starts at 0 for the first item.

    {% raw %}
    {% for item in collection limit:5 offset:10 %}
      {{ item.name }}
    {% end %}
    {% endraw %}

能把首页 `index.html` 中的虐心代码缩短一些了。:)

## updated at 2014-02-19

首页 `index.html` 中的代码升级，主要是变量命名上的变化，如下：

    {% raw %}
    <section id="notes">
      <h1>笔记</h1>
      <ul>
      {% assign page_dir_collection = '' %}
      {% assign sorted_pages = site.pages | sort: 'url' %}

      {% for page in sorted_pages %}
        {% assign parts = page.url | replace_first: '/' | split: '/' %}
        {% if parts[0] == 'notes' %}
          {% assign note_dir = '' %}
          {% for part in parts %}
            {% if forloop.last %}
              {% assign page_dir_array = page_dir_collection | replace_first: '|' | split: '|' %}
              {% if page_dir_array contains note_dir %}
                {% continue %}
              {% else %}
                <li>
                {% assign page_dir_collection = page_dir_collection | append: '|' | append: note_dir %}

                {% assign parts = note_dir | replace_first: '/' | split: '/' %}
                {% for part in parts offset: 1 %}
                  <span class="dir">{{ part }}</span>
                {% endfor %}

                {% for page in sorted_pages %}
                  {% assign parts = page.url | replace_first: '/' | split: '/' %}
                  {% if parts[0] == 'notes' %}
                    {% assign matching_note_dir = '' %}
                    {% for part in parts %}
                      {% if forloop.last %}
                        {% if matching_note_dir == note_dir %}
                          <a href="{{ page.url }}">{{ part | replace: '.html' }}</a>
                        {% endif %}
                      {% else %}
                        {% assign matching_note_dir = matching_note_dir | append: '/' | append: part %}
                      {% endif %}
                    {% endfor %}
                  {% endif %}
                {% endfor %}
                </li>
              {% endif %}
            {% else %}
              {% assign note_dir = note_dir | append: '/' | append: part %}
            {% endif %}
          {% endfor %}
        {% endif %}
      {% endfor %}
      </ul>
    </section>
    {% endraw %}

在Liquid中，例如 `for` `if` `case` 这样的block tag都会利用 `Liquid::Context#stack` 来新建一个 `local scope` （[代码](https://github.com/Shopify/liquid/blob/712d97e37d4da88ab1951425cce8d694008d6451/lib/liquid/context.rb#L103-L108)），因此part或者page这样的循环变量完全不用担心和 `outer scope` 的同名变量冲突。原先代码中的 `spart` 和 `spage` 这样怪异的变量命名都变得多余。

但是要小心 `assign` tag的使用（[代码](https://github.com/Shopify/liquid/blob/712d97e37d4da88ab1951425cce8d694008d6451/lib/liquid/tags/assign.rb#L26)），它可是对最外层scope中的同名变量做赋值。Liquid的Github Repo中有一个增加local scope变量赋值的[feature request](https://github.com/Shopify/liquid/issues/129)，我个人还是蛮支持的。
