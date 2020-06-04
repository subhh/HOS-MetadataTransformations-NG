<xsl:transform version="3.0"
               expand-text="yes"
               xmlns:aggregator="https://openscience.hamburg.de/vocab/aggregator#"
               xmlns:dc="http://purl.org/dc/elements/1.1/"
               xmlns:dct="http://purl.org/dc/terms/"
               xmlns:geo="http://www.w3.org/2003/01/geo/wgs84_pos#"
               xmlns:hos="http://openscience.hamburg.de/ns"
               xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
               xmlns:skos="http://www.w3.org/2004/02/skos/core#"
               xmlns:xs="http://www.w3.org/2001/XMLSchema"
               xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:mode on-no-match="shallow-skip"/>

  <xsl:template match="/">
    <add>
      <xsl:apply-templates/>
    </add>
  </xsl:template>

  <xsl:template match="dct:BibliographicResource">
    <xsl:variable name="rights" select="lower-case(string-join(dc:rights))"/>
    <doc>
      <xsl:choose>
        <xsl:when test="dc:identifier[@rdf:datatype = 'https://openscience.hamburg.de/vocab/datatype#DOI']">
          <field name="identifier">
            <xsl:value-of select="dc:identifier[@rdf:datatype = 'https://openscience.hamburg.de/vocab/datatype#DOI'][1]"/>
          </field>
          <field name="url">
            <xsl:value-of select="'https://doi.org/' || dc:identifier[@rdf:datatype = 'https://openscience.hamburg.de/vocab/datatype#DOI'][1]"/>
          </field>
        </xsl:when>
        <xsl:when test="dc:identifier[@rdf:datatype = 'http://www.w3.org/2001/XMLSchema#anyURI']">
          <field name="url">
            <xsl:value-of select="dc:identifier[@rdf:datatype = 'http://www.w3.org/2001/XMLSchema#anyURI'][1]"/>
          </field>
        </xsl:when>
      </xsl:choose>
      <xsl:choose>
        <xsl:when test="matches($rights, 'open|kostenfrei|uhh-l2g|sub.uni-hamburg.de|creativecommons|creative commons|CC|opensource')">
          <field name="rightsOA">Open Access</field>
        </xsl:when>
        <xsl:otherwise>
          <field name="rightsOA">zugriffsbeschränkt</field>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates/>
    </doc>
  </xsl:template>

  <xsl:template match="aggregator:isProvidedBy/aggregator:Record">
    <field name="id">{normalize-space(dc:identifier)}</field>
    <field name="collection">{normalize-space(dct:isPartOf/aggregator:Collection/skos:prefLabel)}</field>
    <field name="internal_institution">{normalize-space(dct:isPartOf/aggregator:Collection/dct:publisher/dct:Agent/skos:prefLabel)}</field>
    <field name="internal_institution_id">{normalize-space(dct:isPartOf/aggregator:Collection/dct:publisher/dct:Agent/dc:identifier)}</field>
    <field name="internal_geoLocation">
      <xsl:value-of select="(dct:isPartOf/aggregator:Collection/dct:publisher/dct:Agent/geo:lat, dct:isPartOf/aggregator:Collection/dct:publisher/dct:Agent/geo:long)" separator=","/>
    </field>
  </xsl:template>

  <xsl:template match="dct:source/rdf:Description/dct:publisher/dct:Agent/skos:prefLabel">
    <field name="collection">{normalize-space()}</field>
  </xsl:template>


  <!-- 1. Identifikatoren -->
  <xsl:template match="dc:identifier">
    <field name="alternateIdentifier">{.}</field>
    <field name="alternateIdentifierType">{substring-after(@rdf:datatype, '#')}</field>
  </xsl:template>

  <!-- 2. Titel -->
  <xsl:template match="dc:title">
    <field name="title">{.}</field>
    <field name="titleLang">{@xml:lang}</field>
  </xsl:template>

  <!-- 3. Verfasser -->
  <xsl:template match="dct:creator">
    <xsl:if test="count(preceding-sibling::dct:creator) le 10">
      <field name="creatorName">{dct:Agent/skos:prefLabel}</field>
      <field name="creatorNameURI">
        <xsl:choose>
          <xsl:when test="dct:Agent/dc:identifier[@rdf:datatype = 'https://openscience.hamburg.de/vocab/datatype#ORCID']">
            <xsl:value-of select="'http://orcid.org/' || dct:Agent/dc:identifier[@rdf:datatype = 'https://openscience.hamburg.de/vocab/datatype#ORCID']"/>
          </xsl:when>
          <xsl:otherwise>-</xsl:otherwise>
        </xsl:choose>
      </field>
    </xsl:if>
  </xsl:template>

  <!-- 4. Datum -->
  <xsl:template match="dc:date[matches(., '^[0-9]{4}')][1]">
    <field name="publicationYear">{substring(., 1, 4)}</field>
  </xsl:template>

  <!-- 5. Publisher -->
  <xsl:template match="dc:publisher[1]">
    <field name="publisher">{.}</field>
  </xsl:template>

  <!-- 6. Materialart -->
  <xsl:template match="dc:type[not(preceding-sibling::dc:type)]">
    <field name="resourceType">{.}</field>
  </xsl:template>

  <!-- 7. Sprache -->
  <xsl:template match="dc:language[1]">
    <xsl:choose>
      <xsl:when test="preceding-sibling::dc:language">
        <field name="language">mul</field>
      </xsl:when>
      <xsl:otherwise>
        <field name="language">{.}</field>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- 8. Schlagwörter -->
  <xsl:template match="dc:subject">
    <field name="subject">{.}</field>
  </xsl:template>

  <!-- 9. Rechteangaben -->
  <xsl:template match="dc:rights">
    <field name="rights">{.}</field>
  </xsl:template>

  <!-- 10. Beschreibungen -->
  <xsl:template match="dc:description">
    <field name="description">{.}</field>
  </xsl:template>

  <!-- 11. Übergeordnete Ressource -->
  <xsl:template match="dct:relation">
    <field name="seriesInformation">{rdf:Description/skos:prefLabel}</field>
  </xsl:template>

  <!-- 12. Beiträger -->
  <xsl:template match="dct:contributor">
    <field name="contributorName">{dct:Agent/skos:prefLabel}</field>
  </xsl:template>

</xsl:transform>