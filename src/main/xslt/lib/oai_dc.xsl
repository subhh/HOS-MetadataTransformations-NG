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
      <dc:type>Text</dc:type>
    </dct:BibliographicResource>
  </xsl:template>

  <!-- 1. Identifikatoren -->
  <xsl:template match="dc:identifier[matches(normalize-space(.), 'https?')]">
    <dc:identifier rdf:datatype="http://www.w3.org/2001/XMLSchema#anyURI">
      <xsl:value-of select="normalize-space()"/>
    </dc:identifier>
  </xsl:template>

  <xsl:template match="dc:identifier[matches(normalize-space(.), 'https?://doi.org')]" priority="5">
    <dc:identifier rdf:datatype="https://openscience.hamburg.de/vocab/datatype#DOI">
      <xsl:value-of select="substring-after(normalize-space(), 'doi.org/')"/>
    </dc:identifier>
  </xsl:template>
  
  <!-- 2. Titel -->
  <!-- 4. Datum -->
  <!-- 5. Publisher -->
  <!-- 8. Schlagwörter -->
  <!-- 9. Rechteangaben -->
  <!-- 10. Beschreibungen -->
  <!-- 11. Übergeordnete Ressource -->
  <xsl:template match="dc:identifier | dc:title | dc:date | dc:publisher | dc:subject | dc:rights | dc:description | dc:relation">
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

  <!-- 6. Materialart -->
  <xsl:template match="dc:type"/>

  <!-- 7. Sprache -->
  <xsl:template match="dc:language">
    <dc:language>{library:normalize-language(normalize-space(.))}</dc:language>
  </xsl:template>

</xsl:transform>
