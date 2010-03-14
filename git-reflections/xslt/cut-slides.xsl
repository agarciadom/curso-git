<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:svg="http://www.w3.org/2000/svg"
                xmlns:inkscape="http://www.inkscape.org/namespaces/inkscape"
                xmlns:dyn="http://exslt.org/dynamic"
                version="1.0">

  <!--
      SYNOPSIS: cuts selected layers (slides) from a svg file

      USAGE:

      1. Configure the XSLT script by changing the values of the variables in
         the CONFIGURATION section.

      2. Run "xsltproc cut-slides.xsl (svg file) > (cut svg file)"

      3. Open in Inkscape, hide and show a layer and save. Otherwise, negative
         won't pick up the slides: it uses regular expressions for parsing rather
         than a full fledged XML parser.

      xsltproc is packaged in most distributions. In Debian and Ubuntu, you only
      need to install the xsltproc package.

      Copyright (C) 2010 Antonio García-Domínguez <antonio.garciadominguez@uca.es>
      Available under the terms of the GPLv3 license.
  -->

  <!-- CONFIGURATION -->

  <!-- If set to 1, it will do a dry-run: only print what will be kept and what will be cut. -->
  <xsl:variable name="dryrun" select="0"/>

  <!-- Condition for deciding whether to keep (true result) or not (false
       result) a layer. The context node will be the svg:g element containing
       the layer, and $label will have the Inkscape layer name assigned to
       it. -->
  <xsl:variable name="condition_keep">
    starts-with($label, 'conc.') or starts-with($label, '#conc.') or
    $label='#conc' or (starts-with($label, 'dcnt') and not(starts-with($label,
    'dcnt_Top')) and not(starts-with($label, 'dcnt_top'))) or
    (starts-with($label, '#dcnt') and not(starts-with($label, '#dcnt_top'))) or
    starts-with($label, 'Decent') or starts-with($label, 'cent.') or
    starts-with($label, '#cent') or starts-with($label, 'Centr')
  </xsl:variable>

  <!-- MAIN BODY -->

  <xsl:output method="xml" encoding="utf-8"/>

  <xsl:variable name="nl">.
</xsl:variable>
  <xsl:variable name="quote">'</xsl:variable>

  <xsl:template match="node()">
    <xsl:choose>
      <xsl:when test="$dryrun = 1">
        <xsl:apply-templates/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy>
          <xsl:copy-of select="@*"/>
          <xsl:apply-templates select="node()"/>
        </xsl:copy>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="svg:g[@inkscape:groupmode='layer']">
    <xsl:variable name="label" select="@inkscape:label"/>
    <xsl:choose>
      <xsl:when test="dyn:evaluate($condition_keep)">
        <xsl:choose>
          <xsl:when test="$dryrun = 1">
            <xsl:value-of select="concat('Would keep ', $quote, $label, $quote, $nl)"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:copy>
              <xsl:copy-of select="@*"/>
              <xsl:apply-templates select="@*|node()"/>
            </xsl:copy>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise><xsl:if test="$dryrun = 1"><xsl:value-of select="concat('Would cut ', $quote, $label, $quote, $nl)"/></xsl:if></xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="text()"><xsl:if test="$dryrun != 1"><xsl:value-of select="."/></xsl:if></xsl:template>
</xsl:stylesheet>
