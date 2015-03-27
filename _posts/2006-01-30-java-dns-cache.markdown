---
author: jbryan
comments: true
date: 2006-01-30 16:22:54+00:00
excerpt: It turns out that Sun's JRE has it's own dns cache that defaults to "cache
  forever."
layout: post
slug: java-dns-cache
title: Java DNS Cache
wordpress_id: 24
categories:
- Coding
- Software
---





In a recent project, I am using a java daemon to manage and pool connections to
an XML service I am using. If the connection fails, the daemon automatically
closes the socket and reconnects. This was working great until one day the IP
addresses for the service changed. Though TTL for the dns lookup had run out
and the local dns properly found the new IP's, the connection pool was still
not able to make connections until the JRE and daemon were restarted.

I thought this was really weird, and did some research. It turns out that Sun's
JRE has it's own dns cache that defaults to "cache forever." Though, I think
this is a really bad default behavior, they do provide a way to fix it. It
turns out there are some properties that can be set on the command line to
change it as documented in their [Networking
Properties](https://docs.oracle.com/javase/1.4.2/docs/api/)
manual. If you pass a **-Dsun.net.inetaddr.ttl **to the JRE commandline with
the number of seconds to cache, that should fix it. Sun's argument for having
this default value is to hedge against DNS spoofing attacks, but if you
consider your dns to be relatively secure, it can be just an annoyance.  

