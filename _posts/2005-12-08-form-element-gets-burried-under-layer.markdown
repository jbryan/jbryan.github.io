---
author: jbryan
comments: true
date: 2005-12-08 03:16:59+00:00
excerpt: A project called DomMenu developed a simple, css styled javascript dhtml
  menu library.
layout: post
slug: form-element-gets-burried-under-layer
title: Form element gets burried under layer...
wordpress_id: 15
categories:
- Reviews
- Software
---


One of my favorite quirks MS Internet Explorer has is its ignorance of z-index when form elements are involved. The problem occurs when an absolutely positioned block elements overlaps a select box. Even though the element may be set to to top layer through the z-index, it is displayed behind the select box. The result is that most dhtml menus can't overlap form elements. Yeah, this is not a new issue, and to be fair, it is not limited to IE, older Netscape and Mozilla browsers had issues too.

I am familiar with most of the usually hacks to fix this; put the form in an i-frame, use javascript calls to hide the offending form element, etc. However, i hadn't seen a neatly packaged general solution until recently. A project called [DomMenu](http://www.mojavelinux.com/projects/dommenu/) developed a simple, css styled javascript dhtml menu library. That in itself isn't so novel, but the cool part about it is the built in collision detection. You don't have to worry about defining ids and writing hiding functions, it finds the offending elements and hides them as necessary. I also noticed that it was first published in 2002 ... guess I'm a little late on the scene.   

