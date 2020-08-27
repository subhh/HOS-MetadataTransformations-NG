<xsl:transform version="3.0" expand-text="yes"
               xmlns:library="tag:david.maus@sub.uni-hamburg.de,2020:Transform:Library"
               xmlns:dc="http://purl.org/dc/elements/1.1/"
               xmlns:dct="http://purl.org/dc/terms/"
               xmlns:oai_dc="http://www.openarchives.org/OAI/2.0/oai_dc/"
               xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
               xmlns:skos="http://www.w3.org/2004/02/skos/core#"
               xmlns:xs="http://www.w3.org/2001/XMLSchema"
               xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:template match="oai_dc:dc">
    <dct:BibliographicResource>
      <xsl:apply-templates/>
      <dct:type>
        <skos:Concept>
          <skos:prefLabel>Text</skos:prefLabel>
        </skos:Concept>
      </dct:type>
    </dct:BibliographicResource>
  </xsl:template>

  <!-- 1. Identifikatoren -->
  <xsl:template match="dc:identifier[matches(normalize-space(.), 'https?')]">
    <xsl:call-template name="library:identifier">
      <xsl:with-param name="type" as="xs:string">URL</xsl:with-param>
      <xsl:with-param name="value" as="xs:string" select="normalize-space()"/>
    </xsl:call-template>
  </xsl:template>

  <!-- 2. Titel -->
  <!-- 4. Datum -->
  <!-- 5. Publisher -->
  <!-- 6. Materialart -->
  <!-- 8. Schlagwörter -->
  <!-- 9. Rechteangaben -->
  <!-- 10. Beschreibungen -->
  <!-- 11. Beziehungen -->
  <xsl:template match="dc:title | dc:date | dc:publisher | dc:type | dc:subject | dc:rights | dc:description | dc:relation">
    <xsl:copy>
      <xsl:sequence select="@xml:lang"/>
      <xsl:value-of select="normalize-space()"/>
    </xsl:copy>
  </xsl:template>

  <!-- 3. Verfasser -->
  <!-- 12. Beiträger -->
  <xsl:template match="dc:creator | dc:contributor">
    <xsl:element name="dct:{local-name()}">
      <dct:Agent>
        <skos:prefLabel>
          <xsl:value-of select="."/>
        </skos:prefLabel>
      </dct:Agent>
    </xsl:element>
  </xsl:template>

  <!-- 7. Sprache -->
  <xsl:template match="dc:language">
    <dc:language>{library:normalize-language(normalize-space(.))}</dc:language>
  </xsl:template>

</xsl:transform>
