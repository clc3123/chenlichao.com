---
layout: post
title: postgresql
description: postgresql
---

参考文章：
+ http://www.mcbsys.com/techblog/2011/10/set-up-postgresql-for-rails-3-1/
+ http://mikewilliamson.wordpress.com/2010/12/21/creating-rails-users-in-postgres-on-ubuntu/

Installation
============

Included in distribution
------------------------

$ sudo apt-get install libpq-dev postgresql-9.1
$ sudo apt-get install pgadmin3

The repository contains many different packages including third party addons.
The most command and important packages are (substitute the version number as required):
    postgresql-client-9.1 - client libraries and client binaries
    postgresql-9.1 - core database server
    postgresql-contrib-9.1 - additional supplied modules
    libpq-dev - libraries and headers for C language frontend development
    postgresql-server-dev-9.1 - libraries and headers for C language backend development
    pgadmin3 - pgAdmin III graphical administration utility

Ubuntu ppa
----------

Create /etc/apt/sources.list.d/pgdg.list. The distributions are called codename-pgdg. In the example, replace precise with the actual distribution you are using:
    deb http://apt.postgresql.org/pub/repos/apt/ precise-pgdg main
Import the repository key from http://apt.postgresql.org/pub/repos/apt/ACCC4CF8.asc, update the package lists, and start installing packages:
    $ wget --quiet -O - http://apt.postgresql.org/pub/repos/apt/ACCC4CF8.asc | sudo apt-key add -
    $ sudo apt-get update
    $ sudo apt-get install libpq-dev postgresql pgadmin3
FAQ: https://wiki.postgresql.org/wiki/Apt/FAQ

如果上面这个源在 `apt-get update` 的时候显示key expired，
就用 `sudo apt-key list` 列出过期的key，删除之，再重新加一下key即可。

下面这个ppa已经不推荐了，用上边官方apt取代。
    $ sudo add-apt-repository ppa:pitti/postgresql
    $ sudo apt-get update
    $ sudo apt-get purge libpq-dev postgresql-9.2 postgresql-doc-9.2
    $ sudo apt-get install libpq-dev postgresql-9.2 postgresql-doc-9.2
    $ sudo apt-get install pgadmin3
参考:
    http://www.postgresql.org/download/linux/ubuntu/
    https://launchpad.net/~pitti/+archive/postgresql

enterprisedb
------------

http://www.enterprisedb.com/products-services-training/pgdownload

使用enterprisedb的postgresql安装包的话，在安装pg gem的时候可能会报错，
如果还有使用bundler，请按照以下方法解决：
    $ bundle config build.pg --with-pg-dir=/opt/PostgreSQL/9.2
详见：
    http://gembundler.com/man/bundle-config.1.html
    http://stackoverflow.com/questions/5167829/how-can-i-pass-a-paramater-for-gem-installation-when-i-run-bundle-install
    http://stackoverflow.com/questions/4393189/failing-installing-pg-gem-mkmf-rb-cant-find-header-files-for-ruby-mac-osx-1

Setting Up
==========

安装好后，会获得psql, createdb, dropdb, createuser等pg命令行工具。
同时pg会创建一个名为postgres的system用户。

关于设置用户在不同的连接方式下的认证方法，请修改/etc/postgresql/9.x/main/pg_hba.conf
可参考pg文档chapter 19

1.  切换到postgres用户（因为默认使用Peer认证，就是当前系统用户必须和使用的数据库用户同名）
    $ sudo su - postgres # 必须使用sudo切过去，因为postgres用户是不使用密码的
2.  创建一个myapp专用用户，至少需要具有createdb权限
    $ createuser myapp --no-superuser --no-createrole --createdb --pwprompt --encrypted --echo
    为用户提供createdb权限，主要考虑到在dev环境下比较方便，因为需要remigrate。
    如果在production环境下，可以直接建立好数据库，
    这样就不需要给用户createdb权限了，比较安全。
    也可以直接createuser myapp，按提示选择操作。
3.  $ exit # 退出postgres用户的session
4.  设置myapp（或除postgres外所有用户）的local连接使用密码md5认证
5.  $ sudo /etc/init.d/postgresql restart
6.  应该能用myapp（注意是数据库用户不是系统用户）登录postgres库了，试试看，会询问密码：
    $ psql postgres -U myapp

也可将第1-2步整合为：
    $ sudo -u postgres createuser myapp ... # 注意-u是sudo的参数哦！

此时可在Rails项目目录执行$ rake db:create:all
也可在psql中手动建立数据库：
    # create database myapp_development owner myapp;
    # create database myapp_test owner myapp;
    # create database myapp_production owner myapp;

pgadmin
=======

使用virtualbox时，如果在host用pgadmin连接guest的数据库，会连不上，有两种解决方式：

1.  ssh使用localforward，即ssh -L 5432:localhost:5432

2.  默认pg只listen localhost，可以在 `/etc/postgresql/9.2/main/postgresql.conf` 中添加设置 `listen_addresses = '*'`
    另外确保在同目录下的 `pg_hba.conf` 中已经为vagrant用户设置了md5认证


第一种方式方便，但是通过localhost的5432端口来访问远端的数据库，容易产生混淆。
第二种虽然麻烦点，但是更通用。

postgresql.conf
===============

关于postgresql.conf，一篇参考：
    http://www.depesz.com/2011/07/03/understanding-postgresql-conf-work_mem/

优化指南：
    http://stackoverflow.com/questions/5131266/increase-postgresql-write-speed-at-the-cost-of-likely-data-loss

ssd:
    http://www.scribd.com/doc/61186429/Effective-of-SSD-on-Postgres

Test whether pg adopt index only scan when using `count(*)`:
    http://postgresql.1045698.n5.nabble.com/9-2-and-index-only-scans-td5721249.html

关于如何使用index only scan以及是否使用，这篇文章讲得很详细：
    http://use-the-index-luke.com/sql/clustering/index-only-scan-covering-index
并提及了clustering factor对query plan的影响。

MVCC
====

Because different transactions will have visibility to a different set of rows, Postgres needs to maintain potentially obsolete records.
This is why an UPDATE actually creates a new row and why DELETE doesn’t really remove the row: it merely marks it as deleted and sets the XID values appropriately. 
As transactions complete, there will be rows in the database that cannot possibly be visible to any future transactions. These are called dead rows.

参考资料
--------

文中提及mvcc的影响和vacuum的作用。
https://devcenter.heroku.com/articles/postgresql-concurrency

下面这篇感觉里面错误不少，但是作为MVCC的概览不错
http://linuxgazette.net/68/mitchell.html

PostgreSQL's Multi-Version Concurrency Control feature frees data tables for simultaneous use by readers and writers.

Introduction

Question of the day: what's the single most annoying thing about most large multi-user databases? As anyone who's worked with one knows, it's waiting. And waiting. Whether the database system is using table-level, page-level, column-level, or row-level locking, the same annoying problem persists: readers (SELECTs) wait for writers (UPDATEs) to finish, and writers (UPDATEs) wait for readers (SELECTs) to finish. If I could only find a database that doesn't require locking. Will it ever be? Well, the answer is yes".

PostgreSQL's no-locking feature

For PostgreSQL , "no-locking" is already a reality. Readers never wait for writers, and writers never wait for readers. I can already hear the objections to the claim that there is no "no-locking" in PostgreSQL, so let me explain PostgreSQL's advanced technique called Multi-Version Concurrency Control (MVCC).
MVCC

In other database systems, locks are the only mechanism used to maintain concurrency control and data consistency. PostgreSQL, however, uses a multi-version model instead of locks. In PostgreSQL, a version is like a snapshot of the data at a distinct point in time. The current version of the data appears whenever users query a table. Naturally, a new version appears if they run the same query again on the table and any data has changed. Such changes happen in a database through UPDATE, INSERT, or DELETE statements.

Example: Row locking vs. MVCC

The essential difference between traditional row-level locking and PostgreSQL's MVCC lies in when users can see the data they selected from a particular table. In traditional row-level locking, users may wait to see the data, whereas PostgreSQL's MVCC ensures that users NEVER wait to see the data. Let's look at the following example to illustrate more clearly.

SELECT headlines FROM news_items
In this example, the statement reads data from a table called news_items and displays all the rows in the column called headlines. In data systems that use row-level locking, the SELECT statement will block and the user will have to wait if another user is concurrently inserting (INSERT) or updating (UPDATE) data in the table news items. The transaction that modifies the data holds a lock on the row(s) and therefore all rows from the table cannot be displayed, forcing users to wait until the lock releases. Users who have encountered frequent locks when trying to read data know all too well the frustration this locking scheme can cause.

In contrast, PostgreSQL would allow all users to view the news_items table concurrently, eliminating the need to wait for a lock to be released. This is always the case, even if multiple users are inserting and updating data in the table at the same time. When a user issues the SELECT query, PostgreSQL displays a snapshot - a version, actually - of all the data that users have committed before the query began. Any data updates or inserts that are part of open transactions or that were committed after the query began will not be displayed. Makes a lot of sense, doesn't it?

A Deeper Look at MVCC

Database systems that use row-level locking do not retain old versions of the data, hence the need for locks to maintain data consistency. But a deeper look into how "no-locking" through MVCC works in PostgreSQL reveals how PostrgreSQL gets around this limitation. Each row in PostgreSQL has two transaction IDs. It has a creation transaction ID for the transaction that created the row, and an expiration transaction ID for the transaction that expired the row. When someone performs an UPDATE, PostgreSQL creates a new row and expires the old one. It's the same row, but in different versions. Unlike database systems that don't hold on to the old version, when PostgreSQL creates a new version of the row it also retains the old or expired version. (Note: Old versions are retained until a process called VACUUM is run on the database.)

That's how PostgreSQL creates versions of the data, but how does it know which version to display? It bases its display on several criteria. At the start of a query, PostgreSQL records two things: 1) the current transaction ID and 2) all in-process transaction IDs. When someone accesses data, Postgres issues a query to display all the row versions that match the following criteria: the row's creation transaction ID is a committed transaction and is less than the current transaction counter, and the row lacks an expiration transaction ID or its expiration transaction ID was in process at query start.

And this is where MVCC's power resides. It enables PostgreSQL to keep track of transaction IDs to determine the version of the data, and thereby avoid having to issue any locks. It's a very logical and efficient way of handling transactions. New PostgreSQL users are often pleasantly surprise by the performance boost of MVCC over row-level locking, especially in a large multi-user environment.

MVCC also offers another advantage: hot backups. Many other databases require users to shutdown the database or lock all tables to get a consistent snapshot - not so with PostgreSQL. MVCC allows PostgreSQL to make a full database backup while the database is live. It simply takes a snapshot of the entire database at a point in time and dumps the output even while data is being inserted, updated or deleted.

CONCLUSION

MVCC ensures that readers never wait for writers and writers never wait for readers. It is a logical and efficient version management mechanism that delivers better database performance than traditional row-level locking.

MVCC doesn't avoid deadlock scenarios
-------------------------------------

Actually, explicit locking is not required to create a deadlock scenario.

创建一个测试数据库：
    $ sudo su - postgres
    $ psql postgres
    postgres=> create database testing;
    postgres=> \q

用 `psql testing` 打开两个全新的session：

Session 1:
    testing=# create table testing (value int, id serial);
    testing=# insert into testing values (1);
    testing=# insert into testing values (1);
    testing=# begin;
    BEGIN
    testing=# update testing set value = 2 where id = 1;
    UPDATE 1

Session 2:
    testing=# begin;
    BEGIN
    testing=# update testing set value = 2 where id = 2;
    UPDATE 1

Session 1:
    testing=# update testing set value = 2 where id = 2;
    (blinking... waiting for commit in session 2)

Session 2:
    testing=# update testing set value = 2 where id = 1;
    ERROR:  deadlock detected
    DETAIL:  Process 7749 waits for ShareLock on transaction 91655; blocked by process 2772.
    Process 2772 waits for ShareLock on transaction 91656; blocked by process 7749.
    HINT:  See server log for query details.

元组可见规则
------------

`http://blog.sina.com.cn/s/blog_67fd8b3c0100s72c.html`

To determine which version (tuple) of a row is visible to the transaction,
each transaction is provided with following information:

1.  A list of all active/uncommitted transactions at the start of current transaction.
2.  The ID of current transaction.
 
`http://www.chensj.cn/article/some-issues-in-mvcc-of-postgresql/`
A tuple's visibility is determined as follows:

+   xmin id 规则, Visible tuples must have a creation transaction id that:
    *   is a committed transaction and
    *   was not in-process at transaction start, ie, ID not in the list of active transactions
    or
    *   xmin是当前事务且cid > cmin
 
+   xmax id 规则, Visible tuples must also have an expire transaction id that:
    *   is blank or aborted or
    *   is greater than the transaction's ID or
    *   was in-process at transaction start, ie, ID is in the list of active transactions
    *   xmax是当前事务但是cmax > 当前cid

有趣的是，在某些不可见的tuple中，xmax比xmin还小！
 
In the words of Tom Lane:
A tuple is visible if its xmin is valid and xmax is not. Valid means either committed or the current transaction.
To avoid consulting the PG_LOG table repeatedly, PostgreSQL also maintains some status FLags in the tuple that indicate whether the tuple is \known committed" or \known aborted". These status FLags are updated by the FIrst
transaction that queries the PG_LOG table.

上述的status flag，见这篇文章 http://blog.osdba.net/?post=94
    HEAP_XMIN_COMMITTED
    HEAP_XMIN_INVALID
    HEAP_XMAX_COMMITTED
    HEAP_XMAX_INVALID
    HEAP_XMAX_IS_MULTI
    这个过程的大致机制如下：
    第一次插入数据时，t_infomask中的HEAP_XMIN_COMMITTED和HEAP_XMAX_INVALID并没有设置，
    但当事务提交后，有人再读取这个数据块时，就会判断出这些行的事务已提交了，
    这时就会设置t_infomask中的HEAP_XMIN_COMMITTED和HEAP_XMAX_INVALID标志位。

http://www.chensj.cn/article/postgresql-mvcc-ultimate/
    从9月中旬开始的PostGreSQL代码阅读，至今总算告一段落。此次分析，既有意料之中，亦有出乎意料。意料之中的是过程复杂曲折，意料之外的是PostGreSQL的MVCC实现居然如此简单。

      具体地说，在PG中，多版本的每个版本的tuple都被视作一个新的单独的tuple，进行插入。删除tuple时则直接将tuple标记为删除。Update==delete+insert。

      所有的tuple都在heap中进行操作，每次加入新的tuple或新版本的tuple时更新index。索引中，每个版本的tuple都有对应的链接项。

    对于已经过期的tuple，由vacuum程序进行物理删除，并更新相应的index。

关于cmax和cmin:
https://github.com/michaelpq/postgres/blob/master/src/backend/utils/time/combocid.c
  每个tuple在heap中的实际存储内加入三个标志，即xmin，xmax和cid。xmin是创建该tuple的事务id，xmax是删除或更新该tuple的事务id。cid在创建该tuple时是创建者的commandid–cmin，如果被同一事务删除或更新，则cid中包含了创建者的commandid-cmin和删除者的commandid-cmax，当该事务提交时，cid内存储最后操作该tuple的commandid-cmax。
    当一个数据版本被删除或者更新的时候，这个数据版本就有cmin和cmax了，这时候cmin和cmax就会被拿去hash变成一个combo id的形式存储，同时对应的掩码位会变成true。否则，也就是数据版本没有被删除，那么combo id这一列存储的就是cmin，并且对应的掩码位是false。
常用命令
========

显示用户：
    \du
    select * from pg_user;
    select * from pg_shadow;

列出数据库：
    \l

Snippets
========

快速插入数据：
CREATE TABLE replays_game (
  id integer NOT NULL,
  PRIMARY KEY (id)
);
INSERT INTO replays_game
SELECT generate_series(1, 150000);

---------------------------


MySQL
=====

$ sudo apt-get install mysql-server mysql-client mysql-admin mysql-query-browser
$ mysql -u root -p # 进入MySQL
