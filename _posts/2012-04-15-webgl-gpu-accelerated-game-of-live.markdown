---
author: jbryan
comments: true
date: 2012-04-15 02:52:04+00:00
layout: post
slug: webgl-gpu-accelerated-game-of-live
title: WebGL GPU Accelerated Game of Life
wordpress_id: 77
categories:
- Software
tags:
- project
- WebGL
---

I've been playing with [WebGL](http://www.khronos.org/webgl/) recently and have been putting together some toy projects.  Recently I created a GPU accelerated version of [Conway's Game of Life](http://en.wikipedia.org/wiki/Conway's_Game_of_Life).  If you have [Google Chrome](https://www.google.com/chrome) or the open source [Chromium browser](http://www.chromium.org/Home), you can view it on [my WebGL Github page](http://jbryan.github.com/webgl-experiments/life.html).  You will need to have a reasonable graphics card as it renders 3 parallel Games of Life on a 4096x2048 grid with a 3d torus topology.  You can zoom in with the scroll wheel to see more detail.  Each color (red, green, blue) is a separate game of life.  You can also activate blocks of cells by clicking with the mouse.  Its mesmerizing fun for hours! 
