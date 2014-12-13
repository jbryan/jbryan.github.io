---
author: jbryan
comments: true
date: 2007-01-26 01:01:21+00:00
layout: post
published: true
slug: mysql-workbench-to-propel-schema
title: Mysql Workbench to Propel Schema
wordpress_id: 48
categories:
- Projects
- Software
---

As part of a recent project, I modified the [DBDesigner 2 Propel XSL](http://blog.tooleshed.com/?p=6) to convert MySQL Workbench \*.mwb files to [Propel ](http://propel.phpdb.org) schema.  It has not been thoroughly tested, but this rough draft has been tested against my project using MySQL Workbench 1.1.4alpha on x86_64.  If you have questions, please feel free to ask. 

\*UPDATE:

Kerry (hemisphere) fixed some issues with this and tried to post them in the comment below.  Unfortunately, tags got stripped out, so I am posting his edits here:

There are two occurences of db.Column that should be
db.mysql.Column and cause the foreign key references not to come out.

This 

    <!-- ==== default ==== -->
    <xsl:if test="value[@key='defaultValue'] != ''">
    <xsl:attribute name="default">
    <xsl:value-of select="@DefaultValue"/>
    </xsl:attribute>
    </xsl:if>

should be

    <!-- ==== default ==== -->
    <xsl:if test="value[@key='defaultValue'] != ''">
    <xsl:attribute name="default">
    <xsl:value-of select="value[@key='defaultValue']"/>
    </xsl:attribute>
    </xsl:if>

I added

    <xsl:when test="$type = 'INT'" >INTEGER</xsl:when>
    (from a MySQL db)
    to
    <!-- ============================================================
    get_datatype -->
    <xsl:template name="get_datatype">
    <xsl:param name="type"/>

    <xsl:choose>
    <xsl:when test="$type = 'DATETIME'" >TIMESTAMP</xsl:when>
    <xsl:when test="$type = 'TEXT'" >LONGVARCHAR</xsl:when>
    <xsl:when test="$type = 'BOOL'" >BOOLEAN</xsl:when>
    <xsl:when test="$type = 'ENUM'" >VARCHAR</xsl:when>
    <xsl:when test="$type = 'YEAR'" >INTEGER</xsl:when>
    <xsl:otherwise>
    <xsl:value-of select="$type"/>
    </xsl:otherwise>
    </xsl:choose>

    </xsl:template>

VARCHAR size missing

    <!-- ==== string length ==== -->
    <xsl:if test="value[@key='length'] != ''">
    <xsl:attribute name="size">
    <xsl:value-of select="value[@key='length']"/>
    </xsl:attribute>
    </xsl:if>

The new version can be downloaded here: [mysqlwb2propel.xsl](/files/mysqlwb2propel.xsl)
