<xsl:transform version="3.0" xpath-default-namespace="http://www.openarchives.org/OAI/2.0/"
               xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:mode on-no-match="shallow-copy"/>

  <xsl:template match="Records">
    <xsl:copy>
      <xsl:for-each-group select="record" group-by="header/identifier">
        <xsl:variable name="current-group" as="element(record)*">
          <xsl:perform-sort select="current-group()">
            <xsl:sort select="header/datestamp" order="descending"/>
          </xsl:perform-sort>
        </xsl:variable>
        <xsl:sequence select="$current-group[1]"/>
      </xsl:for-each-group>
    </xsl:copy>
  </xsl:template>

</xsl:transform>
