<p:declare-step name="main" version="1.0"
                xmlns:aggregator="https://openscience.hamburg.de/vocab/aggregator#"
                xmlns:library="tag:david.maus@sub.uni-hamburg.de,2020:Pipeline:Library"
                xmlns:c="http://www.w3.org/ns/xproc-step"
                xmlns:oai="http://www.openarchives.org/OAI/2.0/"
                xmlns:p="http://www.w3.org/ns/xproc">

  <p:documentation>
    <header>Verarbeitungspipeline für bibliographische Metadaten</header>
  </p:documentation>

  <p:output port="result" primary="true">
    <p:pipe step="prepare-result" port="result"/>
  </p:output>

  <p:output port="report">
    <p:pipe step="prepare-result" port="report"/>
  </p:output>

  <p:option name="sourceDirectory" required="true"/>

  <p:import href="lib/library.xpl"/>
  <p:import href="lib/aggregator.xpl"/>

  <p:load name="load-description">
    <p:with-option name="href" select="resolve-uri('about.rdf', resolve-uri($sourceDirectory))"/>
  </p:load>

  <p:load name="load-records">
    <p:with-option name="href" select="resolve-uri('records.xml', resolve-uri($sourceDirectory))"/>
  </p:load>

  <library:preprocess-source/>
  <library:validate-source/>

  <p:viewport match="oai:metadata">
    <library:lift/>
  </p:viewport>

  <aggregator:insert-source-description>
    <p:input port="description">
      <p:pipe step="load-description" port="result"/>
    </p:input>
  </aggregator:insert-source-description>

  <aggregator:to-solr-xml/>
  <aggregator:validate-solr-xml/>
  <aggregator:prepare-result name="prepare-result"/>

</p:declare-step>
