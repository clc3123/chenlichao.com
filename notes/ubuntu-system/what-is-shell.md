---
layout: post
title: what-is-shell
description: what-is-shell
---

What is Shell?
==============

<http://en.wikipedia.org/wiki/Operating_system_shell>

An operating system shell is a software component that presents a user interface to various operating system functions and services. Thus, it is nearly synonymous with "operating system user interface".

Shells are actually special applications which *use the kernel API* in just the same way as it is used by other application programs.

The classical approach of multi-user mainframes is to provide text-based UI for each active user simultaneously by means of a text terminal connected to the mainframe via serial line or modem. This approach is now associated with Unix-like systems. Now, the Secure Shell protocol is used for a text-based UI, and for also GUI, if required, through SSH tunelling and X Window System networking capabilities.

A direct user–kernel dialogue is very uncommon, and only on *most primitive* devices is a shell program able to communicate with the user *without* the kernel API.

Many OS command-line shells actually became command language interpreters(like bash). This is the case, most notably, of numerous Unix shell variants.

The use of command-line within a text window controlled by a GUI window manager is, as of 2012, quite common, if not dominant.

As of 2012, it is common and perfectly normal that a desktop OS has both command-line and GUI shells (GUI environment). Also, GUI shells usually *incorporate* some features of the command-line interpreter, especially its *command language* .

Modern versions of Microsoft's Windows operating system utilize and only officially support Windows Explorer as their GUI shell.

Proponents of Unix-like systems often argue that the GUI under UNIX is separate from the OS itself, unlike Microsoft Windows or MacOS.

很好的文章： <http://en.wikipedia.org/wiki/Unix_shell>

A Unix shell is a command-line interpreter or shell that provides a traditional user interface for the Unix operating system and for Unix-like systems. Users direct the operation of the computer by entering commands *as text* for a command line interpreter to execute or by creating text scripts of one or more such commands.

Users typically interact with a modern Unix shell using a terminal emulator. Common terminals include xterm and GNOME Terminal.

A shell hides the details of the underlying operating system and manages the technical details of the operating system kernel interface, which is the lowest-level, or 'inner-most' component of most operating systems.

When a user logs in to the system, a shell program is automatically executed. The login shell may be customized for each user, typically in the passwd file, and can be customized via the chsh program.

The Unix shell was unusual when it was introduced. It is both an interactive command language as well as a *scripting programming language* , and is *used by the operating system* as the facility(shell script) to control the execution of the system. On Unix systems, the shell is still the implementation language of system startup scripts, including the program that starts the windowing system, the programs that facilitate access to the Internet, and many other essential functions.

Note that most OS shells in Microsoft Windows are not command-line interpreters.

+   The Bourne shell, sh, was written by Stephen Bourne at AT&T as the original Unix command line interpreter; it introduced the basic features common to all the Unix shells, including piping, here documents, command substitution, variables, control structures for condition-testing and looping and filename wildcarding. On many systems, however, /bin/sh may be a symbolic link or hard link to a compatible, but more feature-rich shell than the Bourne shell. From a user's perspective the Bourne shell was immediately recognized when active by its characteristic default command line prompt character, the dollar sign ($).

+   Z shell (zsh): A relatively modern shell that is backward compatible with bash.

+   pysh: A special profile of the IPython project, tries to integrate a heavily enhanced Python shell and system shell into a seamless experience.

+   Perl Shell (psh): A shell for Unix-like and Windows operating systems, combining aspects of bash (and other Unix shells) with the power of the Perl scripting language.

+   The C shell, csh, was written by Bill Joy while a graduate student at University of California, Berkeley. The most significant of new features introduced by csh includes the history and editing mechanisms, aliases, directory stacks, tilde notation, cdpath, job control and path hashing. Like all Unix shells, it supports filename wildcarding, piping, here documents, command substitution, variables and control structures for condition-testing and iteration. What differentiated the C shell from others, especially in the 1980s, were its interactive features and overall style. Its new features made it easier and faster to use. The overall style of the language looked more like C and was seen as more readable. It is used primarily for interactive terminal use, but less frequently for scripting and operating system control. Though popular for interactive use because of its many innovative features, csh has never been as popular for scripting. <http://en.wikipedia.org/wiki/C_shell>

