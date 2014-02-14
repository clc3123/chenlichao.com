---
layout: post
title: redis
description: redis
---

## Installation
---
Download, extract and compile Redis with:
    $ wget http://redis.googlecode.com/files/redis-2.4.2.tar.gz
    $ tar xzf redis-2.4.2.tar.gz
    $ cd redis-2.4.2
    $ make # 甚至不需要configure

The compiled binaries are now available in the src directory:
    $ cd src
    $ cp redis-server redis-cli /usr/bin # 或者加入PATH中的其它路径

Run Redis locally with:
    $ redis-server
If running it on a server you’ll probably want to use your own config file:
    $ redis-server /path/to/redis.conf

You can interact with Redis using the built-in client:
    $ redis-cli
    redis> set foo bar
    OK
    redis> get foo
    "bar"

网摘-1
==================================================

版本：Redis server version 2.2.14

客户端：python-redis2.4.9

redis安装路径/usr/local/redis/
1.复制(http://redis.io/topics/replication)

?
cd /home/cc
cp /usr/local/redis/redis.conf redis_m.conf
cp /usr/local/redis/redis.conf redis_s.conf

  编辑redis_m.conf
  dbfilename dump_m.rdb
  port 6379
  编辑redis_s.conf
  dbfilename dump_s.rdb
  port 6380
  slaveof 127.0.0.1 6379
  注. redis每次启动的时候，都后从dbfilename里读取数据到内存中。
  启动redis服务,主服务器和从服务器
  redis-server redis_m.conf
  redis-server redis_s.conf
  客户端代码

?
#!/usr/bin/env python
#coding=utf-8
import redis
m = redis.Redis(host='127.0.0.1',port=6379,db=0)
s = redis.Redis(host='127.0.0.1',port=6380,db=0)
?
#往主服务器中插入10条记录
for i in range(10):
    m.set(str(i),str(i))
 
#查看从服务器中是否有有记录
for i in range(10):
    print s.get(str(i))

 2. 复制的特性
   1. 一台主服务器可以被多台从服务器连接
   2. master-salver可形成环状
   3. salver端是非阻塞
   4. 执行只读查询时可以使用多台从服务器，我觉得有些问题：

?
for i in range(100000):
    m.lpush('list',str(i))
m.sort('list',desc=True)

断掉slaver和没有断掉slaver花费的时间差不多的。不知道是不是我的想法有问题。
   5. save的过程可以放在slaver上运行。
对于复制的过程是：
主服务器开始后台保存，并且收集所有将对数据集进行修改的新指令。当后台保存操作完成时，主服务器会将保存在磁盘中的数据库文件同步至从服务器，并将数据加载到内存中。主服务器接着会发送给从服务器所有累计的指令，以及所有从客户端收集到的将对数据集进行修改的指令。这个过程将以一个与Redis自身协议相同格式的命令流执行。简单来是，就是把db文件同步过去，然后就是累计的修改指令。

网摘-2
==================================================

1. reids Persistence持久化
在默认情况下，Redis将数据集的快照通过一个名为dump.rdb的二进制文件保存在磁盘上，在redis.conf里设置dbfilename。可以手动条用save和bgsave来保存到dump.rdb里去，这两个命令的不同之处在与save是同步，直到保存完毕之后才有返回值，而bgsave是异步的，调用bgsave后就有返回值，保存的动作在后台运行。

?
import redis
import time
m = redis.Redis(host='127.0.0.1',port=6379,db=0)
 
for i in range(30000):
    m.set(str(i),str(i))
b = time.time()
print m.save()
print time.time()-b

打印
True
0.11057806015


将m.save()换成m.bgsave()打印的内容是
True
0.0021960735321
另外也可以通过redis.conf设置参数来自动保存
save 60 10000
意识是在60s内至少有10000条数据变化是调用保存命令，默认的情况下有
save 900 1
save 300 10
save 60 10000
也就是说设置多个save的策略


redis持久化的方式
快照(Snapshotting):
    1. redis调用fork，将会得到一个子进程和一个父进程
    2. 父进程还是处理请求，子进程将内容写入临时文件中（这里涉及到copy-on-write，不是很了解），子进程的地址空间内的数 据是fork时刻整个数据库的一个快照。
    3. 当子进程将快照写入临时文件完毕后，用临时文件替换原来的快照文件，退出子进程。
    缺点很明显，每次快照持久化都是将内存数据完整写入到磁盘一次，如果数据量大的话，而且写操作比较多，必然会引起大量的磁盘io操作，可能会严重影响性能。还有自动快照的话，是隔一段时间持久化一次，势必影响了数据的可靠性。
增量文件(aof):
    修改redis.conf里的
    appendfsync everysec|always,推荐everysec，性能折中
    appendonly yes
    appendfilename appendonly.aof
    使用aof持久化方式时,redis会将每一个收到的写命令都通过write函数追加到文件中appendonly.aof。当redis重启时会通过重新执行aof文件中保存的写命令来在内存中重建整个数据库的内容。其实aof也可能导致的数据丢失，当设置appendfsync everysec时，是每秒将命令写入到aof中，所以当这一秒内出现一些异常情况，一样会导致数据丢失。
aof的缺点：同样的set命令执行多次，会导致aof越来越大，同时在重启redis的时候，相同的set也会执行多次。这样无端的增加了系统的开销。reids提供了bgrewriteaof。

?
m = redis.Redis(host='127.0.0.1',port=6379,db=0)
for i in range(30000):
    m.set('1',str(i))
看看aof文件的大小（我的是1116716字节）
调用m.bgrewriteaof()
在看看aof文件大小（1027806字节）

我的应用中把redis作为缓存，而且数据量不大，所以对上面的体会比较少，有点纸上谈兵的意识，会慢慢的将这篇文章补充完全的。


2. redis Pipelining管道技术

简单的说就是客户端没有读取到旧请求的响应，服务端依旧可以处理新请求。通过这种方式，可以完全无需等待服务端应答地发送多条指令给服务端，并最终一次性读取所有应答。
当客户端通过管道技术发送命令的时候，服务端将被强制在内存中使用队列应答。因此如果你需要使用管道技术处理非常多的命令时，最好以一个合理的数量发送。

?
#!/usr/bin/env python
#coding=utf-8
import redis
import time
m = redis.Redis(host='127.0.0.1',port=6379,db=0)
 
b = time.time()
for i in range(30000):
    m.set(str(i),str(i))
print 'set one by one cost time:',time.time()-b#set one by one cost time: 5.61089706421
 
 
b = time.time()
p = m.pipeline()
for i in range(30000):
    p.set(str(i),str(i))
p.execute()
print 'pipeline cost time:',time.time()-b#pipeline cost time: 1.31098294258

