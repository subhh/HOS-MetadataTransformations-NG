<p:library version="1.0"
           xmlns:aggregator="https://openscience.hamburg.de/vocab/aggregator#"
           xmlns:c="http://www.w3.org/ns/xproc-step"
           xmlns:dc="http://purl.org/dc/elements/1.1/"
           xmlns:dct="http://purl.org/dc/terms/"
           xmlns:oai="http://www.openarchives.org/OAI/2.0/"
           xmlns:p="http://www.w3.org/ns/xproc"
           xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
           xmlns:svrl="http://purl.oclc.org/dsdl/svrl">

  <p:declare-step type="aggregator:insert-source-description" name="insert-source-description">
    <p:input  port="source" primary="true"/>
    <p:input  port="description" primary="false"/>
    <p:output port="result" primary="true">
      <p:pipe step="insert" port="result"/>
    </p:output>

    <p:viewport match="oai:record" name="insert">
      <p:viewport-source>
        <p:pipe step="insert-source-description" port="source"/>
      </p:viewport-source>
      <p:variable name="dc:identifier" select="oai:record/oai:header/oai:identifier"/>
      <p:variable name="dct:modified" select="substring(oai:record/oai:header/oai:datestamp, 1, 10)"/>
      <p:insert match="oai:record/oai:metadata/dct:BibliographicResource" position="first-child">
        <p:input port="insertion">
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
        </p:input>
      </p:insert>
      <p:string-replace match="oai:record/oai:metadata/dct:BibliographicResource/aggregator:isProvidedBy/aggregator:Record/dc:identifier/text()">
        <p:with-option name="replace" select="concat('&quot;', $dc:identifier, '&quot;')"/>
      </p:string-replace>
      <p:string-replace match="oai:record/oai:metadata/dct:BibliographicResource/aggregator:isProvidedBy/aggregator:Record/dct:modified/text()">
        <p:with-option name="replace" select="concat('&quot;', $dct:modified, '&quot;')"/>
      </p:string-replace>
      <p:insert match="oai:record/oai:metadata/dct:BibliographicResource/aggregator:isProvidedBy/aggregator:Record/dct:isPartOf/aggregator:Collection" position="last-child">
        <p:input port="insertion" select="/rdf:RDF/rdf:Description/*">
          <p:pipe step="insert-source-description" port="description"/>
        </p:input>
      </p:insert>
      <p:insert match="oai:record/oai:metadata/dct:BibliographicResource/aggregator:isProvidedBy/aggregator:Record" position="last-child">
        <p:input port="insertion" select="oai:record/oai:header/oai:setSpec">
          <p:pipe step="insert" port="current"/>
        </p:input>
      </p:insert>
      <p:rename match="oai:record/oai:metadata/dct:BibliographicResource/aggregator:isProvidedBy/aggregator:Record/oai:setSpec"
                new-name="subject" new-prefix="dc" new-namespace="http://purl.org/dc/elements/1.1/"/>
    </p:viewport>

  </p:declare-step>

  <p:declare-step type="aggregator:to-solr-xml">
    <p:input  port="source" primary="true"/>
    <p:output port="result" primary="true"/>

    <p:xslt>
      <p:input port="stylesheet">
        <p:document href="../../xslt/solr.xsl"/>
      </p:input>
      <p:input port="parameters">
        <p:empty/>
      </p:input>
    </p:xslt>

    <p:viewport match="field[@name = 'id']">
      <p:hash match="text()" algorithm="md" version="5">
        <p:with-option name="value" select="normalize-space(.)"/>
        <p:input port="parameters">
          <p:empty/>
        </p:input>
      </p:hash>
    </p:viewport>

  </p:declare-step>

  <p:declare-step type="aggregator:validate-solr-xml">
    <p:input  port="source" primary="true"/>
    <p:output port="result" primary="true" sequence="true">
      <p:pipe step="split-sequence" port="not-matched"/>
    </p:output>

    <p:output port="report" sequence="true">
      <p:pipe step="split-sequence" port="matched"/>
    </p:output>

    <p:viewport match="doc">
      <aggregator:validate-solr-xml-record/>
    </p:viewport>

    <p:split-sequence name="split-sequence" test="oai:record[oai:metadata/svrl:schematron-output]"/>

  </p:declare-step>

  <p:declare-step type="aggregator:validate-solr-xml-record">
    <p:input  port="source" primary="true"/>
    <p:output port="result" primary="true" sequence="true"/>

    <p:validate-with-schematron name="validate" assert-valid="false">
      <p:input port="schema">
        <p:document href="../../resources/schema/solr-aggregator.sch"/>
      </p:input>
      <p:input port="parameters">
        <p:empty/>
      </p:input>
    </p:validate-with-schematron>

    <p:choose>
      <p:xpath-context>
        <p:pipe step="validate" port="report"/>
      </p:xpath-context>
      <p:when test="/svrl:schematron-output/svrl:failed-assert | /svrl:schematron-output/svrl:successful-report">
        <p:identity>
          <p:input port="source">
            <p:pipe step="validate" port="report"/>
          </p:input>
        </p:identity>
      </p:when>
      <p:otherwise>
        <p:identity>
          <p:input port="source">
            <p:pipe step="validate" port="result"/>
          </p:input>
        </p:identity>
      </p:otherwise>
    </p:choose>

  </p:declare-step>

  <p:declare-step type="aggregator:create-solr-document">
    <p:input  port="source" sequence="true"/>
    <p:output port="result"/>

    <p:filter select="//doc"/>
    <p:wrap-sequence wrapper="add"/>

  </p:declare-step>

</p:library>
