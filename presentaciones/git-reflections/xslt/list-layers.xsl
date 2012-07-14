<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:svg="http://www.w3.org/2000/svg"
                xmlns:inkscape="http://www.inkscape.org/namespaces/inkscape"
                version="1.0">

  <xsl:output method="text"/>

  <xsl:variable name="nl"><![CDATA[.
]]></xsl:variable>

  <xsl:template match="*">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="svg:g[@inkscape:groupmode='layer']">
    <xsl:value-of select="concat('Found layer ', @inkscape:label, $nl)"/>
  </xsl:template>

  <xsl:template match="text()"/>
</xsl:stylesheet>