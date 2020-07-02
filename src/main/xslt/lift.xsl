<xsl:transform version="3.0"
               expand-text="yes" exclude-result-prefixes="#all"
               xmlns:datacite-4="http://datacite.org/schema/kernel-4"
               xmlns:dc="http://purl.org/dc/elements/1.1/"
               xmlns:dct="http://purl.org/dc/terms/"
               xmlns:library="tag:david.maus@sub.uni-hamburg.de,2020:Transform:Library"
               xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
               xmlns:skos="http://www.w3.org/2004/02/skos/core#"
               xmlns:xs="http://www.w3.org/2001/XMLSchema"
               xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output indent="yes"/>

  <xsl:mode on-no-match="shallow-copy"/>

  <xsl:include href="lib/library.xsl"/>
  <xsl:include href="lib/datacite-4.xsl"/>
  <xsl:include href="lib/datacite-3.xsl"/>
  <xsl:include href="lib/oai_dc.xsl"/>

  <!-- === RDF/XML ===================================================================== -->
  <xsl:template match="dct:BibliographicResource">
    <dct:BibliographicResource>
      <xsl:sequence select="* except dc:language"/>
      <xsl:for-each select="dc:language">
        <dc:language>{library:normalize-language(normalize-space(.))}</dc:language>
      </xsl:for-each>
    </dct:BibliographicResource>
  </xsl:template>

</xsl:transform>
