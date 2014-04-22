<?xml version="1.0" encoding="UTF-8"?> 
<xsl:stylesheet version='1.0' xmlns:xsl='http://www.w3.org/1999/XSL/Transform'> 

<xsl:output method="html" doctype-system="about:legacy-compat" encoding="UTF-8" /> 

	<xsl:template match="/"> 
		<html>
		<body>
			<xsl:apply-templates/>
			<h2>Daiktai:</h2>
			<xsl:for-each select="spinta/laikmena/daiktas | spinta/laikmena/laikmena/daiktas">
				<xsl:sort select="savininkas"/> 
				<h3> <xsl:number value="position()" format="I. "/> <xsl:value-of select="pavadinimas"/> </h3>
				<xsl:apply-templates select="parent::*/attribute::pavadinimas"/>
			</xsl:for-each> 
		</body>
		</html>
	</xsl:template> 
	
	<xsl:template match="spinta">
		<h2> <xsl:if test="count(daiktasIšmetimui) > 0">Spintoje yra daiktų, kuriuos reikia išmesti</xsl:if> </h2>
	</xsl:template>
	
	<xsl:template match="@pavadinimas">
	<p> Daiktas, kuris yra laikmenoje: <xsl:value-of select="."/> </p>
	</xsl:template>
	
</xsl:stylesheet> 