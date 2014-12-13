---
author: jbryan
comments: true
date: 2009-12-15 20:18:18+00:00
layout: post
slug: fuse-python-lego-nxt
title: Fuse + Python + Lego NXT
wordpress_id: 73
categories:
- Projects
- Software
tags:
- fuse
- lego
- NXT
- opensource
---

I've been recently playing with my new [Lego NXT](http://mindstorms.lego.com/en-us/Default.aspx) robotics kit.  Being a Linux nerd, I naturally wanted to do the programming on Linux using languages I like.  To this end, I've been using the [nxt-python](http://code.google.com/p/nxt-python/) project and [NXC](http://bricxcc.sourceforge.net/nbc/).  However, I found the nxt-push script a little cumbersome and not very user friendly, and the nxt-filer gui was less than useful.  I didn't want to develop a complete file manager interface.  After all, file managers have been redesigned and reimplemented a million different ways.  All I really needed was a file interface to the NXT.  Enter [Fuse](http://fuse.sourceforge.net/).  So, I spent some time yesterday and developed a [Fuse interface for the NXT](http://github.com/jbryan/nxt-tools) using nxt-python and fuse python bindings.  You can find the interface in, what will be, a collection of tools for manipulating and controlling the NXT brick on GitHub.
