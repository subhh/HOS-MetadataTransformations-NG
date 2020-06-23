<p:library version="3.0"
           xmlns:library="tag:david.maus@sub.uni-hamburg.de,2020:Pipeline:Library"
           xmlns:oai="http://www.openarchives.org/OAI/2.0/"
           xmlns:p="http://www.w3.org/ns/xproc">

  <p:declare-step type="library:preprocess-source">
    <p:input  port="source" primary="true"/>
    <p:output port="result" primary="true"/>

    <p:delete match="oai:Record[oai:header/@status eq 'deleted']"/>

    <p:xslt>
      <p:with-input port="stylesheet" href="../../xslt/lib/filter-duplicates.xsl"/>
    </p:xslt>
  </p:declare-step>

  <p:declare-step type="library:validate-source">
    <p:input  port="source" primary="true"/>
    <p:output port="result" primary="true"/>
    <p:identity/>
  </p:declare-step>

  <p:declare-step type="library:lift">
    <p:input  port="source" primary="true"/>
    <p:output port="result" primary="true"/>
    <p:xslt>
      <p:with-input port="stylesheet" href="../../xslt/lift.xsl"/>
    </p:xslt>
  </p:declare-step>

</p:library>
