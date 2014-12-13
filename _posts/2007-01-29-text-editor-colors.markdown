---
author: jbryan
comments: true
date: 2007-01-29 00:39:21+00:00
layout: post
slug: text-editor-colors
title: Text editor colors
wordpress_id: 50
categories:
- Software
---

If you are like me, you probably spend 8 or more hours a day staring at a computer screen.  The vast majority of the time I spend looking at a text editor (or IDE).  However, most editors default to hard to look at black text on white background.  I suppose this is because it looks more like ink on paper, but what you end up with is a bright (expecially with today's high contrast LCD's) white light with dark spots to identify the areas of interest.  I have for a long time used Konsole's 'Linux - Colors' schema to provide my favorite black on white look for console and vim editing.  Recently I have been using KDevelop a lot, but Kate has no default white on black color scheme.  So, I have created one and attached the files [~/.kde/share/config/katesyntaxhighlightingrc](/files/katesyntaxhighlightingrc.txt) and [~/.kde/share/config/kateschemarc](/files/kateschemarc.txt).  If you copy the first to ~/.kde/share/config/katesyntaxhighlightingrc and the second to ~/.kde/share/config/kateschemarc , then you should be able to select the 'kdevelop - black' schema from the Settings->Configure Editor...->Fonts & Colors dialog in kdevelop.  Hopefully, I will set up something similar in eclipse soon.




