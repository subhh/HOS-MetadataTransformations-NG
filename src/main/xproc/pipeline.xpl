<p:declare-step name="main" version="1.0"
                xmlns:aggregator="https://openscience.hamburg.de/vocab/aggregator#"
                xmlns:library="tag:david.maus@sub.uni-hamburg.de,2020:Pipeline:Library"
                xmlns:c="http://www.w3.org/ns/xproc-step"
                xmlns:p="http://www.w3.org/ns/xproc">

  <p:documentation>
    <header>Verarbeitungspipeline für bibliographische Metadaten</header>
  </p:documentation>

  <p:input  port="source" primary="true"/>
  <p:output port="result" primary="true"/>

  <p:option name="sourceId" required="true"/>

  <p:import href="lib/library.xpl"/>
  <p:import href="lib/aggregator.xpl"/>

  <library:preprocess-source/>
  <library:validate-source/>

  <p:viewport match="metadata">
    <library:lift/>
  </p:viewport>

  <aggregator:insert-source-description>
    <p:with-option name="sourceId" select="$sourceId"/>
  </aggregator:insert-source-description>

  <aggregator:to-solr-xml/>
  <aggregator:validate-solr-xml/>

</p:declare-step>
