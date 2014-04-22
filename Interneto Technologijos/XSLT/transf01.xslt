<?xml version="1.0" encoding="UTF-8"?> 
<xsl:stylesheet version='1.0' xmlns:xsl='http://www.w3.org/1999/XSL/Transform'> 

<xsl:output method="html" doctype-system="about:legacy-compat" encoding="UTF-8" /> 

 
 <xsl:template match="/"> 
 <html>
 <h1> 
 <xsl:value-of select="//pavadinimas"/> 
 </h1> 
 <h2> 
 <xsl:value-of select="//autorius"/> 
 </h2> 
 </html>
 </xsl:template> 
</xsl:stylesheet> 
