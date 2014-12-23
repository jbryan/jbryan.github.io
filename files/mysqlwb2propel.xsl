<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
	xmlns:str="http://exslt.org/strings"
  extension-element-prefixes="str"
	exclude-result-prefixes="str">
<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
<xsl:strip-space elements="*"/>

<!--
DB Designer XML to Propel Schema XML

==== Author: Jonathan Graham <jkgraham@gmail.com>
==== Author: Josh Bryan <josh.bryan@gmail.com>
==== Version: 0.1 (2004-11-08) (http://www.tooleshed.com/propel)
==== Description:
This XSL will transform a DB Designer 4 database model XML file into a
Propel database schema file.  This allows you to design your database
model using DB Designer 4 (models are saved in XML format) and then 
easily create the Propel database schema file.

The PROPEL properties that this XSL will translate are listed below.  Properties
in parens have yet to be added, but I'm working on them.

TABLE: name, description
COLUMN: name, primaryKey, required, type, size, scale, default, autoIncrement, description
FORIEGN-KEY: foreignTable, name, (onDelete)
REFERENCE: local, foriegn

Still working on the INDEX and UNIQUE tags.

==== Usage:
- Change [DATABASE NAME HERE] to the name of your database.
- Simply feed this XSL into your favorite XSLT engine along with your DB Designer
XML model.  The resulting output is a Propel database schema XML.

==== Software:
Propel: http://propel.phpdb.org/
DB Designer 4: http://www.fabforce.net/dbdesigner4/

==== Copyright (c) 2004, Jonathan Graham
Licensed under the GNU General Public License (GPL) - http://www.gnu.org/copyleft/gpl.html.

-->

<!-- ============================================================ DATABASE template -->
<xsl:template match="/">
	<database name="propel" defaultIdMethod="native">
		<xsl:apply-templates select="/data/value/value/value/value[@struct-name='db.mysql.Schema']/value/value[@struct-name='db.mysql.Table']" />
	</database>
</xsl:template>

<!-- ============================================================ TABLES template -->
<xsl:template match="/data/value/value/value/value[@struct-name='db.mysql.Schema']/value/value[@struct-name='db.mysql.Table']">
	<table>
		<xsl:attribute name="name">
			<xsl:value-of select="value[@key='name']"/>
		</xsl:attribute>
		<xsl:if test="@Comments != ''">
			<xsl:attribute name="description">
				<xsl:value-of select="@Comments" />
			</xsl:attribute>
		</xsl:if>
		<xsl:apply-templates select="value/value[@struct-name='db.mysql.Column']"/>
		<xsl:apply-templates select="value/value[@struct-name='db.mysql.ForeignKey']"/>
	</table>
</xsl:template>


<!-- ============================================================ COLUMNS template -->
<xsl:template match="value/value[@struct-name='db.mysql.Column']">
	<column>
		<!-- get data type -->
		<xsl:variable name="datatype">
			<xsl:call-template name="get_datatype">
				<xsl:with-param name="type"><xsl:value-of select="value[@key='datatypeName']"/></xsl:with-param>
			</xsl:call-template>
		</xsl:variable>
		
		<!-- remove parens from datatypeparams -->
		<xsl:variable name="dtpclean">
			<xsl:call-template name="clean_dataparams">
				<xsl:with-param name="dtp"><xsl:value-of select="value[@key='datatypeExplicitParams']"/></xsl:with-param>
			</xsl:call-template>
		</xsl:variable>
		
		<!-- ==== name ==== -->
		<xsl:attribute name="name">
			<xsl:value-of select="value[@key='name']"/>
		</xsl:attribute>
		
		<!-- ==== type ==== -->
		<xsl:attribute name="type">
			<xsl:value-of select="$datatype"/>
		</xsl:attribute>
		
		
		
		<xsl:if test="$dtpclean != '' and value[@key='datatypeName'] != 'ENUM'">
			<!-- ==== size ==== --> 
			<xsl:attribute name="size">
				<xsl:call-template name="get_datasize">
					<xsl:with-param name="dtpc"><xsl:value-of select="$dtpclean"/></xsl:with-param>
					<xsl:with-param name="dtype"><xsl:value-of select="$datatype"/></xsl:with-param>
				</xsl:call-template>
			</xsl:attribute>
		
			<xsl:if test="contains('FLOAT,DOUBLE',$datatype)">
				<!-- ==== scale ==== --> 
				<xsl:attribute name="scale">
					<xsl:value-of select="substring-after($dtpclean,',')"/>
				</xsl:attribute>
			</xsl:if>
			
		</xsl:if>
				
		<!-- ==== primaryKey ==== -->
		<xsl:call-template name="is_primary">
			<xsl:with-param name="name"><xsl:value-of select="value[@key='name']" /></xsl:with-param>
		</xsl:call-template>
		
		
		<!-- ==== required ==== -->
		<xsl:if test="value[@key='isNullable'] = '0'">
			<xsl:attribute name="required">true</xsl:attribute>
		</xsl:if>

		<!-- ==== default ==== -->
		<xsl:if test="value[@key='defaultValue'] != ''">
			<xsl:attribute name="default">
				<xsl:value-of select="@DefaultValue"/>
			</xsl:attribute>
		</xsl:if>
		
		<!-- ==== autoIncrement ==== -->
		<xsl:if test="value[@key='autoIncrement'] = '1'">
			<xsl:attribute name="autoIncrement">true</xsl:attribute>
		</xsl:if>

		<!-- ==== description ==== -->
		<xsl:if test="value[@key='comment'] != ''">
			<xsl:attribute name="description">
				<xsl:value-of select="value[@key='comment']"/>
			</xsl:attribute>
		</xsl:if>
		
		
	</column>
</xsl:template>

<!-- ============================================================ RELATIONS template -->
<xsl:template match="value/value[@struct-name='db.mysql.ForeignKey']">
	<foreign-key>
		<!-- name -->
		<xsl:attribute name="name">
			<xsl:value-of select="value[@key='name']"/>
		</xsl:attribute>
		
		<xsl:param name="foreignId">
			<xsl:value-of select="value[@key='referedTable']" />
		</xsl:param>
		
		
		<xsl:param name="foreignTable" select="/data/value/value/value/value[@struct-name='db.mysql.Schema']/value/value[@struct-name='db.mysql.Table'][value=$foreignId]/value[@key='name']" />
		
		<xsl:attribute name="foreignTable">
				<xsl:value-of select="$foreignTable"/>
		</xsl:attribute>
		
		<!-- OnDelete -->
		<!--
		
		<xsl:variable name="refdef">
			<xsl:call-template name="str_replace">
				<xsl:with-param name="stringIn" select="$relation/@RefDef"/>
				<xsl:with-param name="charsIn" select="'\n'"/>
				<xsl:with-param name="charsOut" select="'|'"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:for-each select="str:tokenize($refdef, '|')">
			<xsl:if test="substring-before(., '=') = 'OnDelete'">
				<xsl:if test="substring-after(., '=') = '1'">
					<xsl:attribute name="onDelete">cascade</xsl:attribute>
				</xsl:if>	
			</xsl:if>	
		</xsl:for-each>
		
		
		-->
		
		<xsl:param name="refs" select="value[@content-struct-name='db.Column'][@key='referedColumns']/value" />
			
		
		<!-- === reference tag === -->
		<xsl:for-each select="value[@content-struct-name='db.Column'][@key='columns']/value">
			<xsl:param name="localColumnid">
				<xsl:value-of select="." />
			</xsl:param>
			<xsl:param name="foreignColumnid">
				<xsl:value-of select="$refs[position()=position()]" />
			</xsl:param>
			
			<reference>  
				<xsl:attribute name="local">
					<xsl:call-template name="show_ForeignKey">
						<xsl:with-param name="id" select="$localColumnid"/>
					</xsl:call-template>
				</xsl:attribute>
	
				<xsl:attribute name="foreign">
					<xsl:call-template name="show_ForeignKey">
						<xsl:with-param name="id" select="$foreignColumnid"/>
					</xsl:call-template>
				</xsl:attribute>
			</reference>
		</xsl:for-each>
		
	</foreign-key>
</xsl:template>


<!-- ============================================================ show_ForeignKey -->	
<xsl:template name="show_ForeignKey">
	<xsl:param name="id"/>
	<xsl:value-of select="/data/value/value/value/value[@struct-name='db.mysql.Schema']/value/value[@struct-name='db.mysql.Table']/value/value[@struct-name='db.mysql.Column'][value[@key='_id']=$id]/value[@key='name']" />
</xsl:template>

<!--
============================================================
============================================================ template "functions"
============================================================
-->

<!-- ============================================================ get_datatype -->
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


<!-- ============================================================ get_datasize -->
<xsl:template name="get_datasize">
	<xsl:param name="dtpc"/>
	<xsl:param name="dtype"/>

	<xsl:choose> 
		<xsl:when test="contains('FLOAT,DOUBLE',$dtype)" > 
			<xsl:value-of select="substring-before($dtpc,',')"/>
		</xsl:when>
		<xsl:otherwise> 
			<xsl:value-of select="$dtpc"/>
		</xsl:otherwise> 
	</xsl:choose> 
	
</xsl:template>

<!-- ============================================================ is_primary -->
<xsl:template name="is_primary">
	<xsl:param name="name"/>
	
	
	<xsl:for-each select="./../../value/value[@struct-name='db.mysql.Index']">
		<xsl:if test="./value/value[@struct-name='db.mysql.IndexColumn']/value[@key='name'] = $name ">
			<xsl:if test="./value[@key='isPrimary'] = '1'">
				<xsl:attribute name="primaryKey">true</xsl:attribute>
			</xsl:if>	
		</xsl:if>
	</xsl:for-each>
	
</xsl:template>

<!-- ============================================================ clean_dataparams -->
<xsl:template name="clean_dataparams">
	<xsl:param name="dtp"/>

	<xsl:variable name="dtp2">
		<xsl:call-template name="str_replace">
			<xsl:with-param name="stringIn" select="$dtp"/>
			<xsl:with-param name="charsIn" select="'('"/>
			<xsl:with-param name="charsOut" select="''"/>
		</xsl:call-template>
	</xsl:variable>

	<xsl:call-template name="str_replace">
		<xsl:with-param name="stringIn" select="$dtp2"/>
		<xsl:with-param name="charsIn" select="')'"/>
		<xsl:with-param name="charsOut" select="''"/>
	</xsl:call-template>
	
</xsl:template>


<!-- ============================================================ str_replace -->
<xsl:template name="str_replace">
  <xsl:param name="stringIn"/>
  <xsl:param name="charsIn"/>
  <xsl:param name="charsOut"/>
  <xsl:choose>
    <xsl:when test="contains($stringIn,$charsIn)">
      <xsl:value-of select="concat(substring-before($stringIn,$charsIn),$charsOut)"/>
      <xsl:call-template name="str_replace">
        <xsl:with-param name="stringIn" select="substring-after($stringIn,$charsIn)"/>
        <xsl:with-param name="charsIn" select="$charsIn"/>
        <xsl:with-param name="charsOut" select="$charsOut"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$stringIn"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


</xsl:stylesheet>
