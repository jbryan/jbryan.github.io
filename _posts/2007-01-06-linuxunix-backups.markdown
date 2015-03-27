---
author: jbryan
comments: true
date: 2007-01-06 07:19:01+00:00
layout: post
published: true
slug: linuxunix-backups
title: Linux/Unix Backups
wordpress_id: 45
categories:
- Coding
- Software
---

It seems that every one I talk to about backups on \*nix has their own method
of doing things.  Some people use a ["Towers of Hanoi"
algorithm](http://en.wikipedia.org/wiki/Backup_rotation_scheme#Tower_of_Hanoi)
to do level based backups using **dump** to tape drives.  Some people use a
clever scheme using rsync to create a [snapshot
backup](http://edseek.com/~jasonb/articles/dirvish_backup/snapshot.html).
Still others use proprietary services to dump their data to multiple physical
locations around the world.  The bottom line when it comes to choosing a system
is a combination of the bottom line (how much it costs) and how valuable your
data is.

My personal backup choice is a practical application of GNU tar's listed
incremental backup plan.  It is fairly simple and can be easily configured for
any number of directories or filesystems.  This is a conglomeration of about
ten different scripts I found or friends have pointed be to.  This is by no
means the end all of backups, but it is what I use; I just stick it in
/etc/cron.daily, and let it run.  It keeps 3 (or however many you configure)
weeks of incremental backups with a full backup each week.  It uses gz
compression to save space.  it is simple, short and sweet.

I am always open for comment.  What do you use?  Why is it better (or worse)?



<pre>
<span style="font-style: italic; color: #808080">#!/bin/bash</span>
<span style="font-style: italic; color: #808080"># incremental backups</span>
<span style="font-style: italic; color: #808080"># Created by Josh Bryan 2006-09-25</span>

<span style="font-style: italic; color: #808080">#CONFIGURATION#</span>

<span style="color: #008000">MACHINE=</span><span style="">Pavillion_a1540n                                    </span><span style="font-style: italic; color: #808080"># name of this computer</span>
<span style="color: #008000">DIRECTORIES=</span><span style="color: #dd0000">"/home /root /etc /var"</span><span style="">        </span><span style="font-style: italic; color: #808080"># directoris to backup</span>
<span style="color: #008000">BACKUPDIR=</span><span style="color: #dd0000">"/path/to/backup"</span><span style="">       </span><span style="font-style: italic; color: #808080"># where to store the backups</span>
<span style="color: #008000">TAR=</span><span style="">/bin/tar                                                 </span><span style="font-style: italic; color: #808080"># name and locaction of tar</span>
<span style="color: #008000">NUM_WEEKS=</span><span style="">3</span>

<span style="font-style: italic; color: #808080">#END CONFIGURATION#</span>

<span style="color: #008000">DOW=</span><span style="font-weight: bold; ">`</span><span style="font-weight: bold; color: #cc00cc">date</span><span style=""> +%a</span><span style="font-weight: bold; ">`</span><span style="">                          </span><span style="font-style: italic; color: #808080"># Day of the week e.g. Mon</span>

<span style="font-style: italic; color: #808080">#The list used to keep track of this weeks backups</span>
<span style="color: #008000">LIST=</span><span style="color: #dd0000">"</span><span style="color: #008000">$BACKUPDIR</span><span style="color: #dd0000">/1-weeks_ago/</span><span style="color: #008000">$MACHINE</span><span style="color: #dd0000">.list"</span>

<span style="font-style: italic; color: #808080"># Move Last Weeks Backups for archive</span>
<span style="font-weight: bold; ">if</span><span style="font-weight: bold; color: #880088"> [</span><span style=""> </span><span style="color: #008000">$DOW</span><span style=""> = </span><span style="color: #dd0000">"Sun"</span><span style=""> -a -f </span><span style="color: #dd0000">"</span><span style="color: #008000">$LIST</span><span style="color: #dd0000">"</span><span style="font-weight: bold; color: #880088"> ]</span><span style="">; </span><span style="font-weight: bold; ">then</span>
<span style="">	</span><span style="font-weight: bold; color: #cc00cc">mkdir</span><span style=""> -p </span><span style="color: #008000">$BACKUPDIR</span><span style="">/</span><span style="color: #008000">$NUM_WEEKS</span><span style="">-weeks_ago</span>
<span style="">	</span><span style="font-weight: bold; color: #cc00cc">rm</span><span style=""> </span><span style="color: #008000">$BACKUPDIR</span><span style="">/</span><span style="color: #008000">$NUM_WEEKS</span><span style="">-weeks_ago/\*</span>
<span style="">	</span><span style="font-weight: bold; ">while</span><span style="font-weight: bold; color: #880088"> [</span><span style=""> </span><span style="color: #dd0000">"</span><span style="color: #008000">$NUM_WEEKS</span><span style="color: #dd0000">"</span><span style=""> -gt </span><span style="color: #dd0000">"1"</span><span style="font-weight: bold; color: #880088"> ]</span><span style="">; </span><span style="font-weight: bold; ">do</span>
<span style="">	  </span><span style="color: #008000">OLD_NUM=$NUM_WEEKS</span>
<span style="">		</span><span style="color: #008000">NUM_WEEKS=$(($NUM_WEEKS</span><span style=""> - 1</span><span style="color: #008000">))</span>
<span style="">		</span><span style="font-weight: bold; color: #cc00cc">mkdir</span><span style=""> -p </span><span style="color: #008000">$BACKUPDIR</span><span style="">/</span><span style="color: #008000">$NUM_WEEKS</span><span style="">-weeks_ago</span>
<span style="">		</span><span style="font-weight: bold; color: #cc00cc">mv</span><span style=""> </span><span style="color: #008000">$BACKUPDIR</span><span style="">/</span><span style="color: #008000">$NUM_WEEKS</span><span style="">-weeks_ago/\* </span><span style="color: #008000">$BACKUPDIR</span><span style="">/</span><span style="color: #008000">$OLD_NUM</span><span style="">-weeks_ago/</span>
<span style="">	</span><span style="font-weight: bold; ">done</span>
<span style="font-weight: bold; ">fi</span>

<span style="font-style: italic; color: #808080"># Make incremental backup in 1-weeks_ago</span>

<span style="color: #008000">$TAR</span><span style=""> --listed-incremental </span><span style="color: #008000">$LIST</span><span style=""> -czf </span><span style="color: #008000">$BACKUPDIR</span><span style="">/1-weeks_ago/INC-</span><span style="color: #008000">$MACHINE</span><span style="">-</span><span style="color: #008000">$DOW</span><span style="">.tar.gz </span><span style="color: #008000">$DIRECTORIES</span>
</pre>
