---
layout: post
title: ubuntu-desktop
description: ubuntu-desktop
---

$ sudo apt-get install git-core tree htop vim-nox screen byobu curl ack-grep gnome-tweak-tool
$ sudo ln -s $(which ack-grep) /usr/local/bin/ack # 这样vim-ack才能用

移除unity全局菜单，重装这些包可恢复：
    $ sudo apt-get remove appmenu-gtk appmenu-gtk3 appmenu-qt indicator-appmenu
http://askubuntu.com/a/133005

调整屏幕gamma值：
    $ xgamma -gamma 0.80

http://askubuntu.com/questions/37313/how-do-i-deactivate-f1-and-f10-keybindings/128800#128800
Disable F10 in gnome-terminal in 12.04, Type this in the console:
$ mkdir -p ~/.config/gtk-3.0
$ cat<<EOF > ~/.config/gtk-3.0/gtk.css
@binding-set NoKeyboardNavigation {
     unbind "<shift>F10"
}
* {
     gtk-key-bindings: NoKeyboardNavigation
}
EOF

Fonts
=====

There are various locations in GNU/Linux in which fonts can be kept.
These locations are defined in /etc/fonts/fonts.conf; standard ones include:
+ /usr/share/fonts
+ /usr/local/share/fonts
+ ~/.fonts

https://wiki.ubuntu.com/Fonts

解决中文文件名乱码
==================

    $ sudo apt-get install convmv

    -r 递归处理子文件夹
    --notest 真正进行操作，在默认情况下只是dryrun

    $ convmv -f gbk -t utf8 -r MY_DIR
    $ convmv --notest -f gbk -t utf8 -r MY_DIR

dconf & gsettings
=================

dconf is not Ubuntu specific, it's the GNOME technology used to store application settings.
dconf is the GNOME3 replacement for gconf which has not been maintained for some time.
dconf is also expected to bring performance improvements over gconf.

http://askubuntu.com/questions/22313/what-is-dconf-and-what-is-its-function-and-how-do-i-use-it
看其中的第一篇回复,主要摘录如下:
As other answers on this site discuss gconf and dconf together, 
I will just concentrate on discussing command-line toolssuch as *gsettings*
and the gui *dconf-editor* that are used to access the dconf database.

http://askubuntu.com/questions/34490/what-are-the-differences-between-gconf-and-dconf

http://askubuntu.com/questions/91403/when-to-use-gconf-vs-dconf
dconf is a new way for applications to store settings, and it is intended to replace gconf.
At the moment that transition is still a work in progress,
so many applications continue to use gconf. In addition, some applications still have
settings left over in gconf even though they are using dconf now.

dconf scheme default setting: /usr/share/glib-2.0/schemas/\*.xml

gsetting
--------

To list all the available schemas, enter:
    $ gsettings list-schemas
To also include all the keys, enter:
    $ gsettings list-recursively
List all keys belogs to specified schema:
    $ gsettings list-keys org.gnome.desktop.interface

Example - modify system font:
    $ gsettings set org.gnome.desktop.interface font-name "WenQuanYi Micro Hei 10"
    $ gsettings set org.gnome.desktop.interface document-font-name "Sans 11"
    $ gsettings set org.gnome.desktop.interface monospace-font-name "Ubuntu Mono 13"
    $ gsettings set org.gnome.desktop.wm.preferences titlebar-font "Ubuntu Bold 11"
    $ gsettings set org.gnome.nautilus.desktop font ""

dconf-editor
------------

包含安装了dconf-editor等工具
    $ sudo apt-get install dconf-tools 

gvim with in-window appmenu
===========================

http://askubuntu.com/questions/6784/is-it-possible-to-make-indicator-appmenu-ignore-a-specific-application

+ Change the launcher's .desktop file in the /usr/share/applications directory:
      $ sudo vi /usr/share/applications/gvim.desktop
  Now edit the Exec= line:
      Exec=env UBUNTU_MENUPROXY= gvim
  Disadvantages: it will change the launcher for all users and will probably be reverted by system updates.

+ Better method:
  If already added, unpin the launcher from the launcher bar.
  Copy gvim .desktop file to home directory:
      $ cp /usr/share/applications/gvim.desktop ~/.local/share/applications
  Now edit the Exec= line:
      Exec=env UBUNTU_MENUPROXY= gvim
  Make the file executable:
      $ chmod +x ~/.local/share/applications/gvim.desktop
  Start Nautilus in that folder and double click the gvim .desktop file:
      $ nautilus ~/.local/share/applications
  Now you should see the launcher icon in the launcher bar,
  pin it via the quicklist and you are done.

关于如何移动系统分区
====================

尤其最后一篇:
    https://help.ubuntu.com/community/MovingLinuxPartition
    https://help.ubuntu.com/community/Partitioning/Home/Moving
    http://blog.oaktreepeak.com/2012/03/move_your_linux_installation_t.html
    http://askubuntu.com/questions/40372/how-to-move-ubuntu-to-an-ssd

Nvidia Driver
=============

If you're using nvidia's drivers then you need to use the nvidia-settings tool,
not the system display setting tool.
    $ gksu nvidia-settings
Removing ~/.config/monitors.xml if encounted this warning:
could not apply the stored configuration for monitors nvidia 

nvidia ubuntu官方源驱动
-----------------------

$ sudo apt-get install nvidia-current nvidia-settings

nvidia官网驱动
--------------

卸载Nvidia驱动:
$ sh /path/to/NVIDIA-Linux-x86_64-xxx.xx.run --uninstall
or
$ nvidia-installer --uninstall # if you no longer have the .run file

ATI Driver
==========

https://wiki.ubuntu.com/X/Troubleshooting/VideoDriverDetection
http://askubuntu.com/questions/74171/is-my-ati-graphics-card-supported-in-ubuntu
http://askubuntu.com/questions/124292/what-is-the-correct-way-to-install-ati-catalyst-video-drivers
如果安装了系统推荐的ATI私有驱动，可用以下方法移除：
    $ sudo sh /usr/share/ati/fglrx-uninstall.sh
    $ sudo apt-get remove --purge fglrx* xorg-driver-fglrx
    $ sudo apt-get install --reinstall xserver-xorg-core libgl1-mesa-glx libgl1-mesa-dri
    $ sudo dpkg-reconfigure xserver-xorg

安装ATI官方下载的驱动：
    $ chmod +x amd-driver-installer-12-2-x86.x86_64.run
    $ sh ./amd-driver-installer-12-2-x86.x86_64.run
    $ sudo aticonfig --initial

$ sudo apt-get install gnome-tweak-tool
$ sudo apt-get install nautilus-open-terminal
$ sudo apt-get install vlc ubuntu-restricted-extras flashplugin-installer

ubuntu 12.04 安装 gimp 2.8.2
    $ sudo add-apt-repository ppa:otto-kesselgulasch/gimp
    $ sudo apt-get update
    $ sudo apt-get install gimp gimp-plugin-registry

软件中心打不开，可以试试。之后登出再登入：
    $ rm -rf ~/.config/software-center ~/.cache/software-center

修改grub开机等待时间和默认启动系统

1.  编辑/etc/default/grub：
    GRUB_TIMEOUT=3 # 等号后面为秒数
    GRUB_DEFAULT=4 # 如果要默认启动的win7是第5项，麻烦的是kernel更新后这个也要更新

2.  保存文件退出，执行：
    $ sudo update-grub

为stardict安装词典：
下载你喜欢的词典后把它解压到 ~/.stardict/dic 或 /usr/share/stardict/dic
现在以安装文件名为a.tar.bz2的词典为例：
    $ tar -xjvf a.tar.bz2 
    $ sudo cp -r a /usr/share/stardict/dic 
