---
author: jbryan
comments: false
date: 2005-12-04 06:57:25+00:00
layout: page
title: Archive
---

{% for post in site.posts %}
  * {{ post.date | date_to_string }} &raquo; [ {{ post.title }} ]({{ post.url }})
{% endfor %}
