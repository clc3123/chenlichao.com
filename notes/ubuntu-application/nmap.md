---
layout: post
title: nmap
description: nmap
---

nmap基本命令和典型用法
======================

全面进攻性扫描（包括各种主机发现、端口扫描、版本扫描、OS扫描及默认脚本扫描）:
    nmap -A -v targetip
Ping扫描:
    nmap -sn -v targetip
快速端口扫描:
    nmap -F -v targetip
版本扫描:
    nmap -sV -v targetip 
操作系统扫描:
    nmap -O -v targetip

Nmap核心功能
============

主机发现（Host Discovery）
端口扫描（Port Scanning）
版本侦测（Version Detection）
操作系统侦测（OS detection）
防火墙/IDS规避（Firewall/IDS evasion）
NSE脚本引擎（nmap Scripting Engine）
