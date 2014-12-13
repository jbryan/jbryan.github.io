---
author: jbryan
comments: true
date: 2005-12-09 23:24:40+00:00
excerpt: form.submit is not a function
layout: post
slug: javascript-form-error
title: Javascript form error...
wordpress_id: 19
categories:
- Coding
---

I was recently working on a project where I had written some javascript code to manipulate and submit a form. It called the standard javascript form.onsubmit() function. It worked just fine on my test pages but when I paired it with the code the html designer had created. 

Suddently, I kept getting this error: "form.submit is not a function". Now, I've been coding long enough to know that every form has a submit function. So, what could have gone wrong? It took me a while but I soon realized that the html designer had named the submit button 'submit'. This overwrote the submit function and made submit an element instead.

The moral of the story: Never name form elements (or really any element for that matter) a javascript keyword, its just asking for trouble.  

