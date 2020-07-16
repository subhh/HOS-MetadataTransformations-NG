<xsl:transform version="3.0" expand-text="yes"
               xmlns:schaufenster="https://id.sub.uni-hamburg.de/ontology/schaufenster#"
               xmlns:library="tag:david.maus@sub.uni-hamburg.de,2020:Transform:Library"
               xmlns:dc="http://purl.org/dc/elements/1.1/"
               xmlns:dct="http://purl.org/dc/terms/"
               xmlns:datacite-3="http://datacite.org/schema/kernel-3"
               xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
               xmlns:skos="http://www.w3.org/2004/02/skos/core#"
               xmlns:xs="http://www.w3.org/2001/XMLSchema"
               xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- === DataCite 3 ================================================================== -->
  <xsl:template match="datacite-3:resource">
    <dct:BibliographicResource>
      <xsl:apply-templates/>
    </dct:BibliographicResource>
  </xsl:template>

  <!-- 1. Identifikatoren -->
  <xsl:template match="datacite-3:identifier">
    <xsl:call-template name="library:identifier">
      <xsl:with-param name="type" select="@identifierType" as="xs:string"/>
      <xsl:with-param name="value" select="normalize-space()" as="xs:string"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="datacite-3:alternateIdentifier">
    <xsl:call-template name="library:identifier">
      <xsl:with-param name="type" select="@alternateIdentifierType" as="xs:string"/>
      <xsl:with-param name="value" select="normalize-space()" as="xs:string"/>
    </xsl:call-template>
  </xsl:template>

  <!-- 2. Titel -->
  <xsl:template match="datacite-3:title[not(@titleType)]">
    <dc:title>
      <xsl:sequence select="@xml:lang"/>
      <xsl:value-of select="normalize-space()"/>
      <xsl:if test="../datacite-3:title[@titleType = 'Subtitle']">
        <xsl:value-of select="' : ' || ../datacite-3:title[@titleType = 'Subtitle']"/>
      </xsl:if>
    </dc:title>
  </xsl:template>

  <!-- 3. Verfasser -->
  <xsl:template match="datacite-3:creator">
    <dct:creator>
      <dct:Agent>
        <skos:prefLabel>
          <xsl:value-of select="normalize-space(datacite-3:creatorName)"/>
        </skos:prefLabel>
        <xsl:for-each select="datacite-3:nameIdentifier">
          <xsl:call-template name="library:nameIdentifier">
            <xsl:with-param name="scheme" select="@nameIdentifierScheme" as="xs:string"/>
            <xsl:with-param name="value" select="normalize-space()" as="xs:string"/>
          </xsl:call-template>
        </xsl:for-each>
      </dct:Agent>
    </dct:creator>
  </xsl:template>

  <!-- 4. Datum -->
  <xsl:template match="datacite-3:publicationYear">
    <dc:date>
      <xsl:value-of select="normalize-space()"/>
    </dc:date>
  </xsl:template>

  <!-- 5. Publisher -->
  <xsl:template match="datacite-3:publisher">
    <dc:publisher>
      <xsl:sequence select="@xml:lang"/>
      <xsl:value-of select="normalize-space()"/>
    </dc:publisher>
  </xsl:template>

  <!-- 6. Materialart -->
  <xsl:template match="datacite-3:resourceType[@resourceTypeGeneral]">
    <xsl:where-populated>
      <dc:type>
        <xsl:value-of select="@resourceTypeGeneral"/>
      </dc:type>
    </xsl:where-populated>
  </xsl:template>

  <!-- 7. Sprache -->
  <xsl:template match="datacite-3:language">
    <dc:language>{library:normalize-language(normalize-space(.))}</dc:language>
  </xsl:template>

  <!-- 8. Schlagwörter -->
  <xsl:template match="datacite-3:subject">
    <dc:subject>
      <xsl:sequence select="@xml:lang"/>
      <xsl:value-of select="normalize-space()"/>
    </dc:subject>
  </xsl:template>

  <!-- 9. Rechteangaben -->
  <xsl:template match="datacite-3:rights">
    <dc:rights>
      <xsl:sequence select="@xml:lang"/>
      <xsl:value-of select="(@rightsIdentifier, @rightsURI, .)[1]"/>
    </dc:rights>
  </xsl:template>

  <!-- 10. Beschreibungen -->
  <xsl:template match="datacite-3:description[@descriptionType = 'Abstract']">
    <dc:description>
      <xsl:sequence select="@xml:lang"/>
      <xsl:value-of select="normalize-space()"/>
    </dc:description>
  </xsl:template>

  <xsl:template match="datacite-3:description[@descriptionType = 'Other']">
    <dc:description>
      <xsl:sequence select="@xml:lang"/>
      <xsl:value-of select="normalize-space()"/>
    </dc:description>
  </xsl:template>

  <!-- 11. Beziehungen -->
  <xsl:template match="datacite-3:description[@descriptionType = 'SeriesInformation']">
    <dct:relation>
      <rdf:Description>
        <skos:prefLabel>
          <xsl:sequence select="@xml:lang"/>
          <xsl:value-of select="normalize-space()"/>
        </skos:prefLabel>
      </rdf:Description>
    </dct:relation>
  </xsl:template>

  <xsl:template match="datacite-3:relatedIdentifier">
    <xsl:element name="schaufenster:{@relationType}">
      <dct:BibliographicResource>
        <xsl:call-template name="library:identifier">
          <xsl:with-param name="type" select="@relatedIdentifierType" as="xs:string"/>
          <xsl:with-param name="value" select="normalize-space()" as="xs:string"/>
        </xsl:call-template>
      </dct:BibliographicResource>
    </xsl:element>
  </xsl:template>

  <!-- 12. Beiträger -->
  <xsl:template match="datacite-3:contributor">
    <dct:contributor>
      <dct:Agent>
        <skos:prefLabel>
          <xsl:value-of select="normalize-space(datacite-3:contributorName)"/>
        </skos:prefLabel>
        <xsl:for-each select="datacite-3:nameIdentifier">
          <xsl:call-template name="library:nameIdentifier">
            <xsl:with-param name="scheme" select="@nameIdentifierScheme" as="xs:string"/>
            <xsl:with-param name="value" select="normalize-space()" as="xs:string"/>
          </xsl:call-template>
        </xsl:for-each>
      </dct:Agent>
    </dct:contributor>
  </xsl:template>

</xsl:transform>
