<xsl:transform version="3.0"
               expand-text="yes"
               xmlns:schaufenster="https://id.sub.uni-hamburg.de/ontology/schaufenster#"
               xmlns:aggregator="https://openscience.hamburg.de/vocab/aggregator#"
               xmlns:dc="http://purl.org/dc/elements/1.1/"
               xmlns:dct="http://purl.org/dc/terms/"
               xmlns:geo="http://www.w3.org/2003/01/geo/wgs84_pos#"
               xmlns:hos="http://openscience.hamburg.de/ns"
               xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
               xmlns:skos="http://www.w3.org/2004/02/skos/core#"
               xmlns:xs="http://www.w3.org/2001/XMLSchema"
               xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:mode on-no-match="shallow-copy"/>

  <xsl:template match="*[ancestor::dct:BibliographicResource]" priority="-10">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="text()[ancestor::dct:BibliographicResource]" priority="-10"/>

  <xsl:template match="dct:BibliographicResource">
    <xsl:variable name="rights" select="lower-case(string-join(dc:rights))"/>
    <xsl:variable name="types" select="lower-case(string-join(dc:type))"/>
    <doc>
      <xsl:choose>
        <xsl:when test="dc:identifier[@rdf:datatype = 'https://openscience.hamburg.de/vocab/datatype#DOI']">
          <field name="identifier">
            <xsl:value-of select="dc:identifier[@rdf:datatype = 'https://openscience.hamburg.de/vocab/datatype#DOI'][1]"/>
          </field>
          <field name="url">
            <xsl:value-of select="'https://doi.org/' || normalize-space(dc:identifier[@rdf:datatype = 'https://openscience.hamburg.de/vocab/datatype#DOI'][1])"/>
          </field>
        </xsl:when>
        <xsl:when test="dc:identifier[@rdf:datatype = 'http://www.w3.org/2001/XMLSchema#anyURI']">
          <field name="url">
            <xsl:value-of select="normalize-space(dc:identifier[@rdf:datatype = 'http://www.w3.org/2001/XMLSchema#anyURI'][1])"/>
          </field>
        </xsl:when>
        <xsl:when test="dc:identifier[@rdf:datatype = 'https://openscience.hamburg.de/vocab/datatype#PPN']">
          <field name="url">
            <xsl:text>https://kxp.k10plus.de/DB=2.1/PPN?PPN={dc:identifier[@rdf:datatype = 'https://openscience.hamburg.de/vocab/datatype#PPN'][1]}</xsl:text>
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
      <field name="internal_qualifikationsarbeit">
        <xsl:value-of select="if (matches($types, 'bachelor|master')) then '1' else '0'"/>
      </field>
      <xsl:apply-templates/>
    </doc>
  </xsl:template>

  <xsl:template match="aggregator:isProvidedBy/aggregator:Record">
    <!-- Im späteren Verlauf wird das Feld 'id' durch die MD5-Prüfsumme des Identifiers ersetzt -->
    <field name="id">{normalize-space(dc:identifier)}</field>
    <field name="internal_source_id">{normalize-space(dc:identifier)}</field>
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
    <field name="alternateIdentifier"><xsl:value-of select="normalize-space()"/></field>
    <field name="alternateIdentifierType">{substring-after(@rdf:datatype, '#')}</field>
  </xsl:template>

  <!-- 2. Titel -->
  <xsl:template match="dc:title">
    <field name="title"><xsl:value-of select="normalize-space()"/></field>
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
    <field name="publisher"><xsl:value-of select="normalize-space()"/></field>
  </xsl:template>

  <!-- 6. Materialart -->
  <xsl:template match="dct:type[not(preceding-sibling::dct:type)]">
    <field name="resourceType"><xsl:value-of select="normalize-space(skos:Concept/skos:prefLabel)"/></field>
  </xsl:template>

  <!-- 7. Sprache -->
  <xsl:template match="dc:language[1]">
    <xsl:choose>
      <xsl:when test="preceding-sibling::dc:language">
        <field name="language">mul</field>
      </xsl:when>
      <xsl:otherwise>
        <field name="language"><xsl:value-of select="normalize-space()"/></field>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- 8. Schlagwörter -->
  <xsl:template match="dc:subject">
    <field name="subject"><xsl:value-of select="normalize-space()"/></field>
  </xsl:template>

  <!-- 9. Rechteangaben -->
  <xsl:template match="dc:rights">
    <field name="rights"><xsl:value-of select="normalize-space()"/></field>
  </xsl:template>

  <!-- 10. Beschreibungen -->
  <xsl:template match="dc:description">
    <field name="description"><xsl:value-of select="normalize-space()"/></field>
  </xsl:template>

  <!-- 11. Beziehungen -->
  <xsl:template match="dc:relation">
    <field name="seriesInformation">{rdf:Description/skos:prefLabel}</field>
  </xsl:template>

  <xsl:template match="schaufenster:IsCitedBy | schaufenster:Cites | schaufenster:IsSupplementTo | schaufenster:IsSupplementedBy | schaufenster:IsContinuedBy | schaufenster:Continues | schaufenster:IsNewVersionOf | schaufenster:IsPreviousVersionOf | schaufenster:IsPartOf | schaufenster:HasPart | schaufenster:IsReferencedBy | schaufenster:References | schaufenster:IsDocumentedBy | schaufenster:Documents | schaufenster:IsCompiledBy | schaufenster:Compiles | schaufenster:IsVariantFormOf | schaufenster:IsOriginalFormOf | schaufenster:IsIdenticalTo | schaufenster:HasMetadata | schaufenster:IsMetadataFor | schaufenster:Reviews | schaufenster:IsReviewedBy | schaufenster:IsDerivedFrom | schaufenster:IsSourceOf | schaufenster:Describes | schaufenster:IsDescribedBy | schaufenster:HasVersion | schaufenster:IsVersionOf | schaufenster:Requires | schaufenster:IsRequiredBy | schaufenster:Obsoletes | schaufenster:IsObsoletedBy">
    <field name="relatedIdentifier">{dct:BibliographicResource/dc:identifier}</field>
    <field name="relatedIdentifierType">{substring-after(dct:BibliographicResource/dc:identifier/@rdf:datatype, '#')}</field>
    <field name="relatedIdentifierRelationType">{local-name()}</field>
  </xsl:template>

  <!-- 12. Beiträger -->
  <xsl:template match="dct:contributor">
    <field name="contributorName">{dct:Agent/skos:prefLabel}</field>
  </xsl:template>

</xsl:transform>
