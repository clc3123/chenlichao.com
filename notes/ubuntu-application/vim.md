---
layout: post
title: vim
description: vim
---

cd ~/.vim
git submodule add https://github.com/tpope/vim-pathogen.git bundle/vim-pathogen
git submodule add https://github.com/wincent/Command-T.git bundle/command-t
git submodule init

prepend the following to your vimrc:
runtime bundle/vim-pathogen/autoload/pathogen.vim

command-t需要vim的ruby支持,ubuntu server请安装vim-nox
编译command-t需要使用ruby-1.8.7-p299
参考:help command-t的帮助文档
ubuntu 12.10可以使用1.9.3编译command-t的ruby支持了.
    $ ~/.vim/bundle/command-t/
    $ bundle install
    $ rake clean
    $ rake make

编译安装
========

    $ sudo apt-get install mercurial
    $ hg clone https://vim.googlecode.com/hg/ vim
    $ cd vim
    $ ./configure --enable-rubyinterp
    $ make
    $ sudo make install

To test if things look fancy:
    $ vim --version | grep ruby
Ruby should have plus now.
Another trick to test it - enter vim and hit :ruby 1. Should not fail.
