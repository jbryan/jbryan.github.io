---
author: jbryan
comments: true
date: 2008-01-02 23:19:51+00:00
layout: post
slug: lvm2-mirrors-vs-md-raid-1
title: LVM2 Mirrors vs. MD Raid 1
wordpress_id: 64
categories:
- Projects
- Software
---

I recently added a new hard drive to my desktop and reorganized the partition structure.  In doing so I wanted my /home partition to be mirrored for safety, but I also wanted to use lvm to make managing my multiple partitions less painful.  In my research, I found there are basically two ways to do this.  One is to create a linux RAID1 device from the two drives and then use that device as a physical extent in a lvm volume group (here is a basic [tutorial](http://gentoo-wiki.com/HOWTO_Gentoo_Install_on_Software_RAID_mirror_and_LVM2_on_top_of_RAID)).  The other method is to us LVM2's mirroring capabilities.  I personally would rather use the latter solution if there is no performance impact since moving the partitions around later would be much easier, however what I read gave the impression that LVM2 mirroring would be slower. 

To test this, I setup a quick informal benchmark.  I created 2 partitions on each of two drives and set one up as plain raid1 (no lvm) and the other as lvm with a mirror.  I then ran [bonnie++](http://www.coker.com.au/bonnie++/) on each of the partitions.  The results were surprising.  MD RAID1 gave about 25MB/sec write and 50MB/sec read.  However LVM2 mirrored gave about 50MB/sec write and 55MB/sec read.  Since the test was not perfectly sterile (there were other processes running at the same time) I would be willing to give these number +/- 10MB/sec.  However still, LVM write was considerably faster than MD RAID1.  I so far have no explanation for this, but will test further.  If anyone has an explanation, I'd be happy to hear.


