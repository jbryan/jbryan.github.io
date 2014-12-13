---
author: jbryan
comments: true
date: 2008-09-05 20:00:58+00:00
layout: post
slug: colored-man-pages
title: Colored man pages
wordpress_id: 70
categories:
- Coding
- Software
---

I just discovered this very cool [tip](http://nion.modprobe.de/blog/archives/572-less-colors-for-man-pages.html).  If you want a colored man pages, adding the following to your environment does it:

`
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'
`

I found the tip while searching for a way to preserve the colored output of grep after it has been piped into less.  'less -r' preserves the terminal escape sequences from the input.  The following will get preserve the colors:

`
grep --color=always <search_term> | less -r
`



