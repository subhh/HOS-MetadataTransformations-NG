<p:declare-step name="main" version="3.0"
                xmlns:aggregator="https://openscience.hamburg.de/vocab/aggregator#"
                xmlns:library="tag:david.maus@sub.uni-hamburg.de,2020:Pipeline:Library"
                xmlns:c="http://www.w3.org/ns/xproc-step"
                xmlns:oai="http://www.openarchives.org/OAI/2.0/"
                xmlns:p="http://www.w3.org/ns/xproc">

  <p:documentation>
    <header>Verarbeitungspipeline für bibliographische Metadaten</header>
  </p:documentation>

  <p:import href="lib/library-3.0.xpl"/>
  <p:import href="lib/aggregator-3.0.xpl"/>
    
  <p:output port="result" primary="true"/>

  <p:option name="sourceDirectory" required="true"/>

  <p:load name="load-description" href="{resolve-uri('about.rdf', resolve-uri($sourceDirectory))}"/>

  <p:load name="load-records" href="{resolve-uri('records.xml', resolve-uri($sourceDirectory))}"/>

  <library:preprocess-source/>
  <library:validate-source/>

  <p:viewport match="oai:metadata">
    <library:lift/>
  </p:viewport>

  <aggregator:insert-source-description>
    <p:with-input port="description" pipe="result@load-description"/>
  </aggregator:insert-source-description>

  <aggregator:to-solr-xml/>
  <aggregator:validate-solr-xml/>

</p:declare-step>
