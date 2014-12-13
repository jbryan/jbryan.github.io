---
author: jbryan
comments: true
date: 2009-11-14 19:50:30+00:00
layout: post
slug: git-my-favorite-vcs
title: Git ... my favorite vcs
wordpress_id: 72
categories:
- Favorite Tools
---

After having used CVS, Subversion, and Perforce, I've recently been using [Git](http://git-scm.com) for all of my version control.  The two things I like about above the others mentioned are its speed and trivial and intuitive branching.  Though I can't say I was ever a fan of CVS branches, I always found that the subversion/perforce approach of just creating another directory when you want to branch to somewhat ignore the semantics of being a branch.  Why shouldn't every version be a new directory?  Obviously that would get cluttered and confusing.  Why would you not expect the same of branches?  Yes, I understand that directory copying is cheap in Subversion and Perforce, and I understand they do preserve history, but I expect branches to split and merge and though directories do represent the splitting very well, they unfortunately don't represent the concept of a merge very well.  Git on the otherhand, has explicit branches that are separate from the concept of a directory.  Plus, it has many powerful tools for managing those branches, not to mention [GitHub](http://github.com).

