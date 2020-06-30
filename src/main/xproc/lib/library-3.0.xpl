<p:library version="3.0"
           xmlns:datacite-3="http://datacite.org/schema/kernel-3"
           xmlns:datacite-4="http://datacite.org/schema/kernel-4"
           xmlns:library="tag:david.maus@sub.uni-hamburg.de,2020:Pipeline:Library"
           xmlns:oai="http://www.openarchives.org/OAI/2.0/"
           xmlns:p="http://www.w3.org/ns/xproc">

  <p:declare-step type="library:preprocess-source">
    <p:input  port="source" primary="true"/>
    <p:output port="result" primary="true"/>

    <p:delete match="oai:record[oai:header/@status eq 'deleted']"/>

    <p:xslt>
      <p:with-input port="stylesheet" href="../../xslt/lib/filter-duplicates.xsl"/>
    </p:xslt>
  </p:declare-step>

  <p:declare-step type="library:validate-source">
    <p:input  port="source" primary="true"/>
    <p:output port="result" primary="true"/>
    <p:viewport match="oai:metadata">
      <library:validate-source-record/>
    </p:viewport>
  </p:declare-step>

  <p:declare-step type="library:validate-source-record" name="validate-source-record">
    <p:input  port="source" primary="true"/>
    <p:output port="result" primary="true" sequence="true"/>

    <p:try>
      <p:group>
        <p:choose>
          <p:when test="oai:metadata//datacite-4:resource">
            <p:validate-with-xml-schema>
              <p:with-input port="source" select="oai:metadata//datacite-4:resource"/>
              <p:with-input port="schema" href="../../resources/schema/datacite4/metadata.xsd"/>
            </p:validate-with-xml-schema>
          </p:when>
          <p:when test="oai:metadata//datacite-3:resource">
            <p:validate-with-xml-schema>
              <p:with-input port="source" select="oai:metadata//datacite-3:resource"/>
              <p:with-input port="schema" href="../../resources/schema/datacite3/metadata.xsd"/>
            </p:validate-with-xml-schema>
          </p:when>
          <p:otherwise>
            <p:identity/>
          </p:otherwise>
        </p:choose>
      </p:group>
      <p:catch name="invalid">
        <p:identity>
          <p:with-input port="source" pipe="error@invalid"/>
        </p:identity>
      </p:catch>
    </p:try>

    <p:wrap match="/*" wrapper="oai:metadata"/>

  </p:declare-step>

  <p:declare-step type="library:lift">
    <p:input  port="source" primary="true"/>
    <p:output port="result" primary="true"/>
    <p:xslt>
      <p:with-input port="stylesheet" href="../../xslt/lift.xsl"/>
    </p:xslt>
  </p:declare-step>

</p:library>
