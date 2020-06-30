<p:declare-step version="3.0"
                xmlns:p="http://www.w3.org/ns/xproc">

  <p:input  port="source" primary="true"/>
  <p:output port="result" primary="true"/>

  <p:rename match="/Records/Record" new-name="record"/>
  <p:namespace-rename apply-to="elements" from="" to="http://www.openarchives.org/OAI/2.0/"/>

</p:declare-step>
