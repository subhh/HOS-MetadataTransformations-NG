<p:library version="3.0"
           xmlns:aggregator="https://openscience.hamburg.de/vocab/aggregator#"
           xmlns:c="http://www.w3.org/ns/xproc-step"
           xmlns:dc="http://purl.org/dc/elements/1.1/"
           xmlns:dct="http://purl.org/dc/terms/"
           xmlns:p="http://www.w3.org/ns/xproc"
           xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">

  <p:declare-step type="aggregator:insert-source-description" name="insert-source-description">
    <p:input  port="source" primary="true"/>
    <p:input  port="description" primary="false"/>
    <p:output port="result" primary="true">
      <p:pipe step="insert" port="result"/>
    </p:output>

    <p:viewport match="Record" name="insert">
      <p:with-input pipe="source@insert-source-description"/>
      <p:variable name="dc:identifier" select="Record/header/identifier"/>
      <p:variable name="dct:modified" select="substring(Record/header/datestamp, 1, 10)"/>
      <p:insert match="Record/dct:BibliographicResource" position="first-child">
        <p:with-input port="insertion">
          <p:inline>
            <aggregator:isProvidedBy>
              <aggregator:Record>
                <dc:identifier>.</dc:identifier>
                <dct:modified rdf:datatype="http://www.w3.org/2001/XMLSchema#date">.</dct:modified>
                <dct:isPartOf>
                  <aggregator:Collection/>
                </dct:isPartOf>
              </aggregator:Record>
            </aggregator:isProvidedBy>
          </p:inline>
        </p:with-input>
      </p:insert>
      <p:string-replace match="Record/dct:BibliographicResource/aggregator:isProvidedBy/aggregator:Record/dc:identifier/text()">
        <p:with-option name="replace" select="concat('&quot;', $dc:identifier, '&quot;')"/>
      </p:string-replace>
      <p:string-replace match="Record/dct:BibliographicResource/aggregator:isProvidedBy/aggregator:Record/dct:modified/text()">
        <p:with-option name="replace" select="concat('&quot;', $dct:modified, '&quot;')"/>
      </p:string-replace>
      <p:insert match="Record/dct:BibliographicResource/aggregator:isProvidedBy/aggregator:Record/dct:isPartOf/aggregator:Collection" position="last-child">
        <p:with-input port="insertion" pipe="description@insert-source-description" select="/rdf:RDF/rdf:Description/*"/>
      </p:insert>
      <p:insert match="Record/dct:BibliographicResource/aggregator:isProvidedBy/aggregator:Record" position="last-child">
        <p:with-input port="insertion" pipe="current@insert" select="Record/header/setSpec"/>
      </p:insert>
      <p:rename match="Record/dct:BibliographicResource/aggregator:isProvidedBy/aggregator:Record/setSpec" new-name="dc:subject"/>
    </p:viewport>

  </p:declare-step>

  <p:declare-step type="aggregator:to-solr-xml">
    <p:input  port="source" primary="true"/>
    <p:output port="result" primary="true"/>

    <p:xslt>
      <p:with-input port="stylesheet" href="../../xslt/solr.xsl"/>
    </p:xslt>

    <p:viewport match="field[@name = 'id']">
      <p:hash match="text()" algorithm="md" version="5" value="{normalize-space(.)}"/>
    </p:viewport>

  </p:declare-step>

  <p:declare-step type="aggregator:validate-solr-xml">
    <p:input  port="source" primary="true"/>
    <p:output port="result" primary="true"/>

    <p:viewport match="doc">
      <aggregator:validate-solr-xml-record/>
    </p:viewport>

  </p:declare-step>

  <p:declare-step type="aggregator:validate-solr-xml-record">
    <p:input  port="source" primary="true"/>
    <p:output port="result" primary="true" sequence="true"/>

    <p:try>
      <p:group>
        <p:validate-with-schematron>
          <p:with-input port="schema" href="../../resources/schema/solr-aggregator.sch"/>
        </p:validate-with-schematron>
      </p:group>
      <p:catch name="invalid">
        <p:identity>
          <p:with-input port="source">
            <p:empty/>
          </p:with-input>
        </p:identity>
      </p:catch>
    </p:try>

  </p:declare-step>

</p:library>
