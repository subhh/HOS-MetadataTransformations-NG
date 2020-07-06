<p:declare-step name="main" version="1.0"
                xmlns:aggregator="https://openscience.hamburg.de/vocab/aggregator#"
                xmlns:library="tag:david.maus@sub.uni-hamburg.de,2020:Pipeline:Library"
                xmlns:c="http://www.w3.org/ns/xproc-step"
                xmlns:oai="http://www.openarchives.org/OAI/2.0/"
                xmlns:p="http://www.w3.org/ns/xproc">

  <p:output port="result" primary="true"/>
  <p:output port="validate-source" sequence="true">
    <p:pipe step="validate-source" port="report"/>
  </p:output>
  <p:output port="validate-solr" sequence="true">
    <p:pipe step="validate-solr" port="report"/>
  </p:output>

  <p:import href="lib/library.xpl"/>
  <p:import href="lib/aggregator.xpl"/>

  <p:load name="load-description">
    <p:with-option name="href" select="resolve-uri('about.rdf', resolve-uri($sourceDirectory))"/>
  </p:load>

  <p:load name="load-records">
    <p:with-option name="href" select="resolve-uri('records.xml', resolve-uri($sourceDirectory))"/>
  </p:load>

  <library:preprocess-source/>
  <library:validate-source name="validate-source"/>

  <p:wrap-sequence wrapper="oai:Records"/>

  <p:viewport match="oai:metadata/*">
    <library:lift/>
  </p:viewport>

  <aggregator:insert-source-description>
    <p:input port="description">
      <p:pipe step="load-description" port="result"/>
    </p:input>
  </aggregator:insert-source-description>

  <aggregator:to-solr-xml/>
  <aggregator:validate-solr-xml name="validate-solr"/>
  <aggregator:create-solr-document/>

</p:declare-step>
