---
author: jbryan
comments: true
date: 2012-07-15 22:23:33+00:00
layout: post
slug: more-webgl-experiments
title: More WebGL Experiments
wordpress_id: 101
categories:
- Software
---

I just posted a new WebGL demo.  This is [GPGPU based particle demo](http://jbryan.github.com/webgl-experiments/gravity.html). Particles of "negligable" mass are spawned along the x axis with arbitrary velocities. There is an invisible mass in the center attracting all particles. Watch the system evolve the camera rotates around the system. All particle motions are computed on the GPU using textures to store velocity and position data.  You can read more about it on [GitHub](https://github.com/jbryan/webgl-experiments).
