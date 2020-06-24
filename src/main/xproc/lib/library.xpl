<p:library version="1.0"
           xmlns:datacite-3="http://datacite.org/schema/kernel-3"
           xmlns:datacite-4="http://datacite.org/schema/kernel-4"
           xmlns:library="tag:david.maus@sub.uni-hamburg.de,2020:Pipeline:Library"
           xmlns:oai="http://www.openarchives.org/OAI/2.0/"
           xmlns:p="http://www.w3.org/ns/xproc">

  <p:declare-step type="library:preprocess-source">
    <p:input  port="source" primary="true"/>
    <p:output port="result" primary="true"/>

    <p:delete match="oai:Record[oai:header/@status eq 'deleted']"/>

    <p:xslt>
      <p:input port="stylesheet">
        <p:document href="../../xslt/lib/filter-duplicates.xsl"/>
      </p:input>
      <p:input port="parameters">
        <p:empty/>
      </p:input>
    </p:xslt>
  </p:declare-step>

  <p:declare-step type="library:validate-source">
    <p:input  port="source" primary="true"/>
    <p:output port="result" primary="true"/>
    <p:viewport match="oai:Record">
      <library:validate-source-record/>
    </p:viewport>
  </p:declare-step>

  <p:declare-step type="library:validate-source-record" name="validate-source-record">
    <p:input  port="source" primary="true"/>
    <p:output port="result" primary="true" sequence="true"/>

    <p:try>
      <p:group>
        <p:choose>
          <p:when test="oai:Record/oai:metadata//datacite-4:resource">
            <p:validate-with-xml-schema>
              <p:input port="source" select="oai:Record/oai:metadata//datacite-4:resource"/>
              <p:input port="schema">
                <p:document href="../../resources/schema/datacite4/metadata.xsd"/>
              </p:input>
            </p:validate-with-xml-schema>
            <p:identity>
              <p:input port="source">
                <p:pipe step="validate-source-record" port="source"/>
              </p:input>
            </p:identity>
          </p:when>
          <p:when test="oai:Record/oai:metadata//datacite-3:resource">
            <p:validate-with-xml-schema>
              <p:input port="source" select="oai:Record/oai:metadata//datacite-3:resource"/>
              <p:input port="schema">
                <p:document href="../../resources/schema/datacite3/metadata.xsd"/>
              </p:input>
            </p:validate-with-xml-schema>
            <p:identity>
              <p:input port="source">
                <p:pipe step="validate-source-record" port="source"/>
              </p:input>
            </p:identity>
          </p:when>
          <p:otherwise>
            <p:identity/>
          </p:otherwise>
        </p:choose>
        <p:identity/>
      </p:group>
      <p:catch name="invalid">
        <p:identity>
          <p:input port="source">
            <p:pipe port="error" step="invalid"/>
          </p:input>
        </p:identity>
      </p:catch>
    </p:try>

  </p:declare-step>

  <p:declare-step type="library:lift">
    <p:input  port="source" primary="true"/>
    <p:output port="result" primary="true"/>
    <p:xslt>
      <p:input port="stylesheet">
        <p:document href="../../xslt/lift.xsl"/>
      </p:input>
      <p:input port="parameters">
        <p:empty/>
      </p:input>
    </p:xslt>
  </p:declare-step>

</p:library>
